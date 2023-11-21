import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable(explicitToJson: true)
class Car extends Vehicle {
  const Car({super.maxSpeed}) : super(VehicleType.car);

  @override
  Map<String, dynamic> toJson() => _$CarToJson(this);

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}