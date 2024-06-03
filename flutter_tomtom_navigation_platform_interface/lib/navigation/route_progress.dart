// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/navigation/navigation-engines/com.tomtom.sdk.navigation.progress/-route-progress/index.html

import 'package:flutter_tomtom_navigation_platform_interface/json_helpers.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/route_stops_progress.dart';
import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_progress.g.dart';

@JsonSerializable(explicitToJson: true)
class RouteProgress {
  const RouteProgress({
    /// Default value Duration = Duration.ZERO,
    this.distanceAlongRoute = Distance.zero,

    /// Default value Distance = Distance.ZERO,
    this.remainingRouteStopsProgress = const [],
  });

  factory RouteProgress.fromJson(Map<String, dynamic> json) =>
      _$RouteProgressFromJson(json);

  @JsonKey(fromJson: distanceFromRawValue)
  final Distance distanceAlongRoute;
  final List<RouteStopsProgress> remainingRouteStopsProgress;

  Map<String, dynamic> toJson() => _$RouteProgressToJson(this);
}
