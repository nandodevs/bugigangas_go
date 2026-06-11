import 'package:hive/hive.dart';
import '../../features/tracking/domain/package_model.dart';

/// Local caching service using Hive.
///
/// Provides fast offline access to packages and settings.
/// Data is cached as JSON strings inside Hive boxes.
class CacheService {
  static const String _packagesBox = 'packages_cache';
  static const String _settingsBox = 'settings_cache';

  late Box _packagesBoxInstance;
  late Box _settingsBoxInstance;

  /// Initializes Hive boxes. Must be called once before use.
  Future<void> init() async {
    _packagesBoxInstance = await Hive.openBox(_packagesBox);
    _settingsBoxInstance = await Hive.openBox(_settingsBox);
  }

  // ── Packages cache ──────────────────────────────────────────────

  /// Caches the list of packages for a given user (or anonymous).
  Future<void> cachePackages(int? userId, List<PackageModel> packages) async {
    final key = 'packages_${userId ?? 'anonymous'}';
    final jsonList = packages
        .map((p) => {
              ...p.toJson(),
              'events': p.events.map((e) => e.toJson()).toList(),
            })
        .toList();
    await _packagesBoxInstance.put(key, jsonList);
  }

  /// Returns cached packages for a user, or `null` if not cached.
  List<PackageModel>? getCachedPackages(int? userId) {
    final key = 'packages_${userId ?? 'anonymous'}';
    final data = _packagesBoxInstance.get(key) as List<dynamic>?;
    if (data == null) return null;
    return data
        .map((json) =>
            PackageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Clears cached packages for a specific user.
  Future<void> clearPackages(int? userId) async {
    final key = 'packages_${userId ?? 'anonymous'}';
    await _packagesBoxInstance.delete(key);
  }

  // ── Settings cache ──────────────────────────────────────────────

  /// Caches a setting key-value pair locally.
  Future<void> cacheSetting(String key, String value) async {
    await _settingsBoxInstance.put(key, value);
  }

  /// Returns a cached setting value, or `null`.
  String? getCachedSetting(String key) {
    return _settingsBoxInstance.get(key) as String?;
  }

  /// Clears all cached data.
  Future<void> clearAll() async {
    await _packagesBoxInstance.clear();
    await _settingsBoxInstance.clear();
  }
}
