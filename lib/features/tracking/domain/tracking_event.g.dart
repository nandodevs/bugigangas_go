// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackingEventImpl _$$TrackingEventImplFromJson(Map<String, dynamic> json) =>
    _$TrackingEventImpl(
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      description: json['description'] as String,
      eventCode: json['eventCode'] as String?,
      unitName: json['unitName'] as String?,
      unitCity: json['unitCity'] as String?,
      unitState: json['unitState'] as String?,
      destinationCity: json['destinationCity'] as String?,
      destinationState: json['destinationState'] as String?,
      frontEndDescription: json['frontEndDescription'] as String?,
      iconPath: json['iconPath'] as String?,
      detail: json['detail'] as String?,
      comment: json['comment'] as String?,
      isFinal: json['isFinal'] as bool? ?? false,
    );

Map<String, dynamic> _$$TrackingEventImplToJson(
        _$TrackingEventImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'location': instance.location,
      'description': instance.description,
      'eventCode': instance.eventCode,
      'unitName': instance.unitName,
      'unitCity': instance.unitCity,
      'unitState': instance.unitState,
      'destinationCity': instance.destinationCity,
      'destinationState': instance.destinationState,
      'frontEndDescription': instance.frontEndDescription,
      'iconPath': instance.iconPath,
      'detail': instance.detail,
      'comment': instance.comment,
      'isFinal': instance.isFinal,
    };
