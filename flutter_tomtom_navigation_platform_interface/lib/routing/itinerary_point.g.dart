// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryPoint _$ItineraryPointFromJson(Map<String, dynamic> json) =>
    ItineraryPoint(
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      heading: (json['heading'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ItineraryPointToJson(ItineraryPoint instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'id': instance.id,
      'place': instance.place.toJson(),
    };
