// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/vehicle/model/com.tomtom.sdk.vehicle/-vehicle/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/bicycle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/pedestrian.dart';

import 'bus.dart';
import 'car.dart';
import 'motorcycle.dart';
import 'taxi.dart';
import 'truck.dart';
import 'van.dart';
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
    final type =
        $enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicleType']) ??
            VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return Car.fromJson(json);
      case VehicleType.truck:
        return Truck.fromJson(json);
      case VehicleType.taxi:
        return Taxi.fromJson(json);
      case VehicleType.bus:
        return Bus.fromJson(json);
      case VehicleType.van:
        return Van.fromJson(json);
      case VehicleType.motorcycle:
        return Motorcycle.fromJson(json);
      case VehicleType.bicycle:
        return Bicycle.fromJson(json);
      case VehicleType.pedestrian:
        return Pedestrian.fromJson(json);
    }
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
