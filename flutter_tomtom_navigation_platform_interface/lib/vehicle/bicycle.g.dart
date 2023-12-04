// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bicycle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bicycle _$BicycleFromJson(Map<String, dynamic> json) => Bicycle(
      maxSpeed: json['maxSpeed'] == null
          ? null
          : Speed.fromJson(json['maxSpeed'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BicycleToJson(Bicycle instance) => <String, dynamic>{
      'maxSpeed': instance.maxSpeed?.toJson(),
      'type': _$VehicleTypeEnumMap[instance.type]!,
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
