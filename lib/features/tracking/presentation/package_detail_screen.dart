import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../l10n/app_strings.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/package_model.dart';
import '../domain/tracking_event.dart';
import 'tracking_providers.dart';

class PackageDetailScreen extends ConsumerWidget {
  const PackageDetailScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final package = ref.watch(packageByCodeProvider(code));

    if (package == null) {
      return Scaffold(
        appBar: AppBar(title: Text(code)),
        body: Center(child: Text(strings.trackingPackageNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(package.code),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh),
            tooltip: strings.trackingRefresh,
            onPressed: () => ref.read(packageListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── Status Hero Card ────────────────────────────────────
          _StatusHero(package: package),

          const SizedBox(height: 16),

          // ── Package Info ────────────────────────────────────────
          _InfoCard(package: package, strings: strings),

          const SizedBox(height: 16),

          // ── Delivery Info ────────────────────────────────────────
          if (package.estimatedDelivery != null ||
              package.packageType != null ||
              package.delayed)
            _DeliveryInfoCard(package: package, strings: strings),

          if (package.delayed ||
              package.packageType != null ||
              package.estimatedDelivery != null)
            const SizedBox(height: 16),

          // ── Events Timeline ─────────────────────────────────────
          if (package.events.isNotEmpty) ...[
            Row(
              children: [
                Icon(AppIcons.roadHorizon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  strings.trackingHistory,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _EventTimeline(events: package.events),
          ] else
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    strings.trackingNoEvents,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delivery Info Card — new Correios fields
// ─────────────────────────────────────────────────────────────────────────────

class _DeliveryInfoCard extends StatelessWidget {
  const _DeliveryInfoCard({required this.package, required this.strings});

  final PackageModel package;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  AppIcons.localShipping,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações de Entrega',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (package.packageType != null) ...[
              _InfoRow(
                icon: AppIcons.inventory2,
                label: 'Tipo de Pacote',
                value: package.packageType!,
              ),
              const Divider(height: 24),
            ],
            if (package.carrier != null) ...[
              _InfoRow(
                icon: AppIcons.business,
                label: 'Transportadora',
                value: package.carrier!,
              ),
              const Divider(height: 24),
            ],
            if (package.estimatedDelivery != null) ...[
              _InfoRow(
                icon: AppIcons.dateRange,
                label: 'Previsão de Entrega',
                value:
                    '${package.estimatedDelivery!.day.toString().padLeft(2, '0')}/'
                    '${package.estimatedDelivery!.month.toString().padLeft(2, '0')}/'
                    '${package.estimatedDelivery!.year}',
              ),
            ],
            if (package.delayed) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.warning,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Entrega atrasada',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (package.lockerDelivery) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.inventory,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Entrega em locker',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Hero — large status indicator at the top
// ─────────────────────────────────────────────────────────────────────────────

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.package});

  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final statusColor = StatusBadge.colorForStatus(
      package.status,
      Theme.of(context).brightness,
    ).foreground;

    return Hero(
      tag: 'package_hero_${package.code}',
      child: Card(
        margin: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                statusColor.withOpacity(0.1),
                statusColor.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Lottie.asset(
                _statusAnimationPath(package.status),
                width: 64,
                height: 64,
                repeat: true,
                animate: true,
              ),
              const SizedBox(height: 12),
              Text(
                package.status,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (package.lastUpdate != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${strings.trackingUpdated} ${_relativeDate(package.lastUpdate!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _relativeDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays < 7) return 'há ${diff.inDays}d';
    return 'em ${date.day}/${date.month}/${date.year}';
  }

  String _statusAnimationPath(String status) {
    final category = StatusBadge.categorizeStatus(status);
    switch (category) {
      case StatusCategory.processing:
        return 'assets/animations/anim_hero_processing.json';
      case StatusCategory.inTransit:
        return 'assets/animations/anim_hero_intransit.json';
      case StatusCategory.outForDelivery:
        return 'assets/animations/anim_hero_outfordelivery.json';
      case StatusCategory.delivered:
        return 'assets/animations/anim_hero_delivered.json';
      case StatusCategory.exception:
        return 'assets/animations/anim_hero_exception.json';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Card — package details
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.package, required this.strings});

  final PackageModel package;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.trackingInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: AppIcons.fileText,
              label: strings.trackingDescription,
              value: package.description,
            ),
            const Divider(height: 24),
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: package.code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código copiado!')),
                );
                HapticFeedback.mediumImpact();
              },
              child: _InfoRow(
                icon: AppIcons.qrCode,
                label: strings.code,
                value: package.code,
                isMono: true,
              ),
            ),
            if (package.origin != null) ...[
              const Divider(height: 24),
              _InfoRow(
                icon: AppIcons.mapPin,
                label: strings.trackingOrigin,
                value: package.origin!,
              ),
            ],
            if (package.destination != null) ...[
              const Divider(height: 24),
              _InfoRow(
                icon: AppIcons.flag,
                label: strings.trackingDestination,
                value: package.destination!,
              ),
            ],
            if (package.lastUpdate != null) ...[
              const Divider(height: 24),
              _InfoRow(
                icon: AppIcons.clock,
                label: strings.trackingDetailLastUpdate,
                value:
                    '${package.lastUpdate!.day.toString().padLeft(2, '0')}/'
                    '${package.lastUpdate!.month.toString().padLeft(2, '0')}/'
                    '${package.lastUpdate!.year} '
                    '${package.lastUpdate!.hour.toString().padLeft(2, '0')}:'
                    '${package.lastUpdate!.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isMono = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: isMono ? 'monospace' : null,
                  letterSpacing: isMono ? 1.5 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Event Timeline
// ─────────────────────────────────────────────────────────────────────────────

/// A simple vertical timeline built as a column of [TimelineEntry] widgets.
///
/// Each entry paints its own dot and, except for the last one, a vertical
/// line segment below the dot. This keeps alignment correct regardless of
/// content height.
class _EventTimeline extends StatelessWidget {
  const _EventTimeline({required this.events});

  final List<TrackingEvent> events;

  @override
  Widget build(BuildContext context) {
    // Display newest event first (reversed chronological order).
    final reversed = events.reversed.toList();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: List.generate(reversed.length, (index) {
            final event = reversed[index];
            final isLatest = index == 0;
            final isLast = index == reversed.length - 1;
            return _TimelineEntry(
              event: event,
              isLatest: isLatest,
              showLine: !isLast,
            );
          }),
        ),
      ),
    );
  }
}

/// A single entry in the timeline: dot + vertical line + content.
class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.event,
    required this.isLatest,
    required this.showLine,
  });

  final TrackingEvent event;
  final bool isLatest;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${event.date.day.toString().padLeft(2, '0')}/'
        '${event.date.month.toString().padLeft(2, '0')}/'
        '${event.date.year} '
        '${event.date.hour.toString().padLeft(2, '0')}:'
        '${event.date.minute.toString().padLeft(2, '0')}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gutter: dot + line ─────────────────────────────────
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Dot
                Container(
                  width: isLatest ? 14 : 10,
                  height: isLatest ? 14 : 10,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isLatest
                        ? AppColors.primary
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                // Vertical line (not for the last entry)
                if (showLine)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Content ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, bottom: showLine ? 0 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (event.eventCode != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isLatest
                                ? AppColors.primaryContainer
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            event.eventCode!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: isLatest
                                  ? AppColors.onPrimaryContainer
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          event.description,
                          style:
                              (isLatest
                                      ? Theme.of(context).textTheme.titleLarge
                                      : Theme.of(context).textTheme.bodyLarge)
                                  ?.copyWith(
                                    fontWeight: isLatest
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr • ${event.location}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (event.unitName != null &&
                      event.unitName != event.location) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.unitName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (event.comment != null && event.comment!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            AppIcons.info,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onTertiaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.comment!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (showLine) const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
