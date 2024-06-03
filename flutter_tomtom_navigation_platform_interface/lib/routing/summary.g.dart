// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      length: (json['length'] as num).toDouble(),
      travelTime:
          durationFromHalfNanoseconds((json['travelTime'] as num).toInt()),
      trafficDelay: json['trafficDelay'] == null
          ? Duration.zero
          : durationFromHalfNanoseconds((json['trafficDelay'] as num).toInt()),
      trafficLength: (json['trafficLength'] as num?)?.toInt() ?? 0,
      departureTimeWithZone: Summary._dateTimeFromMap(
          json['departureTimeWithZone'] as Map<String, dynamic>),
      arrivalTimeWithZone: Summary._dateTimeFromMap(
          json['arrivalTimeWithZone'] as Map<String, dynamic>),
      reachableOffset: (json['reachableOffset'] as num?)?.toDouble(),
    );
