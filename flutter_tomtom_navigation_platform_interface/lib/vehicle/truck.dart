import 'package:flutter_tomtom_navigation_platform_interface/quantity/speed.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/adr_tunnel_restriction_code.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/cargo_capable.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/hazmat_class.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/motorized.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'truck.g.dart';

@JsonSerializable(explicitToJson: true)
class Truck extends Vehicle with Motorized, CargoCapable {
  const Truck({
    super.maxSpeed,
    this.isCommercial = false,
    this.dimensions,
    this.hazmatClasses = const {},
    this.adrTunnelRestrictionCode,
    this.modelId,
  }) : super(VehicleType.truck);

  @override
  final bool isCommercial;

  @override
  final VehicleDimensions? dimensions;

  @override
  final String? modelId;

  @override
  final AdrTunnelRestrictionCode? adrTunnelRestrictionCode;

  @override
  final Set<HazmatClass> hazmatClasses;

  @override
  Map<String, dynamic> toJson() => _$TruckToJson(this);

  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);
}
