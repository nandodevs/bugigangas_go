import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../l10n/app_strings.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/staggered_animation_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../tracking/domain/package_model.dart';
import '../../tracking/presentation/add_package_sheet.dart';
import '../../tracking/presentation/edit_package_sheet.dart';
import '../../tracking/presentation/tracking_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddPackageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddPackageSheet(),
    );
  }

  void _showPackageActions(
    BuildContext context,
    WidgetRef ref,
    PackageModel package,
  ) {
    HapticFeedback.mediumImpact();
    final strings = AppStrings.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.description.isNotEmpty
                          ? package.description
                          : package.code,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.code,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              // Ver Detalhes
              ListTile(
                leading: const Icon(AppIcons.visibility),
                title: Text(strings.homeViewDetails),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/tracking/${package.code}');
                },
              ),
              // Editar
              ListTile(
                leading: const Icon(AppIcons.edit),
                title: Text(strings.homeEdit),
                onTap: () {
                  Navigator.of(ctx).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => EditPackageSheet(package: package),
                  );
                },
              ),
              // Arquivar
              ListTile(
                leading: Icon(
                  package.archived ? AppIcons.unarchive : AppIcons.archive,
                ),
                title: Text(
                  package.archived
                      ? strings.homeUnarchive
                      : strings.homeArchive,
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (package.archived) {
                    ref
                        .read(packageListProvider.notifier)
                        .unarchivePackage(package.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.homePackageUnarchived)),
                    );
                  } else {
                    ref
                        .read(packageListProvider.notifier)
                        .archivePackage(package.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.homePackageArchived)),
                    );
                  }
                },
              ),
              // Excluir
              ListTile(
                leading: const Icon(AppIcons.delete, color: Colors.red),
                title: Text(
                  strings.homeDelete,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmDelete(context, ref, package);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PackageModel package,
  ) {
    final strings = AppStrings.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.homeDelete),
        content: Text(strings.homeConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.trackingCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(packageListProvider.notifier)
                  .removePackage(package.code);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.homePackageDeleted)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(strings.homeDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(filteredPackageListProvider);
    final query = ref.watch(searchQueryProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showAddPackageSheet(context);
        },
        backgroundColor: const Color(0xFF00A6CD),
        foregroundColor: Colors.white,
        child: const Icon(AppIcons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ──────────────────────────────────────
          SliverToBoxAdapter(
            child: _GradientHeader(
              searchQuery: query,
              onSearchChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),

          // ── Quick Filters ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _QuickFilters(
              selectedIndex: ref.watch(statusFilterProvider),
              onFilterChanged: (index) =>
                  ref.read(statusFilterProvider.notifier).state = index,
            ),
          ),

          // ── Shimmer Loading ─────────────────────────────────────
          if (isLoading && packages.isEmpty)
            const SliverToBoxAdapter(child: _ShimmerLoading())
          // ── Empty State ─────────────────────────────────────────
          else if (packages.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyPackages(
                onAddPressed: () => _showAddPackageSheet(context),
              ),
            )
          // ── Package List ────────────────────────────────────────
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final package = packages[index];
                return StaggeredAnimationCell(
                  index: index,
                  child: _PackageCard(
                    package: package,
                    index: index,
                    onTap: () => _showPackageActions(context, ref, package),
                  ),
                );
              }, childCount: packages.length),
            ),

          // Bottom padding for the floating nav
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Gradient Header
// ─────────────────────────────────────────────────────────────────────────────

class _GradientHeader extends ConsumerWidget {
  const _GradientHeader({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final userAsync = ref.watch(authStateProvider);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B9B9B), Color(0xFF009696)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row: Avatar + Welcome + Bell ──────────────────────
            Row(
              children: [
                // Avatar with gradient container
                userAsync.when(
                  data: (user) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user != null && user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  loading: () => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  error: (_, __) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      AppIcons.person,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: userAsync.when(
                    data: (user) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        Text(
                          user?.name ?? '...',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 120,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    error: (_, __) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        Text(
                          '...',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Notification bell with badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        AppIcons.notifications,
                        color: Colors.white,
                        size: 24,
                      ),
                      tooltip: strings.homeNoNotifications,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.homeNoNotifications)),
                        );
                      },
                    ),
                    // Badge dot
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Title & Subtitle ──────────────────────────────────
            Text(
              strings.homeTrackYourPackage,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.homeAllPackagesOnePlace,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 20),

            // ── Search Bar ────────────────────────────────────────
            _SearchBar(query: searchQuery, onChanged: onSearchChanged),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1.5 Search Bar with focus shadow
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: TextEditingController.fromValue(
          TextEditingValue(text: widget.query),
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: strings.homeTrackingByParcel,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            AppIcons.search,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: widget.query.isNotEmpty
              ? IconButton(
                  icon: const Icon(AppIcons.close, size: 18),
                  onPressed: () => widget.onChanged(''),
                  color: colorScheme.onSurfaceVariant,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Quick Filters
// ─────────────────────────────────────────────────────────────────────────────

class _QuickFilters extends StatelessWidget {
  const _QuickFilters({
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final filters = [
      strings.filterPending,
      strings.filterOutForDelivery,
      strings.filterDelivered,
      strings.filterArchived,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onFilterChanged(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Package Card
// ─────────────────────────────────────────────────────────────────────────────

/// Circle colors for differentiating packages.
const _circleColors = [
  Color(0xFFFF8A65), // Orange
  Color(0xFF42A5F5), // Blue
  Color(0xFFAB47BC), // Purple
];

class _PackageCard extends StatefulWidget {
  const _PackageCard({
    required this.package,
    required this.index,
    required this.onTap,
  });

  final PackageModel package;
  final int index;
  final VoidCallback onTap;

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final circleColor = _circleColors[widget.index % _circleColors.length];
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: '${widget.package.description}, status: ${widget.package.status}',
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _scale = 0.97),
          onTapUp: (_) => setState(() => _scale = 1.0),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 100),
            child: Hero(
              tag: 'package_hero_${widget.package.code}',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Leading colored circle with gradient
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            circleColor.withValues(alpha: 0.8),
                            circleColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        AppIcons.inventory2,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nome + data + status (um abaixo do outro)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Nome da Encomenda
                          Text(
                            widget.package.description,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // 2. Data e hora da última atualização
                          if (widget.package.lastUpdate != null)
                            Text(
                              formatDateTime(widget.package.lastUpdate),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          const SizedBox(height: 4),
                          // 3. Status atual
                          StatusBadge(
                            status: widget.package.status,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3.5 Shimmer Loading
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => _ShimmerCard(index: index)),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // Circle placeholder
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Text lines placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyPackages extends StatelessWidget {
  const _EmptyPackages({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/anim_empty_packages.json',
              width: 140,
              height: 140,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 16),
            Text(
              strings.homeNoPackagesYet,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.homeStartTrackingYourFirst,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(AppIcons.add),
              label: Text(strings.trackingAddPackage),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
