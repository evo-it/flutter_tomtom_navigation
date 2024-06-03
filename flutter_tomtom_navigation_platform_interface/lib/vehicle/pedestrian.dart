import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pedestrian.g.dart';

@JsonSerializable(explicitToJson: true)
class Pedestrian extends Vehicle {
  Pedestrian({Speed? maxSpeed})
      : super(
          VehicleType.pedestrian,
          maxSpeed:
              maxSpeed ?? Speed.kilometersPerHour(Vehicle.pedestrianSpeedKmh),
        );

  factory Pedestrian.fromJson(Map<String, dynamic> json) =>
      _$PedestrianFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PedestrianToJson(this);
}
