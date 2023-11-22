import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable(explicitToJson: true)
class Car extends Vehicle with Motorized {
  const Car({
    super.maxSpeed,
    this.isCommercial = false,
    this.dimensions,
    this.modelId,
  }) : super(VehicleType.car);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  Map<String, dynamic> toJson() => _$CarToJson(this);

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}
