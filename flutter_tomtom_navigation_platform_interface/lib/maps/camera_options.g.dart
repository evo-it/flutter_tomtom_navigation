// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CameraOptions _$CameraOptionsFromJson(Map<String, dynamic> json) =>
    CameraOptions(
      position: json['a'] == null
          ? null
          : GeoPoint.fromJson(json['a'] as Map<String, dynamic>),
      zoom: (json['b'] as num?)?.toDouble(),
      tilt: (json['c'] as num?)?.toDouble(),
      rotation: (json['d'] as num?)?.toDouble(),
      fieldOfView: (json['e'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CameraOptionsToJson(CameraOptions instance) =>
    <String, dynamic>{
      'e': instance.fieldOfView,
      'a': instance.position?.toJson(),
      'd': instance.rotation,
      'c': instance.tilt,
      'b': instance.zoom,
    };
