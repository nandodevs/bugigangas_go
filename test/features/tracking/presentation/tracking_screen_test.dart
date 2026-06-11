import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bugigangas_go/core/cache/cache_service.dart';
import 'package:bugigangas_go/core/database/neon_service.dart';
import 'package:bugigangas_go/features/tracking/data/package_repository.dart';
import 'package:bugigangas_go/features/tracking/domain/package_model.dart';
import 'package:bugigangas_go/features/tracking/presentation/tracking_providers.dart';
import 'package:bugigangas_go/features/tracking/presentation/tracking_screen.dart';

class _MockPackageRepository extends Mock implements PackageRepository {}

class _MockNeonService extends Mock implements NeonService {}

class _MockCacheService extends Mock implements CacheService {}

/// Default 3 packages used by the screen tests.
const _defaultPackages = [
  PackageModel(
    code: 'BR123456789',
    status: 'Em trânsito',
    description: 'Fones de ouvido Bluetooth',
  ),
  PackageModel(
    code: 'US987654321',
    status: 'Saiu para entrega',
    description: 'Teclado Mecânico',
  ),
  PackageModel(
    code: 'CN555666777',
    status: 'Entregue',
    description: 'Smart Watch',
  ),
];

void main() {
  // ──────────────────────────────────────────────
  // Helper: builds the TrackingScreen inside a
  // ProviderScope with minimal MaterialApp wrapper.
  // ──────────────────────────────────────────────
  Widget buildTestWidget({
    List<PackageModel>? packages,
  }) {
    final effectivePackages = packages ?? _defaultPackages;

    return ProviderScope(
      overrides: [
        packageListProvider.overrideWith(
          (ref) {
            final mockNeon = _MockNeonService();
            when(() => mockNeon.getUserPackages(any())).thenAnswer(
              (_) async => effectivePackages,
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
            notifier.state = effectivePackages;
            return notifier;
          },
        ),
      ],
      child: const MaterialApp(
        home: TrackingScreen(),
      ),
    );
  }

  group('TrackingScreen', () {
    // ──────────────────────────────────────────
    // App Bar
    // ──────────────────────────────────────────

    testWidgets('renders AppBar with correct title', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Meus Pacotes'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    // ──────────────────────────────────────────
    // List of packages – default dummy data
    // ──────────────────────────────────────────

    testWidgets('displays all 3 package descriptions', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Fones de ouvido Bluetooth'), findsOneWidget);
      expect(find.text('Teclado Mecânico'), findsOneWidget);
      expect(find.text('Smart Watch'), findsOneWidget);
    });

    testWidgets('displays all 3 tracking codes', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('BR123456789'), findsOneWidget);
      expect(find.text('US987654321'), findsOneWidget);
      expect(find.text('CN555666777'), findsOneWidget);
    });

    testWidgets('renders 3 Card widgets', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Card), findsNWidgets(3));
    });

    // ──────────────────────────────────────────
    // Status badges – text
    // ──────────────────────────────────────────

    testWidgets('status badges display correct status text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Em trânsito'), findsOneWidget);
      expect(find.text('Saiu para entrega'), findsOneWidget);
      expect(find.text('Entregue'), findsOneWidget);
    });

    // ──────────────────────────────────────────
    // Status badges – icons
    // ──────────────────────────────────────────

    testWidgets('Em trânsito badge shows local_shipping icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Em trânsito → Icons.local_shipping
      expect(find.byIcon(Icons.local_shipping), findsOneWidget);
    });

    testWidgets('Saiu para entrega badge shows delivery_dining icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Saiu para entrega → Icons.delivery_dining
      expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
    });

    testWidgets('Entregue badge shows check_circle icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Entregue → Icons.check_circle
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('status badges contain both icon and text in a Row', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Each badge is a Container > Row > [Icon, Text]
      // The outer Card ListTiles also use Row, so we can't easily
      // count badge Rows.  Instead verify the three known icons
      // coexist with their respective texts.
      expect(
        find.descendant(
          of: find.byIcon(Icons.local_shipping),
          matching: find.text('Em trânsito'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byIcon(Icons.delivery_dining),
          matching: find.text('Saiu para entrega'),
        ),
        findsOneWidget,
      );
    });

    // ──────────────────────────────────────────
    // Search functionality
    // ──────────────────────────────────────────

    testWidgets('typing a description filters the list', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Arrange
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Act – type a word that matches only 'Teclado Mecânico'
      await tester.enterText(searchField, 'teclado');
      await tester.pumpAndSettle();

      // Assert – only the matching package should remain
      expect(find.text('Teclado Mecânico'), findsOneWidget);
      expect(find.text('Fones de ouvido Bluetooth'), findsNothing);
      expect(find.text('Smart Watch'), findsNothing);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('typing a tracking code filters the list', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Act – type a code prefix that matches only 'BR123456789'
      await tester.enterText(find.byType(TextField), 'BR123');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('BR123456789'), findsOneWidget);
      expect(find.text('US987654321'), findsNothing);
      expect(find.text('CN555666777'), findsNothing);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('search is case-insensitive', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextField), 'TECLADO');
      await tester.pumpAndSettle();

      expect(find.text('Teclado Mecânico'), findsOneWidget);
      expect(find.text('Fones de ouvido Bluetooth'), findsNothing);
    });

    testWidgets('partial code match works', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextField), '777');
      await tester.pumpAndSettle();

      expect(find.text('Smart Watch'), findsOneWidget);
      expect(find.text('Fones de ouvido Bluetooth'), findsNothing);
      expect(find.text('Teclado Mecânico'), findsNothing);
    });

    testWidgets('empty search string shows all packages', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // First filter, then clear
      await tester.enterText(find.byType(TextField), 'teclado');
      await tester.pumpAndSettle();
      expect(find.byType(Card), findsOneWidget);

      // Clear the search field
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      // All packages should be back
      expect(find.text('Fones de ouvido Bluetooth'), findsOneWidget);
      expect(find.text('Teclado Mecânico'), findsOneWidget);
      expect(find.text('Smart Watch'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));
    });

    // ──────────────────────────────────────────
    // Empty / no-match states
    // ──────────────────────────────────────────

    testWidgets('shows no cards when no packages exist', (tester) async {
      await tester.pumpWidget(buildTestWidget(packages: []));

      // The list is empty, so no Cards should be rendered
      expect(find.byType(Card), findsNothing);
      // But the AppBar and search field should still be present
      expect(find.text('Meus Pacotes'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows no cards when search matches nothing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextField), 'zzzzzzzzz');
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
      // App bar and search still visible
      expect(find.text('Meus Pacotes'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    // ──────────────────────────────────────────
    // Search field present
    // ──────────────────────────────────────────

    testWidgets('search TextField has correct label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // The TextField has a labelText, which shows up as a Text widget
      // when the field is not focused, or via decoration.
      expect(
        find.widgetWithText(TextField, 'Buscar por código ou descrição'),
        findsOneWidget,
      );
    });

    testWidgets('search TextField shows search icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
