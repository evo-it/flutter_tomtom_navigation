/// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options/-itinerary-point/index.html

import 'package:uuid/uuid.dart';

import 'place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary_point.g.dart';

@JsonSerializable(explicitToJson: true)
class ItineraryPoint {
  ItineraryPoint({
    required this.place,

    /// Default value Place,
    this.heading,

    /// Default value Angle? = null,
  }) : id = Uuid().v4();

  final double? heading;
  @JsonKey(includeFromJson: true, includeToJson: true)
  final String id;
  final Place place;

  Map<String, dynamic> toJson() => _$ItineraryPointToJson(this);

  factory ItineraryPoint.fromJson(Map<String, dynamic> json) =>
      _$ItineraryPointFromJson(json);
}
