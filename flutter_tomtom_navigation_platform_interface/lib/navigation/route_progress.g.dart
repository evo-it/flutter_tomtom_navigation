// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteProgress _$RouteProgressFromJson(Map<String, dynamic> json) =>
    RouteProgress(
      distanceAlongRoute: json['distanceAlongRoute'] == null
          ? Distance.zero
          : distanceFromRawValue((json['distanceAlongRoute'] as num).toInt()),
      remainingRouteStopsProgress: (json['remainingRouteStopsProgress']
                  as List<dynamic>?)
              ?.map(
                  (e) => RouteStopsProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RouteProgressToJson(RouteProgress instance) =>
    <String, dynamic>{
      'distanceAlongRoute': instance.distanceAlongRoute.toJson(),
      'remainingRouteStopsProgress':
          instance.remainingRouteStopsProgress.map((e) => e.toJson()).toList(),
    };
