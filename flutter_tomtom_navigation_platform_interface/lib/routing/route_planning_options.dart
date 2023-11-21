// TODO Use actual (scraped) RoutePlanningOptions instead.
import 'package:flutter_tomtom_navigation_platform_interface/routing/cost_model.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/itinerary_point.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/car.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_planning_options.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutePlanningOptions {
  const RoutePlanningOptions({
    required this.destination,
    this.vehicle = const Car(),
    this.costModel = const CostModel(),
  });

  final ItineraryPoint destination;
  @JsonKey(fromJson: Vehicle.fromJson)
  final Vehicle vehicle;
  final CostModel costModel;

  Map<String, dynamic> toJson() => _$RoutePlanningOptionsToJson(this);

  factory RoutePlanningOptions.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanningOptionsFromJson(json);
}
