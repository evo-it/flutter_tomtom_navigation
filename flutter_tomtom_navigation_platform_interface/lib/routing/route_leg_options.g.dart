// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_leg_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteLegOptions _$RouteLegOptionsFromJson(Map<String, dynamic> json) =>
    RouteLegOptions(
      supportingPoints: (json['supportingPoints'] as List<dynamic>)
          .map((e) => GeoPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteLegOptionsToJson(RouteLegOptions instance) =>
    <String, dynamic>{
      'supportingPoints':
          instance.supportingPoints.map((e) => e.toJson()).toList(),
    };
