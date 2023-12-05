
// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/vehicle/model/com.tomtom.sdk.vehicle/-vehicle/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/bicycle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/bus.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/car.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorcycle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/pedestrian.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/taxi.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/truck.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/van.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

/// Specifies the vehicle (or lack of one).
abstract class Vehicle {
  const Vehicle(this.type, {this.maxSpeed});

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

  static const bicycleSpeedKmh = 20;
  static const pedestrianSpeedKmh = 5;

  final Speed? maxSpeed;
  @JsonKey(includeToJson: true)
  final VehicleType type;

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
