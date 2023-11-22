import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bus.g.dart';

@JsonSerializable(explicitToJson: true)
class Bus extends Vehicle with Motorized {
  const Bus({
    super.maxSpeed,
    this.isCommercial = true,
    this.dimensions,
    this.modelId,
  }) : super(VehicleType.bus);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  Map<String, dynamic> toJson() => _$BusToJson(this);

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
}
