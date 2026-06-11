import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_event.freezed.dart';
part 'tracking_event.g.dart';

@freezed
class TrackingEvent with _$TrackingEvent {
  const factory TrackingEvent({
    required DateTime date,
    required String location,
    required String description,
    // ── Correios API fields ────────────────────────────────────
    String? eventCode,
    String? unitName,
    String? unitCity,
    String? unitState,
    String? destinationCity,
    String? destinationState,
    String? frontEndDescription,
    String? iconPath,
    String? detail,
    String? comment,
    @Default(false) bool isFinal,
  }) = _TrackingEvent;

  factory TrackingEvent.fromJson(Map<String, dynamic> json) =>
      _$TrackingEventFromJson(json);
}
