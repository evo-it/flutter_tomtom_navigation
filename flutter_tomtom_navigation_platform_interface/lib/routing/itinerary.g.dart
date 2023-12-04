// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Itinerary _$ItineraryFromJson(Map<String, dynamic> json) => Itinerary(
      origin: ItineraryPoint.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          ItineraryPoint.fromJson(json['destination'] as Map<String, dynamic>),
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => ItineraryPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      heading: json['heading'] == null
          ? null
          : Angle.fromJson(json['heading'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItineraryToJson(Itinerary instance) => <String, dynamic>{
      'destination': instance.destination.toJson(),
      'origin': instance.origin.toJson(),
      'waypoints': instance.waypoints.map((e) => e.toJson()).toList(),
      'heading': instance.heading?.toJson(),
    };
