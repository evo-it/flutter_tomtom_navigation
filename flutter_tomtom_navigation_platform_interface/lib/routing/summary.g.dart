// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      departureTimeWithZone: dateTimeFromMap(
          json['departureTimeWithZone'] as Map<String, dynamic>),
      arrivalTimeWithZone:
          dateTimeFromMap(json['arrivalTimeWithZone'] as Map<String, dynamic>),
      length: (json['length'] as num).toDouble(),
      travelTime:
          durationFromHalfNanoseconds((json['travelTime'] as num).toInt()),
      trafficDelay: json['trafficDelay'] == null
          ? Duration.zero
          : durationFromHalfNanoseconds((json['trafficDelay'] as num).toInt()),
      trafficLength: (json['trafficLength'] as num?)?.toInt() ?? 0,
      reachableOffset: (json['reachableOffset'] as num?)?.toDouble(),
    );
