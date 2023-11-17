// TODO Use actual (scraped) RoutePlanningOptions instead.
import 'package:flutter_tomtom_navigation_platform_interface/routing/itinerary_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_planning_options.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutePlanningOptions {
  const RoutePlanningOptions({required this.destination});

  final ItineraryPoint destination;

  Map<String, dynamic> toJson() => _$RoutePlanningOptionsToJson(this);

  factory RoutePlanningOptions.fromJson(Map<String, dynamic> json) => _$RoutePlanningOptionsFromJson(json);
}
