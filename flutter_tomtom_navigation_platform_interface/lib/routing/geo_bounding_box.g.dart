// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_bounding_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoBoundingBox _$GeoBoundingBoxFromJson(Map<String, dynamic> json) =>
    GeoBoundingBox(
      topLeft: GeoPoint.fromJson(json['topLeft'] as Map<String, dynamic>),
      bottomRight:
          GeoPoint.fromJson(json['bottomRight'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoBoundingBoxToJson(GeoBoundingBox instance) =>
    <String, dynamic>{
      'bottomRight': instance.bottomRight.toJson(),
      'center': instance.center.toJson(),
      'topLeft': instance.topLeft.toJson(),
    };
