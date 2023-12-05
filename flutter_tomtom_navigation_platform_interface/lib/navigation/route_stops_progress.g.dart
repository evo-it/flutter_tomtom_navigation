// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stops_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteStopsProgress _$RouteStopsProgressFromJson(Map<String, dynamic> json) =>
    RouteStopsProgress(
      routeStopId: json['routeStopId'] as String,
      remainingTime: json['remainingTime'] == null
          ? Duration.zero
          : RouteStopsProgress._durationFromHalfNanoseconds(
              json['remainingTime'] as int),
      remainingDistance: json['remainingDistance'] == null
          ? Distance.zero
          : RouteStopsProgress._distanceFromRawValue(
              json['remainingDistance'] as int),
    );

Map<String, dynamic> _$RouteStopsProgressToJson(RouteStopsProgress instance) =>
    <String, dynamic>{
      'remainingDistance': instance.remainingDistance.toJson(),
      'remainingTime':
          RouteStopsProgress._durationToHalfNanoseconds(instance.remainingTime),
      'routeStopId': instance.routeStopId,
    };
