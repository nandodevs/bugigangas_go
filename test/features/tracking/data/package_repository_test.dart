import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bugigangas_go/features/tracking/data/package_repository.dart';
import 'package:bugigangas_go/features/tracking/domain/package_model.dart';

// ---------------------------------------------------------------------------
// Manual mock for Dio since the current implementation stores a Dio
// reference but does not invoke it yet.  Using mocktail for future-proof
// test structure.
// ---------------------------------------------------------------------------
class MockDio extends Mock implements Dio {}

void main() {
  group('PackageRepository', () {
    late MockDio mockDio;
    late PackageRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = PackageRepository(mockDio);
    });

    // ──────────────────────────────────────────────
    // Happy path – current mock implementation
    // ──────────────────────────────────────────────

    test('getPackage should return a PackageModel instance', () async {
      final result = await repository.getPackage('BR123456789');

      expect(result, isA<PackageModel>());
    });

    test('getPackage should preserve the provided tracking code', () async {
      const trackingCode = 'US987654321';
      final result = await repository.getPackage(trackingCode);

      expect(result.code, trackingCode);
    });

    test('getPackage should return the default mock status', () async {
      final result = await repository.getPackage('BR123456789');

      expect(result.status, 'Em trânsito');
    });

    test('getPackage should return the default mock description', () async {
      final result = await repository.getPackage('BR123456789');

      expect(result.description, 'Fones de ouvido Bluetooth');
    });

    test('getPackage should return consistent data for different codes', () async {
      final result1 = await repository.getPackage('CODE_A');
      final result2 = await repository.getPackage('CODE_B');

      // Only the code should differ; status and description are hardcoded
      expect(result1.code, 'CODE_A');
      expect(result2.code, 'CODE_B');
      expect(result1.status, result2.status);
      expect(result1.description, result2.description);
    });

    // ──────────────────────────────────────────────
    // Edge cases
    // ──────────────────────────────────────────────

    test('getPackage should accept an empty tracking code', () async {
      final result = await repository.getPackage('');

      expect(result.code, '');
      expect(result.status, 'Não encontrado');
      expect(result.description, 'Código de rastreio não reconhecido');
    });

    test('getPackage should accept a very long tracking code', () async {
      final longCode = 'TRACK${'0' * 500}';
      final result = await repository.getPackage(longCode);

      expect(result.code, longCode);
      expect(result.code.length, 505);
    });

    test('getPackage should accept tracking codes with special characters', () async {
      const code = r'BR@#$%^&*()_+=-[]{}|;:,.<>?/';
      final result = await repository.getPackage(code);

      expect(result.code, code);
    });

    // ──────────────────────────────────────────────
    // Dio-based error handling (future-proof)
    // ──────────────────────────────────────────────
    // NOTE: The current implementation does NOT use _dio, so these tests
    //       validate that the repository *will* handle errors once the
    //       real API call is wired in.  Unskip when Dio is integrated.

    test(
      'getPackage should throw DioException when the API call fails',
      () async {
        // Skipped: Dio is not used yet in getPackage().
      },
      skip: true,
    );

    test(
      'getPackage should throw on network timeout',
      () async {
        // Skipped: same reason as above.
      },
      skip: true,
    );
  });
}
