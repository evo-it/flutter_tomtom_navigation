// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options/-route-planning-options/index.html

import 'package:flutter_tomtom_navigation_platform_interface/routing/alternative_routes_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/cost_model.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/itinerary.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_leg_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/car.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_planning_options.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutePlanningOptions {
  const RoutePlanningOptions({
    required this.itinerary,
    this.costModel = const CostModel(),
    this.departAt,
    this.arriveAt,

    /// Default value Date? = null,
    // this.alternativeRoutesOptions, /// Default value AlternativeRoutesOptions? = null,
    // this.guidanceOptions, /// Default value GuidanceOptions? = null,
    this.routeLegOptions = const [],

    /// Default value List<RouteLegOptions> = emptyList(),
    this.vehicle = const Car(),
    this.alternativeRoutesOptions,
    // this.chargingOptions, /// Default value ChargingOptions? = null,
    // this.queryOptions, /// Default value QueryOptions? = null,
    // this.waypointOptimization, /// Default value WaypointOptimization? = null,
    // required this.mode,/// Default value RouteInformationMode = RouteInformationMode.Complete,
    // required this.arrivalSidePreference,/// Default value ArrivalSidePreference = ArrivalSidePreference.AnySide,
  });

  factory RoutePlanningOptions.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanningOptionsFromJson(json);

  final AlternativeRoutesOptions? alternativeRoutesOptions;
  // final ArrivalSidePreference arrivalSidePreference;
  final DateTime? arriveAt;
  // final ChargingOptions? chargingOptions;
  final CostModel costModel;
  final DateTime? departAt;
  // final GuidanceOptions? guidanceOptions;
  final Itinerary itinerary;
  // final RouteInformationMode mode;
  // final QueryOptions? queryOptions;
  final List<RouteLegOptions> routeLegOptions;
  final Vehicle vehicle;
  // final WaypointOptimization? waypointOptimization;

  Map<String, dynamic> toJson() => _$RoutePlanningOptionsToJson(this);
}
