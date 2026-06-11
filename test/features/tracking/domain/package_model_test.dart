import 'package:flutter_test/flutter_test.dart';
import 'package:bugigangas_go/features/tracking/domain/package_model.dart';

void main() {
  group('PackageModel', () {
    // ──────────────────────────────────────────────
    // Construction & Field Access
    // ──────────────────────────────────────────────

    test('should create an instance with the constructor', () {
      const package = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      expect(package, isA<PackageModel>());
      expect(package.code, 'BR123456789');
      expect(package.status, 'Processing');
      expect(package.description, 'Headphones');
    });

    test('should store code, status, and description correctly', () {
      const package = PackageModel(
        code: 'US987654321',
        status: 'On delivery',
        description: 'Mechanical Keyboard',
      );

      expect(package.code, 'US987654321');
      expect(package.status, 'On delivery');
      expect(package.description, 'Mechanical Keyboard');
    });

    // ──────────────────────────────────────────────
    // Serialization (requires running build_runner)
    // ──────────────────────────────────────────────

    test('fromJson should parse a valid JSON map', () {
      final json = <String, dynamic>{
        'code': 'BR123456789',
        'status': 'Processing',
        'description': 'Headphones',
      };

      final package = PackageModel.fromJson(json);

      expect(package.code, 'BR123456789');
      expect(package.status, 'Processing');
      expect(package.description, 'Headphones');
    });

    test('toJson should serialize to a valid JSON map', () {
      const package = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      final json = package.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['code'], 'BR123456789');
      expect(json['status'], 'Processing');
      expect(json['description'], 'Headphones');
    });

    test('fromJson / toJson round-trip should preserve data', () {
      const original = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      final json = original.toJson();
      final restored = PackageModel.fromJson(json);

      expect(restored, original);
      expect(restored.code, original.code);
      expect(restored.status, original.status);
      expect(restored.description, original.description);
    });

    test('fromJson should accept empty strings', () {
      final json = <String, dynamic>{
        'code': '',
        'status': '',
        'description': '',
      };

      final package = PackageModel.fromJson(json);

      expect(package.code, '');
      expect(package.status, '');
      expect(package.description, '');
    });

    test('fromJson should handle special characters in description', () {
      final json = <String, dynamic>{
        'code': r'BR@#$%^&*()',
        'status': 'Processing',
        'description': 'Café 100% orgânico — válvula #1 & <tag>',
      };

      final package = PackageModel.fromJson(json);

      expect(package.code, r'BR@#$%^&*()');
      expect(package.description, 'Café 100% orgânico — válvula #1 & <tag>');
    });

    test('fromJson should handle very long tracking codes', () {
      final longCode = 'BR${'0' * 200}';
      final json = <String, dynamic>{
        'code': longCode,
        'status': 'Processing',
        'description': 'Long code test',
      };

      final package = PackageModel.fromJson(json);

      expect(package.code, longCode);
      expect(package.code.length, 202); // 'BR' + 200 zeros
    });

    // ──────────────────────────────────────────────
    // Equality (provided by freezed)
    // ──────────────────────────────────────────────

    test('should be equal when all fields match', () {
      const package1 = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );
      const package2 = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      expect(package1, package2);
      expect(package1.hashCode, package2.hashCode);
    });

    test('should not be equal when any field differs', () {
      const base = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );
      const differentCode = PackageModel(
        code: 'US987654321',
        status: 'Processing',
        description: 'Headphones',
      );
      const differentStatus = PackageModel(
        code: 'BR123456789',
        status: 'Delivered',
        description: 'Headphones',
      );
      const differentDescription = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Keyboard',
      );

      expect(base, isNot(differentCode));
      expect(base, isNot(differentStatus));
      expect(base, isNot(differentDescription));
    });

    // ──────────────────────────────────────────────
    // copyWith (provided by freezed)
    // ──────────────────────────────────────────────

    test('copyWith should update only specified fields', () {
      const original = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      final updated = original.copyWith(status: 'Delivered');

      // Changed field
      expect(updated.status, 'Delivered');
      // Unchanged fields
      expect(updated.code, 'BR123456789');
      expect(updated.description, 'Headphones');
    });

    test('copyWith should keep original unchanged', () {
      const original = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      final modified = original.copyWith(code: 'MODIFIED');

      // Original should be unchanged
      expect(original.code, 'BR123456789');
      // Modified should have the new value
      expect(modified.code, 'MODIFIED');
    });

    test('copyWith with null should keep all fields', () {
      const original = PackageModel(
        code: 'BR123456789',
        status: 'Processing',
        description: 'Headphones',
      );

      final updated = original.copyWith();

      expect(updated, original);
    });
  });
}
