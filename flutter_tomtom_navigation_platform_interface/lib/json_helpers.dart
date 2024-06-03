import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';

Duration durationFromHalfNanoseconds(int halfNanos) =>
    Duration(microseconds: (halfNanos / 1000 / 2).round());

int durationToHalfNanoseconds(Duration duration) =>
    duration.inMicroseconds * 1000 * 2;

Distance distanceFromRawValue(int value) =>
    Distance.fromJson({'rawValue': value});
