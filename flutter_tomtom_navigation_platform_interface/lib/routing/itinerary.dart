// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options/-itinerary/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/angle.dart';

import 'package:flutter_tomtom_navigation_platform_interface/routing/itinerary_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary.g.dart';


@JsonSerializable(explicitToJson: true)
class Itinerary {
	const Itinerary({
		required this.origin,/// Default value GeoPoint,
		required this.destination,/// Default value GeoPoint,
		this.waypoints = const [], /// Default value List<GeoPoint> = emptyList(),
		this.heading, /// Default value Angle? = null,
	}); 
 
	 final ItineraryPoint destination;
	 final ItineraryPoint origin;
	 final List<ItineraryPoint> waypoints;
	 final Angle? heading;

	Map<String, dynamic> toJson() => _$ItineraryToJson(this);

	factory Itinerary.fromJson(Map<String, dynamic> json) => _$ItineraryFromJson(json);
}