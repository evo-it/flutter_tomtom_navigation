/// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/vehicle/model/com.tomtom.sdk.vehicle/-vehicle-dimensions/index.html

import 'package:flutter_tomtom_navigation_platform_interface/quantity/distance.dart';
import 'package:flutter_tomtom_navigation_platform_interface/quantity/weight.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_dimensions.g.dart';

@JsonSerializable(explicitToJson: true)
class VehicleDimensions {
	VehicleDimensions({
		this.weight, /// Default value Weight? = null,
		this.axleWeight, /// Default value Weight? = null,
		this.length, /// Default value Distance? = null,
		this.width, /// Default value Distance? = null,
		this.height, /// Default value Distance? = null,
		this.numberOfAxles, /// Default value Int? = null,
	}); 
 
	 final Weight? axleWeight;
	 final Distance? height;
	 final Distance? length;
	 final int? numberOfAxles;
	 final Weight? weight;
	 final Distance? width;

	Map<String, dynamic> toJson() => _$VehicleDimensionsToJson(this);

	factory VehicleDimensions.fromJson(Map<String, dynamic> json) => _$VehicleDimensionsFromJson(json);
}
