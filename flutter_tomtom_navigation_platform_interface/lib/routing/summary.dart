// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.route/-summary/index.html

import 'package:flutter_tomtom_navigation_platform_interface/json_helpers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable(createToJson: false)
class Summary {
  const Summary({
    /// Default value Distance = Distance.ZERO,
    required this.departureTimeWithZone,

    /// Default value Calendar,
    required this.arrivalTimeWithZone,

    /// ,
    required this.length,

    /// Default value Distance,
    required this.travelTime,

    /// Default value Duration,
    this.trafficDelay = Duration.zero,

    /// Default value Duration = Duration.ZERO,
    this.trafficLength = 0,

    /// Default value Calendar,
    // this.consumptionForWholeLength, /// Default value Consumption? = null,
    // this.consumptionUpToReachableOffset, /// Default value Consumption? = null,
    // this.remainingBudget, /// Default value Consumption? = null,
    this.reachableOffset,

    /// Default value Distance? = null,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  @JsonKey(fromJson: dateTimeFromMap)
  final DateTime arrivalTimeWithZone;

  // final Consumption? consumptionForWholeLength;
  // final Consumption? consumptionUpToReachableOffset;
  @JsonKey(fromJson: dateTimeFromMap)
  final DateTime departureTimeWithZone;
  final double length;
  final double? reachableOffset;

  // final Consumption? remainingBudget;
  @JsonKey(name: 'trafficDelay', fromJson: durationFromHalfNanoseconds)
  final Duration trafficDelay;
  final int trafficLength;
  @JsonKey(name: 'travelTime', fromJson: durationFromHalfNanoseconds)
  final Duration travelTime;
}
