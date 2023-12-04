// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      maxSpeed: json['maxSpeed'] == null
          ? null
          : Speed.fromJson(json['maxSpeed'] as Map<String, dynamic>),
      isCommercial: json['isCommercial'] as bool? ?? false,
      dimensions: json['dimensions'] == null
          ? null
          : VehicleDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>),
      modelId: json['modelId'] as String?,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'maxSpeed': instance.maxSpeed?.toJson(),
      'type': _$VehicleTypeEnumMap[instance.type]!,
      'isCommercial': instance.isCommercial,
      'dimensions': instance.dimensions?.toJson(),
      'modelId': instance.modelId,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.car: 0,
  VehicleType.truck: 1,
  VehicleType.taxi: 2,
  VehicleType.bus: 3,
  VehicleType.van: 4,
  VehicleType.motorcycle: 5,
  VehicleType.bicycle: 6,
  VehicleType.pedestrian: 7,
};
