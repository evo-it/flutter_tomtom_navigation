// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options/-itinerary-point/index.html

import 'package:flutter_tomtom_navigation_platform_interface/routing/place.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'itinerary_point.g.dart';

const uuid = Uuid();

@JsonSerializable(explicitToJson: true)
class ItineraryPoint {
  ItineraryPoint({
    required this.place,

    /// Default value Place,
    this.heading,

    /// Default value Angle? = null,
  }) : id = uuid.v4();

  final double? heading;
  @JsonKey(includeFromJson: true, includeToJson: true)
  final String id;
  final Place place;

  Map<String, dynamic> toJson() => _$ItineraryPointToJson(this);

  factory ItineraryPoint.fromJson(Map<String, dynamic> json) =>
      _$ItineraryPointFromJson(json);
}
