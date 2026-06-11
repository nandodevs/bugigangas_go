// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageModelImpl _$$PackageModelImplFromJson(Map<String, dynamic> json) =>
    _$PackageModelImpl(
      code: json['code'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => TrackingEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      archived: json['archived'] as bool? ?? false,
      carrier: json['carrier'] as String?,
      packageType: json['packageType'] as String?,
      packageCategory: json['packageCategory'] as String?,
      estimatedDelivery: json['estimatedDelivery'] == null
          ? null
          : DateTime.parse(json['estimatedDelivery'] as String),
      delayed: json['delayed'] as bool? ?? false,
      lockerDelivery: json['lockerDelivery'] as bool? ?? false,
    );

Map<String, dynamic> _$$PackageModelImplToJson(_$PackageModelImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'description': instance.description,
      'events': instance.events,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'origin': instance.origin,
      'destination': instance.destination,
      'tags': instance.tags,
      'archived': instance.archived,
      'carrier': instance.carrier,
      'packageType': instance.packageType,
      'packageCategory': instance.packageCategory,
      'estimatedDelivery': instance.estimatedDelivery?.toIso8601String(),
      'delayed': instance.delayed,
      'lockerDelivery': instance.lockerDelivery,
    };
