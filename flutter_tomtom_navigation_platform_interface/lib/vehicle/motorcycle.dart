import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'motorcycle.g.dart';

@JsonSerializable(explicitToJson: true)
class Motorcycle extends Vehicle with Motorized {
  const Motorcycle({
    super.maxSpeed,
    this.isCommercial = false,
    this.dimensions,
    this.modelId,
  }) : super(VehicleType.motorcycle);

  factory Motorcycle.fromJson(Map<String, dynamic> json) =>
      _$MotorcycleFromJson(json);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  Map<String, dynamic> toJson() => _$MotorcycleToJson(this);
}
