// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.39.1/routing/model/com.tomtom.sdk.routing.options/-route-leg-options/index.html

import 'geo_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_leg_options.g.dart';


@JsonSerializable(explicitToJson: true)
class RouteLegOptions {
	const RouteLegOptions({
		required this.supportingPoints,/// Default value List<GeoPoint>,
		// this.chargingInformation, /// Default value ChargingInformation? = null,
	}); 
 
	 // final ChargingInformation? chargingInformation;
	 final List<GeoPoint> supportingPoints;

	Map<String, dynamic> toJson() => _$RouteLegOptionsToJson(this);

	factory RouteLegOptions.fromJson(Map<String, dynamic> json) => _$RouteLegOptionsFromJson(json);
}