import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../l10n/app_strings.dart';

/// A custom floating bottom navigation bar with 5 items.
///
/// The center item (Search) is rendered as a teal circle elevated above
/// the other items, matching the DESIGN-SPEC.md specification.
class FloatingBottomNav extends ConsumerWidget {
  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);

    final navItems = <_NavItem>[
      _NavItem(icon: AppIcons.home, label: strings.navHome),
      _NavItem(icon: AppIcons.shoppingCart, label: strings.navMarket),
      _NavItem(icon: AppIcons.search, label: null), // Central — no label
      _NavItem(icon: AppIcons.chatBubble, label: strings.navChat),
      _NavItem(icon: AppIcons.person, label: strings.navProfile),
    ];

    return Container(
      width: double.infinity,
      height: 72, // 64 content + 8 bottom safe area
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isCenter = index == 2;
          final isSelected = index == currentIndex;

          if (isCenter) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap(index);
                },
                child: Semantics(
                  label: strings.navSearchAccessibility,
                  button: true,
                  child: Container(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          AppIcons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final color = isSelected ? AppColors.primary : AppColors.textHint;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap(index);
              },
              child: Semantics(
                label: item.label ?? '',
                button: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      if (item.label != null)
                        Text(
                          item.label!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: color,
                            letterSpacing: 0.3,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Internal data class for navigation items.
class _NavItem {
  final IconData icon;
  final String? label;

  const _NavItem({required this.icon, this.label});
}
