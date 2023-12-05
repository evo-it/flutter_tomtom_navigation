// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteProgress _$RouteProgressFromJson(Map<String, dynamic> json) =>
    RouteProgress(
      remainingTime: json['remainingTime'] == null
          ? Duration.zero
          : RouteProgress._durationFromHalfNanoseconds(
              json['remainingTime'] as int),
      distanceAlongRoute: json['distanceAlongRoute'] == null
          ? Distance.zero
          : RouteProgress._distanceFromRawValue(
              json['distanceAlongRoute'] as int),
      remainingRouteStopsProgress: (json['remainingRouteStopsProgress']
                  as List<dynamic>?)
              ?.map(
                  (e) => RouteStopsProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      remainingTrafficDelay: json['remainingTrafficDelay'] == null
          ? Duration.zero
          : RouteProgress._durationFromHalfNanoseconds(
              json['remainingTrafficDelay'] as int),
    );

Map<String, dynamic> _$RouteProgressToJson(RouteProgress instance) =>
    <String, dynamic>{
      'distanceAlongRoute': instance.distanceAlongRoute.toJson(),
      'remainingRouteStopsProgress':
          instance.remainingRouteStopsProgress.map((e) => e.toJson()).toList(),
      'remainingTime':
          RouteProgress._durationToHalfNanoseconds(instance.remainingTime),
      'remainingTrafficDelay': RouteProgress._durationToHalfNanoseconds(
          instance.remainingTrafficDelay),
    };
