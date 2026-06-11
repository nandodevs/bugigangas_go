import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/cache/cache_provider.dart';
import '../../../core/cache/cache_service.dart';
import '../../../core/database/neon_service.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/domain/user_model.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/package_repository.dart';
import '../domain/package_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Notifier that holds the list of tracked packages, persisted in Neon + Hive.
// Cache-first strategy: show cached data instantly, then update from Neon.
//
// IMPORTANT: This notifier receives a [Ref] instead of a static [userId]
// because [authStateProvider] is a FutureProvider that resolves AFTER the
// notifier is created.  Using ref.watch(authStateProvider) in the factory
// would cause the entire notifier to be RECREATED when auth resolves, which
// would discard any packages the user added in the meantime (see Riverpod
// discussion #1176).  Instead we hold a Ref and read userId dynamically.
// ─────────────────────────────────────────────────────────────────────────────

class PackageListNotifier extends StateNotifier<List<PackageModel>> {
  PackageListNotifier(
    this._repository,
    this._neon,
    this._cache,
    this._ref,
  ) : super([]) {
    _initialize();
    // Listen for auth state changes to reload packages with the correct userId.
    // This avoids recreating the notifier when auth resolves (which would
    // discard in-memory packages). See https://github.com/rrousselGit/riverpod/discussions/1176
    _ref.listen(authStateProvider, (_, next) {
      next.whenOrNull(
        data: (UserModel? user) {
          // Reload with the actual userId once auth resolves
          _loadPackages(user?.id);
        },
      );
    });
  }

  final PackageRepository _repository;
  final NeonService _neon;
  final CacheService _cache;
  final Ref _ref;

  /// Reads the current user ID from the auth provider dynamically.
  /// By the time the user interacts with the UI, the FutureProvider has
  /// almost certainly resolved, so this returns the correct value.
  int? get _userId => _ref.read(authStateProvider).valueOrNull?.id;

  // ── Initialization (cache-first) ────────────────────────────────────────

  Future<void> _initialize() async {
    try {
      // 1. Load from cache first (instant, synchronous)
      final cached = _cache.getCachedPackages(null);
      if (cached != null) {
        state = cached;
      }
      // 2. Load from Neon with whatever userId is available now.
      //    If auth hasn't resolved yet, the listener above will reload
      //    with the actual userId once auth resolves.
      await _loadPackages(_userId);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // ── Load from Neon ──────────────────────────────────────────────────────

  /// Carrega pacotes do Neon usando user_id (pode ser null para anônimo).
  ///
  /// Estratégia: só sobrescreve o estado (cache) se o Neon retornar dados.
  /// Se o Neon retornar vazio ou falhar, o estado do cache é preservado
  /// para evitar que pacotes pareçam "desaparecer" após reiniciar o app.
  Future<void> _loadPackages(int? userId) async {
    try {
      final packages = await _neon.getUserPackages(userId);
      if (packages.isNotEmpty) {
        state = packages;
        await _cache.cachePackages(userId, packages);
      } else {
        debugPrint(
          'PackageListNotifier._loadPackages: Neon retornou vazio — '
          'mantendo estado do cache (${state.length} pacotes)',
        );
      }
    } catch (e) {
      debugPrint('PackageListNotifier._loadPackages error: $e');
      // Cache fallback is already applied in _initialize
    }
  }

  // ── CRUD ────────────────────────────────────────────────────────────────

  /// Refresh all packages from the repository and persist to Neon + cache.
  Future<void> refresh() async {
    if (state.isEmpty) return;
    final userId = _userId;
    final updated = await Future.wait(
      state.map((p) => _repository.getPackage(p.code)).toList(),
    );
    state = updated;
    await _cache.cachePackages(userId, updated);
    // Also persist to Neon
    for (final p in updated) {
      try {
        await _neon.updatePackage(userId, p);
      } catch (e) {
        debugPrint('Refresh persist error: $e');
      }
    }
  }

  /// Add a new package by tracking code. Persists to Neon and cache.
  Future<void> addPackage(String code) async {
    if (state.any((p) => p.code == code)) return;

    final userId = _userId;
    final package = await _repository.getPackage(code);
    state = [...state, package];
    await _cache.cachePackages(userId, state);

    try {
      await _neon.insertPackage(userId, package);
    } catch (e) {
      debugPrint('PackageListNotifier.addPackage persist error: $e');
    }
  }

  /// Add a new package with code, custom name, and tags. Persists to Neon and cache.
  Future<void> addPackageWithDetails({
    required String code,
    String description = '',
    List<String> tags = const [],
  }) async {
    if (state.any((p) => p.code == code)) return;

    final userId = _userId;
    final package = await _repository.getPackage(code);

    final enhancedPackage = package.copyWith(
      description: description.isNotEmpty ? description : package.description,
      tags: tags,
    );

    state = [...state, enhancedPackage];
    await _cache.cachePackages(userId, state);

    debugPrint('addPackageWithDetails: BEFORE Neon insert (userId=$userId)');
    try {
      await _neon.insertPackage(userId, enhancedPackage);
      debugPrint('addPackageWithDetails: Neon insert SUCCEEDED');
    } catch (e) {
      debugPrint('addPackageWithDetails: Neon insert FAILED: $e');
    }
  }

  /// Update a package's description and/or tags. Persists to Neon and cache.
  Future<void> updatePackage(
    String code, {
    String? description,
    List<String>? tags,
  }) async {
    final index = state.indexWhere((p) => p.code == code);
    if (index == -1) return;

    final userId = _userId;
    final current = state[index];
    final updated = current.copyWith(
      description: description ?? current.description,
      tags: tags ?? current.tags,
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
    await _cache.cachePackages(userId, state);

    try {
      await _neon.updatePackage(userId, updated);
    } catch (e) {
      debugPrint('PackageListNotifier.updatePackage persist error: $e');
    }
  }

  /// Remove a package from the list. Persists to Neon and cache.
  Future<void> removePackage(String code) async {
    final userId = _userId;
    if (userId == null) {
      state = state.where((p) => p.code != code).toList();
      await _cache.clearPackages(null);
      return;
    }
    state = state.where((p) => p.code != code).toList();
    await _cache.cachePackages(userId, state);

    _neon.deletePackage(userId, code).catchError((e) {
      debugPrint('PackageListNotifier.removePackage error: $e');
    });
  }

  /// Archive a package (marks it as archived in Neon).
  Future<void> archivePackage(String code) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint('Cannot archive: no active session');
      return;
    }
    state = state.map((p) {
      if (p.code == code) return p.copyWith(archived: true);
      return p;
    }).toList();
    await _cache.cachePackages(userId, state);

    try {
      await _neon.archivePackage(userId, code);
    } catch (e) {
      debugPrint('PackageListNotifier.archivePackage error: $e');
    }
  }

  /// Unarchive a package (restores it).
  Future<void> unarchivePackage(String code) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint('Cannot unarchive: no active session');
      return;
    }
    state = state.map((p) {
      if (p.code == code) return p.copyWith(archived: false);
      return p;
    }).toList();
    await _cache.cachePackages(userId, state);

    try {
      await _neon.unarchivePackage(userId, code);
    } catch (e) {
      debugPrint('PackageListNotifier.unarchivePackage error: $e');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final packageListProvider =
    StateNotifierProvider<PackageListNotifier, List<PackageModel>>((ref) {
  final repository = ref.watch(packageRepositoryProvider);
  final neon = ref.watch(neonServiceProvider);
  final cache = ref.watch(cacheServiceProvider);
  // IMPORTANT: Do NOT ref.watch(authStateProvider) here — it would recreate
  // the notifier when auth resolves, losing any in-memory packages.
  // Instead we pass [ref] and read userId dynamically inside the notifier.
  return PackageListNotifier(repository, neon, cache, ref);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final statusFilterProvider = StateProvider<int>((ref) => 0);

final filteredPackageListProvider = Provider<List<PackageModel>>((ref) {
  final packages = ref.watch(packageListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filterIndex = ref.watch(statusFilterProvider);

  // Apply status filter first
  final statusFiltered = packages.where((package) {
    final category = StatusBadge.categorizeStatus(package.status);
    switch (filterIndex) {
      case 0: // Pendentes
        return !package.archived &&
            (category == StatusCategory.processing ||
                category == StatusCategory.inTransit ||
                category == StatusCategory.exception);
      case 1: // Pra Entregar
        return !package.archived &&
            category == StatusCategory.outForDelivery;
      case 2: // Entregues
        return !package.archived &&
            category == StatusCategory.delivered;
      case 3: // Arquivados
        return package.archived;
      default:
        return true;
    }
  });

  // Apply search query filter on top of status filter
  if (query.isEmpty) return statusFiltered.toList();

  return statusFiltered.where((package) {
    return package.code.toLowerCase().contains(query) ||
        package.description.toLowerCase().contains(query) ||
        package.tags.any((t) => t.toLowerCase().contains(query));
  }).toList();
});

/// Indicates whether the initial package list is still loading.
final isLoadingProvider = StateProvider<bool>((ref) => true);

/// Looks up a single package by its tracking code.
final packageByCodeProvider =
    Provider.family<PackageModel?, String>((ref, code) {
  final packages = ref.watch(packageListProvider);
  return packages.where((p) => p.code == code).firstOrNull;
});
