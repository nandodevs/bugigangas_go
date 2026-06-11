import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cache_service.dart';

/// Riverpod provider for [CacheService].
///
/// Note: `init()` must be called in `main()` before the app starts.
/// The overridden instance is passed via ProviderScope overrides.
final cacheServiceProvider = Provider<CacheService>((ref) {
  final service = CacheService();
  return service;
});
