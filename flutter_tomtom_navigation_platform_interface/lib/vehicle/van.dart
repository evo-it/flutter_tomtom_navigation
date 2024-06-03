import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/adr_tunnel_restriction_code.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/cargo_capable.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/hazmat_class.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'van.g.dart';

@JsonSerializable(explicitToJson: true)
class Van extends Vehicle with Motorized, CargoCapable {
  const Van({
    super.maxSpeed,
    this.isCommercial = false,
    this.dimensions,
    this.hazmatClasses = const {},
    this.adrTunnelRestrictionCode,
    this.modelId,
  }) : super(VehicleType.van);

  factory Van.fromJson(Map<String, dynamic> json) => _$VanFromJson(json);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  Map<String, dynamic> toJson() => _$VanToJson(this);

  @override
  final AdrTunnelRestrictionCode? adrTunnelRestrictionCode;

  @override
  final Set<HazmatClass> hazmatClasses;
}
