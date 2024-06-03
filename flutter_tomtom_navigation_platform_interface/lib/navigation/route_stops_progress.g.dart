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
          : durationFromHalfNanoseconds((json['remainingTime'] as num).toInt()),
      remainingDistance: json['remainingDistance'] == null
          ? Distance.zero
          : distanceFromRawValue((json['remainingDistance'] as num).toInt()),
      remainingTrafficDelay: json['remainingTrafficDelay'] == null
          ? Duration.zero
          : durationFromHalfNanoseconds(
              (json['remainingTrafficDelay'] as num).toInt()),
    );

Map<String, dynamic> _$RouteStopsProgressToJson(RouteStopsProgress instance) =>
    <String, dynamic>{
      'remainingDistance': instance.remainingDistance.toJson(),
      'remainingTime': durationToHalfNanoseconds(instance.remainingTime),
      'remainingTrafficDelay':
          durationToHalfNanoseconds(instance.remainingTrafficDelay),
      'routeStopId': instance.routeStopId,
    };
