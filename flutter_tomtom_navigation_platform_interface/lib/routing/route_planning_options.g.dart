// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_planning_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutePlanningOptions _$RoutePlanningOptionsFromJson(
        Map<String, dynamic> json) =>
    RoutePlanningOptions(
      itinerary: Itinerary.fromJson(json['itinerary'] as Map<String, dynamic>),
      costModel: json['costModel'] == null
          ? const CostModel()
          : CostModel.fromJson(json['costModel'] as Map<String, dynamic>),
      departAt: json['departAt'] == null
          ? null
          : DateTime.parse(json['departAt'] as String),
      arriveAt: json['arriveAt'] == null
          ? null
          : DateTime.parse(json['arriveAt'] as String),
      routeLegOptions: (json['routeLegOptions'] as List<dynamic>?)
              ?.map((e) => RouteLegOptions.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      vehicle: json['vehicle'] == null
          ? const Car()
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      alternativeRoutesOptions: json['alternativeRoutesOptions'] == null
          ? null
          : AlternativeRoutesOptions.fromJson(
              json['alternativeRoutesOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoutePlanningOptionsToJson(
        RoutePlanningOptions instance) =>
    <String, dynamic>{
      'alternativeRoutesOptions': instance.alternativeRoutesOptions?.toJson(),
      'arriveAt': instance.arriveAt?.toIso8601String(),
      'costModel': instance.costModel.toJson(),
      'departAt': instance.departAt?.toIso8601String(),
      'itinerary': instance.itinerary.toJson(),
      'routeLegOptions':
          instance.routeLegOptions.map((e) => e.toJson()).toList(),
      'vehicle': instance.vehicle.toJson(),
    };
