import 'package:freezed_annotation/freezed_annotation.dart';
import 'tracking_event.dart';

part 'package_model.freezed.dart';
part 'package_model.g.dart';

@freezed
class PackageModel with _$PackageModel {
  const factory PackageModel({
    required String code,
    required String status,
    required String description,
    @Default([]) List<TrackingEvent> events,
    DateTime? lastUpdate,
    String? origin,
    String? destination,
    @Default([]) List<String> tags,
    @Default(false) bool archived,
    // ── Correios API fields ────────────────────────────────────
    String? carrier,
    String? packageType,
    String? packageCategory,
    DateTime? estimatedDelivery,
    @Default(false) bool delayed,
    @Default(false) bool lockerDelivery,
  }) = _PackageModel;

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);
}
