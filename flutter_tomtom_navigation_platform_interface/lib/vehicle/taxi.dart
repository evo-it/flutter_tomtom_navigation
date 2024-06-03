import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'taxi.g.dart';

@JsonSerializable(explicitToJson: true)
class Taxi extends Vehicle with Motorized {
  const Taxi({
    super.maxSpeed,
    this.isCommercial = true,
    this.dimensions,
    this.modelId,
  }) : super(VehicleType.taxi);

  factory Taxi.fromJson(Map<String, dynamic> json) => _$TaxiFromJson(json);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  Map<String, dynamic> toJson() => _$TaxiToJson(this);
}
