// TODO Use actual (scraped) RoutePlanningOptions instead.
import 'package:flutter_tomtom_navigation_platform_interface/routing/itinerary_point.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/vehicle_dimensions.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/vehicle_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_planning_options.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutePlanningOptions {
  const RoutePlanningOptions({
    required this.destination,
    this.vehicleDimensions,
    this.vehicleType = VehicleType.car,
  });

  final ItineraryPoint destination;
  final VehicleDimensions? vehicleDimensions;
  final VehicleType vehicleType;

  Map<String, dynamic> toJson() => _$RoutePlanningOptionsToJson(this);

  factory RoutePlanningOptions.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanningOptionsFromJson(json);
}
