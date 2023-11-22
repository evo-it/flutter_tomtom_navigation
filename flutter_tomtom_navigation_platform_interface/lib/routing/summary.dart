// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.route/-summary/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable(createToJson: false)
class Summary {
  Summary({
    required this.length,

    /// Default value Distance,
    required this.travelTime,

    /// Default value Duration,
    this.trafficDelay = Duration.zero,

    /// Default value Duration = Duration.ZERO,
    this.trafficLength = 0,

    /// Default value Distance = Distance.ZERO,
    required this.departureTimeWithZone,

    /// Default value Calendar,
    required this.arrivalTimeWithZone,

    /// Default value Calendar,
    // this.consumptionForWholeLength, /// Default value Consumption? = null,
    // this.consumptionUpToReachableOffset, /// Default value Consumption? = null,
    // this.remainingBudget, /// Default value Consumption? = null,
    this.reachableOffset,

    /// Default value Distance? = null,
  });

  @JsonKey(fromJson: _dateTimeFromMap)
  final DateTime arrivalTimeWithZone;

  // final Consumption? consumptionForWholeLength;
  // final Consumption? consumptionUpToReachableOffset;
  @JsonKey(fromJson: _dateTimeFromMap)
  final DateTime departureTimeWithZone;
  final double length;
  final double? reachableOffset;

  // final Consumption? remainingBudget;
  @JsonKey(name: 'trafficDelay', fromJson: _durationFromHalfNanoseconds)
  final Duration trafficDelay;
  final int trafficLength;
  @JsonKey(name: 'travelTime', fromJson: _durationFromHalfNanoseconds)
  final Duration travelTime;

  factory Summary.fromJson(Map<String, dynamic> json) {
    print(json);
    return _$SummaryFromJson(json);
  }

  static Duration _durationFromHalfNanoseconds(int halfNanos) =>
      Duration(microseconds: (halfNanos / 1000 / 2).round());

  static DateTime _dateTimeFromMap(Map<String, dynamic> map) => DateTime(
        map['year'],
        map['month'],
        map['dayOfMonth'],
        map['hourOfDay'],
        map['minute'],
        map['second'],
      );
}
