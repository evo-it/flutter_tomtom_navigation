import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bicycle.g.dart';

@JsonSerializable(explicitToJson: true)
class Bicycle extends Vehicle {
  Bicycle({Speed? maxSpeed})
      : super(
          VehicleType.bicycle,
          maxSpeed:
              maxSpeed ?? Speed.kilometersPerHour(Vehicle.bicycleSpeedKmh),
        );

  factory Bicycle.fromJson(Map<String, dynamic> json) =>
      _$BicycleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BicycleToJson(this);
}
