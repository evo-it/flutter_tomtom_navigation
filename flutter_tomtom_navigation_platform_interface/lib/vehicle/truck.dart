import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'truck.g.dart';

@JsonSerializable(explicitToJson: true)
class Truck extends Vehicle {
  const Truck({super.maxSpeed}) : super(VehicleType.truck);

  @override
  Map<String, dynamic> toJson() => _$TruckToJson(this);

  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);
}
