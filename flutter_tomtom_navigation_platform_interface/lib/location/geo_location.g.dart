// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) => GeoLocation(
      position: GeoPoint.fromJson(json['position'] as Map<String, dynamic>),
      accuracy: json['accuracy'] == null
          ? null
          : Distance.fromJson(json['accuracy'] as Map<String, dynamic>),
      course: json['course'] == null
          ? null
          : Angle.fromJson(json['course'] as Map<String, dynamic>),
      speed: json['speed'] == null
          ? null
          : Speed.fromJson(json['speed'] as Map<String, dynamic>),
      altitude: json['altitude'] == null
          ? null
          : Distance.fromJson(json['altitude'] as Map<String, dynamic>),
      time: json['time'] as int?,
      elapsedRealtimeNanos: json['elapsedRealtimeNanos'] as int? ?? 0,
      provider: json['provider'] as String? ?? 'DEFAULT_PROVIDER',
      providerType: $enumDecodeNullable(
              _$LocationProviderTypeEnumMap, json['providerType']) ??
          LocationProviderType.realtime,
    );

Map<String, dynamic> _$GeoLocationToJson(GeoLocation instance) =>
    <String, dynamic>{
      'accuracy': instance.accuracy?.toJson(),
      'altitude': instance.altitude?.toJson(),
      'course': instance.course?.toJson(),
      'elapsedRealtimeNanos': instance.elapsedRealtimeNanos,
      'position': instance.position.toJson(),
      'provider': instance.provider,
      'providerType': _$LocationProviderTypeEnumMap[instance.providerType]!,
      'speed': instance.speed?.toJson(),
      'time': instance.time,
    };

const _$LocationProviderTypeEnumMap = {
  LocationProviderType.realtime: 'REALTIME',
  LocationProviderType.softDr: 'SOFT_DR',
};
