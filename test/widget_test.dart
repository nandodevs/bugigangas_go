import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bugigangas_go/core/database/neon_service.dart';
import 'package:bugigangas_go/features/tracking/data/package_repository.dart';
import 'package:bugigangas_go/features/tracking/domain/package_model.dart';
import 'package:bugigangas_go/features/tracking/presentation/tracking_providers.dart';
import 'package:bugigangas_go/features/tracking/presentation/tracking_screen.dart';

class _MockPackageRepository extends Mock implements PackageRepository {}

class _MockNeonService extends Mock implements NeonService {}

/// Helper that wraps a widget inside a [ProviderScope].
/// Optionally accepts overrides for specific providers to control
/// the test scenario (e.g. empty list, custom data, etc.).
Widget wrapWithProviderScope({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(home: child),
  );
}

/// Creates an [Override] that replaces [packageListProvider] with a
/// [PackageListNotifier] whose state is set to [packages].
Override overridePackageList(List<PackageModel> packages) {
  return packageListProvider.overrideWith(
    (ref) {
      final mockNeon = _MockNeonService();
      when(() => mockNeon.getUserPackages(any())).thenAnswer(
        (_) async => packages,
      );
      when(() => mockNeon.getCurrentUser()).thenAnswer(
        (_) async => null,
      );
      final notifier = PackageListNotifier(
        _MockPackageRepository(),
        mockNeon,
        null,
      );
      // Override the async-loaded state with our desired packages.
      notifier.state = packages;
      return notifier;
    },
  );
}

void main() {
  group('WidgetTest configuration — ProviderScope wrapper', () {
    testWidgets('renders TrackingScreen with default data', (tester) async {
      await tester.pumpWidget(
        wrapWithProviderScope(child: const TrackingScreen()),
      );

      // Verify the screen renders the expected elements
      expect(find.text('Meus Pacotes'), findsOneWidget);
      expect(find.text('Fones de ouvido Bluetooth'), findsOneWidget);
      expect(find.text('Teclado Mecânico'), findsOneWidget);
      expect(find.text('Smart Watch'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts empty package list via override', (tester) async {
      await tester.pumpWidget(
        wrapWithProviderScope(
          child: const TrackingScreen(),
          overrides: [
            overridePackageList(<PackageModel>[]),
          ],
        ),
      );

      // No packages should be displayed
      expect(find.text('Headphones'), findsNothing);
      expect(find.byType(Card), findsNothing);
      // UI chrome should remain
      expect(find.text('Meus Pacotes'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts custom package list via override', (tester) async {
      final customPackages = [
        const PackageModel(
          code: 'TEST001',
          status: 'Processing',
          description: 'Custom Item',
        ),
      ];

      await tester.pumpWidget(
        wrapWithProviderScope(
          child: const TrackingScreen(),
          overrides: [
            overridePackageList(customPackages),
          ],
        ),
      );

      // The custom package should be shown instead of the defaults
      expect(find.text('Custom Item'), findsOneWidget);
      expect(find.text('Headphones'), findsNothing);
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
