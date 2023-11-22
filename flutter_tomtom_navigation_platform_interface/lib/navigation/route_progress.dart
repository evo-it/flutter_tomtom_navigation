// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/navigation/navigation-engines/com.tomtom.sdk.navigation.progress/-route-progress/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';

import 'route_stops_progress.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_progress.g.dart';

@JsonSerializable(explicitToJson: true)
class RouteProgress {
  RouteProgress({
    this.remainingTime = Duration.zero,

    /// Default value Duration = Duration.ZERO,
    this.distanceAlongRoute = Distance.zero,

    /// Default value Distance = Distance.ZERO,
    this.remainingRouteStopsProgress = const [],

    /// Default value List<RouteStopsProgress> = emptyList(),
    this.remainingTrafficDelay = Duration.zero,

    /// Default value Duration = Duration.ZERO,
  });

  @JsonKey(fromJson: _distanceFromRawValue)
  final Distance distanceAlongRoute;
  final List<RouteStopsProgress> remainingRouteStopsProgress;
  @JsonKey(
      name: 'remainingTime',
      fromJson: _durationFromHalfNanoseconds,
      toJson: _durationToHalfNanoseconds)
  final Duration remainingTime;
  @JsonKey(
      name: 'remainingTrafficDelay',
      fromJson: _durationFromHalfNanoseconds,
      toJson: _durationToHalfNanoseconds)
  final Duration remainingTrafficDelay;

  Map<String, dynamic> toJson() => _$RouteProgressToJson(this);

  factory RouteProgress.fromJson(Map<String, dynamic> json) =>
      _$RouteProgressFromJson(json);

  static Duration _durationFromHalfNanoseconds(int halfNanos) =>
      Duration(microseconds: (halfNanos / 1000 / 2).round());

  static int _durationToHalfNanoseconds(Duration duration) =>
      duration.inMicroseconds * 1000 * 2;

  static Distance _distanceFromRawValue(int value) =>
      Distance.fromJson({'rawValue': value});
}
