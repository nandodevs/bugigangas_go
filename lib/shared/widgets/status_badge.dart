import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// High-level category for a tracking status string.
///
/// Each value corresponds to a group of raw status strings returned by
/// the tracking API. Use [StatusBadge.categorizeStatus] to obtain a
/// category from any raw status string.
enum StatusCategory {
  /// Package has been registered / posted but is not yet in transit.
  processing,
  /// Package is physically moving between facilities.
  inTransit,
  /// Package is out for final delivery to the recipient.
  outForDelivery,
  /// Package has been successfully delivered.
  delivered,
  /// An error / exception occurred (e.g. not found, returned).
  exception,
}

/// A reusable pill-shaped badge that displays a tracking status.
///
/// Always renders an icon alongside the label to meet accessibility
/// standards (never colour alone). The status string is matched
/// case-insensitively against known Portuguese labels.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  /// The current tracking status string (e.g. "Em trânsito", "Entregue").
  final String status;

  /// When `true` renders a smaller badge suitable for list tiles.
  /// When `false` renders the standard badge.
  final bool compact;

  /// Categorises a raw status string into a [StatusCategory].
  ///
  /// This is the single source of truth for status matching. Both
  /// [colorForStatus] and [iconForStatus] delegate here to keep the
  /// string‑to‑category logic in one place.
  static StatusCategory categorizeStatus(String status) {
    final s = status.toLowerCase();

    // Must check out-for-delivery BEFORE delivered
    // (since "entrega" contains "entreg")
    if (s.contains('saiu para entrega') ||
        s.contains('out for delivery') ||
        s.contains('saiu p/ entrega') ||
        s.contains('saiu-entrega')) {
      return StatusCategory.outForDelivery;
    }
    if (s.contains('entreg') ||
        s.contains('delivered') ||
        s == 'entregue') {
      return StatusCategory.delivered;
    }
    if (s.contains('trânsito') ||
        s.contains('transit') ||
        s.contains('transito')) {
      return StatusCategory.inTransit;
    }
    if (s.contains('postado') ||
        s.contains('postagem') ||
        s.contains('registrado') ||
        s == 'processing') {
      return StatusCategory.processing;
    }
    if (s.contains('não encontrado') ||
        s.contains('exception') ||
        s.contains('erro') ||
        s.contains('error') ||
        s.contains('não localizado')) {
      return StatusCategory.exception;
    }
    return StatusCategory.processing;
  }

  /// Returns the [StatusColorPair] matching [status].
  /// Uses dark-mode colors when the current brightness is dark.
  static StatusColorPair colorForStatus(String status,
      [Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    switch (categorizeStatus(status)) {
      case StatusCategory.processing:
        return isDark ? AppColors.processingDark : AppColors.processing;
      case StatusCategory.inTransit:
        return isDark ? AppColors.inTransitDark : AppColors.inTransit;
      case StatusCategory.outForDelivery:
        return isDark
            ? AppColors.outForDeliveryDark
            : AppColors.outForDelivery;
      case StatusCategory.delivered:
        return isDark ? AppColors.deliveredDark : AppColors.delivered;
      case StatusCategory.exception:
        return isDark ? AppColors.exceptionDark : AppColors.exception;
    }
  }

  /// Returns the [IconData] matching [status].
  static IconData iconForStatus(String status) {
    switch (categorizeStatus(status)) {
      case StatusCategory.processing:
        return Icons.receipt_long;
      case StatusCategory.inTransit:
        return Icons.local_shipping;
      case StatusCategory.outForDelivery:
        return Icons.delivery_dining;
      case StatusCategory.delivered:
        return Icons.check_circle;
      case StatusCategory.exception:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = colorForStatus(status, brightness);
    final icon = iconForStatus(status);

    if (compact) {
      return _buildCompact(colors, icon);
    }
    return _buildStandard(colors, icon);
  }

  Widget _buildStandard(StatusColorPair colors, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2, // 10
        vertical: AppSpacing.xs,        //  4
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.foreground),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status,
            style: AppTypography.bodySmall.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(StatusColorPair colors, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: colors.foreground),
          const SizedBox(width: 3),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
