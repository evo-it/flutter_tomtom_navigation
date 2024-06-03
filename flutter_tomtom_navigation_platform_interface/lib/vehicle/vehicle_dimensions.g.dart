// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_dimensions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDimensions _$VehicleDimensionsFromJson(Map<String, dynamic> json) =>
    VehicleDimensions(
      weight: json['weight'] == null
          ? null
          : Weight.fromJson(json['weight'] as Map<String, dynamic>),
      axleWeight: json['axleWeight'] == null
          ? null
          : Weight.fromJson(json['axleWeight'] as Map<String, dynamic>),
      length: json['length'] == null
          ? null
          : Distance.fromJson(json['length'] as Map<String, dynamic>),
      width: json['width'] == null
          ? null
          : Distance.fromJson(json['width'] as Map<String, dynamic>),
      height: json['height'] == null
          ? null
          : Distance.fromJson(json['height'] as Map<String, dynamic>),
      numberOfAxles: (json['numberOfAxles'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VehicleDimensionsToJson(VehicleDimensions instance) =>
    <String, dynamic>{
      'axleWeight': instance.axleWeight?.toJson(),
      'height': instance.height?.toJson(),
      'length': instance.length?.toJson(),
      'numberOfAxles': instance.numberOfAxles,
      'weight': instance.weight?.toJson(),
      'width': instance.width?.toJson(),
    };
