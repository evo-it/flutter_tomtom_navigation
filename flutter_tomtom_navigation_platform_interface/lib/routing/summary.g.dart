// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      length: (json['length'] as num).toDouble(),
      travelTime:
          Summary._durationFromHalfNanoseconds(json['travelTime'] as int),
      trafficDelay: json['trafficDelay'] == null
          ? Duration.zero
          : Summary._durationFromHalfNanoseconds(json['trafficDelay'] as int),
      trafficLength: json['trafficLength'] as int? ?? 0,
      departureTimeWithZone: Summary._dateTimeFromMap(
          json['departureTimeWithZone'] as Map<String, dynamic>),
      arrivalTimeWithZone: Summary._dateTimeFromMap(
          json['arrivalTimeWithZone'] as Map<String, dynamic>),
      reachableOffset: (json['reachableOffset'] as num?)?.toDouble(),
    );
