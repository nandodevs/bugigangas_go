import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bugigangas_go/features/tracking/domain/package_model.dart';
import 'package:bugigangas_go/features/tracking/presentation/tracking_providers.dart';

void main() {
  group('searchQueryProvider', () {
    test('should start with an empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final query = container.read(searchQueryProvider);

      expect(query, '');
    });

    test('should update when a new value is set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(searchQueryProvider.notifier).state = 'keyboard';

      // Assert
      expect(container.read(searchQueryProvider), 'keyboard');
    });

    test('should accept an empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'keyboard';
      container.read(searchQueryProvider.notifier).state = '';

      expect(container.read(searchQueryProvider), '');
    });

    test('should accept special characters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = r'BR@#$%^&*()';

      expect(container.read(searchQueryProvider), r'BR@#$%^&*()');
    });

    test('should accept a very long query string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final longQuery = 'a' * 1000;
      container.read(searchQueryProvider.notifier).state = longQuery;

      expect(container.read(searchQueryProvider), longQuery);
      expect(container.read(searchQueryProvider).length, 1000);
    });

    test('should update multiple times sequentially', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchQueryProvider.notifier);

      notifier.state = 'a';
      notifier.state = 'ab';
      notifier.state = 'abc';

      expect(container.read(searchQueryProvider), 'abc');
    });
  });

  group('packageListProvider', () {
    test('should return 3 default packages', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final packages = container.read(packageListProvider);

      expect(packages.length, 3);
    });

    test('should contain the expected default packages', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final packages = container.read(packageListProvider);

      expect(packages[0].code, 'BR123456789');
      expect(packages[0].status, 'Em trânsito');
      expect(packages[0].description, 'Fones de ouvido Bluetooth');

      expect(packages[1].code, 'US987654321');
      expect(packages[1].status, 'Saiu para entrega');
      expect(packages[1].description, 'Teclado Mecânico');

      expect(packages[2].code, 'CN555666777');
      expect(packages[2].status, 'Entregue');
      expect(packages[2].description, 'Smart Watch');
    });

    test('should be updatable', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final newList = <PackageModel>[
        const PackageModel(code: 'TEST', status: 'Unknown', description: 'Test'),
      ];

      container.read(packageListProvider.notifier).state = newList;

      expect(container.read(packageListProvider).length, 1);
      expect(container.read(packageListProvider)[0].code, 'TEST');
    });

    test('should accept an empty list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(packageListProvider.notifier).state = [];

      expect(container.read(packageListProvider), isEmpty);
    });
  });

  group('filteredPackageListProvider', () {
    test('should return all packages when query is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filtered = container.read(filteredPackageListProvider);

      expect(filtered.length, 3);
    });

    test('should filter by description (case-insensitive)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(searchQueryProvider.notifier).state = 'teclado';

      // Assert
      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].description, 'Teclado Mecânico');
    });

    test('should filter by code (case-insensitive)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(searchQueryProvider.notifier).state = 'br123';

      // Assert
      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].code, 'BR123456789');
    });

    test('should be case-insensitive for codes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'br123456789';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
    });

    test('should be case-insensitive for descriptions', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'FONES';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].description, 'Fones de ouvido Bluetooth');
    });

    test('should return empty list when no match found', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'zzzzzzz';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered, isEmpty);
    });

    test('should match partial code substrings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = '987';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].code, 'US987654321');
    });

    test('should match partial description substrings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'Teclado';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].description, 'Teclado Mecânico');
    });

    test('should match multiple packages when query is broad', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Search for 'a' which appears in Portuguese descriptions:
      // "Teclado Mecânico" contains 'a' -> match
      // "Smart Watch" contains 'a' -> match
      // "Fones de ouvido Bluetooth" does NOT contain 'a' -> no match

      container.read(searchQueryProvider.notifier).state = 'a';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 2);
    });

    test('should react to query changes immediately', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial state: empty query → 3 results
      expect(container.read(filteredPackageListProvider).length, 3);

      // Update query
      container.read(searchQueryProvider.notifier).state = 'teclado';

      // Immediately reflects
      expect(container.read(filteredPackageListProvider).length, 1);

      // Change back
      container.read(searchQueryProvider.notifier).state = '';

      expect(container.read(filteredPackageListProvider).length, 3);
    });

    test('should handle special characters in query', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // None of the descriptions/codes contain special characters,
      // so this should return empty
      container.read(searchQueryProvider.notifier).state = r'@#$%';

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered, isEmpty);
    });

    test('should handle query that matches both code and description', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add a second package with matching characteristics
      container.read(packageListProvider.notifier).state = [
        const PackageModel(code: 'ABC-KEYBOARD', status: 'Processing', description: 'Wireless Keyboard'),
        const PackageModel(code: 'XYZ-MOUSE', status: 'Delivered', description: 'Gaming Mouse'),
      ];

      container.read(searchQueryProvider.notifier).state = 'keyboard';

      final filtered = container.read(filteredPackageListProvider);
      // Should match both by code (ABC-KEYBOARD) and by description (Wireless Keyboard)
      // Actually "Wireless Keyboard" contains "keyboard" in description
      // and "ABC-KEYBOARD" contains "keyboard" in code
      // So only one package matches (the one with code ABC-KEYBOARD matches by code,
      // the one with description Wireless Keyboard matches by description)
      // Wait, both packages: first has code "ABC-KEYBOARD" (matches) and description "Wireless Keyboard" (matches)
      // Actually, the first package alone matches on both fields. The second doesn't match at all.
      // So the result should be 1.
      expect(filtered.length, 1);
    });

    test('should work correctly when packageList is updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set a query first
      container.read(searchQueryProvider.notifier).state = 'test';

      // Then update package list
      container.read(packageListProvider.notifier).state = [
        const PackageModel(code: 'TEST001', status: 'Processing', description: 'Test Item'),
        const PackageModel(code: 'OTHER', status: 'Delivered', description: 'Other Item'),
      ];

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered.length, 1);
      expect(filtered[0].code, 'TEST001');
    });

    test('should return empty when packageList is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(packageListProvider.notifier).state = [];

      final filtered = container.read(filteredPackageListProvider);
      expect(filtered, isEmpty);
    });
  });
}
