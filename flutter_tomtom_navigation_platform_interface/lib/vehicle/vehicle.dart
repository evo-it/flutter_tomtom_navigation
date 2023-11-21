/// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/vehicle/model/com.tomtom.sdk.vehicle/-vehicle/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';

import 'car.dart';
import 'vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class Vehicle {
  const Vehicle(this.type, {this.maxSpeed});

  final Speed? maxSpeed;
  static const pedestrianSpeedKmh = 5;
  static const bicycleSpeedKmh = 20;

  @JsonKey(includeToJson: true)
  final VehicleType type;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final type = $enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicleType']) ??
        VehicleType.car;
    return switch (type) {
      VehicleType.car => Car.fromJson(json),
      // VehicleType.truck => Truck(),
      _ => Car(),
    };
  }

  // toJson should be overriden by all implementations of the Vehicle.
  Map<String, dynamic> toJson();
}

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
