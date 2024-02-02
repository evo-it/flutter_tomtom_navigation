// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Truck _$TruckFromJson(Map<String, dynamic> json) => Truck(
      maxSpeed: json['maxSpeed'] == null
          ? null
          : Speed.fromJson(json['maxSpeed'] as Map<String, dynamic>),
      isCommercial: json['isCommercial'] as bool? ?? true,
      dimensions: json['dimensions'] == null
          ? null
          : VehicleDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>),
      hazmatClasses: (json['hazmatClasses'] as List<dynamic>?)
              ?.map((e) => HazmatClass.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      adrTunnelRestrictionCode: $enumDecodeNullable(
          _$AdrTunnelRestrictionCodeEnumMap, json['adrTunnelRestrictionCode']),
      modelId: json['modelId'] as String?,
    );

Map<String, dynamic> _$TruckToJson(Truck instance) => <String, dynamic>{
      'maxSpeed': instance.maxSpeed?.toJson(),
      'type': _$VehicleTypeEnumMap[instance.type]!,
      'isCommercial': instance.isCommercial,
      'dimensions': instance.dimensions?.toJson(),
      'modelId': instance.modelId,
      'adrTunnelRestrictionCode':
          _$AdrTunnelRestrictionCodeEnumMap[instance.adrTunnelRestrictionCode],
      'hazmatClasses': instance.hazmatClasses.map((e) => e.toJson()).toList(),
    };

const _$AdrTunnelRestrictionCodeEnumMap = {
  AdrTunnelRestrictionCode.B: 'B',
  AdrTunnelRestrictionCode.C: 'C',
  AdrTunnelRestrictionCode.D: 'D',
  AdrTunnelRestrictionCode.E: 'E',
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
