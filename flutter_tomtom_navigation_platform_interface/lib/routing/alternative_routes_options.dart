import 'package:flutter_tomtom_navigation_platform_interface/json_helpers.dart';
import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternative_routes_options.g.dart';

@JsonSerializable(explicitToJson: true)
class AlternativeRoutesOptions {
  AlternativeRoutesOptions({
    this.maxAlternatives = 1,
    this.alternativeType,
    this.minDeviationDistance,
    this.minDeviationTime,
  }) {
    if (maxAlternatives < 0 || maxAlternatives > 5) {
      throw ArgumentError(
        'The number of alternatives must be between 0 and 5.',
      );
    }
  }

  factory AlternativeRoutesOptions.fromJson(Map<String, dynamic> json) =>
      _$AlternativeRoutesOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$AlternativeRoutesOptionsToJson(this);

  final int maxAlternatives;
  final AlternativeType? alternativeType;
  @JsonKey(fromJson: distanceFromRawValue)
  final Distance? minDeviationDistance;
  @JsonKey(fromJson: durationFromHalfNanoseconds)
  final Duration? minDeviationTime;
}

@JsonEnum()
enum AlternativeType {
  @JsonValue(0)
  anyRoute(0),
  @JsonValue(1)
  betterRoute(1);

  const AlternativeType(this.value);

  final int value;
}
