// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.39.1/location/model/com.tomtom.sdk.location/-geo-location/index.html

import '../quantity/angle.dart';
import '../quantity/distance.dart';
import '../quantity/speed.dart';
import '../routing/geo_point.dart';
import 'location_provider_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_location.g.dart';


@JsonSerializable(explicitToJson: true)
class GeoLocation {
	GeoLocation({
		required this.position,/// Default value GeoPoint,
		this.accuracy, /// Default value Distance? = null,
		this.course, /// Default value Angle? = null,
		this.speed, /// Default value Speed? = null,
		this.altitude, /// Default value Distance? = null,
		int? time,/// Default value Long = System.currentTimeMillis(),
		this.elapsedRealtimeNanos = 0, /// Default value Long = SystemClock.elapsedRealtimeNanos(),
		this.provider = 'DEFAULT_PROVIDER',/// Default value String = DEFAULT_PROVIDER,
		this.providerType = LocationProviderType.realtime, /// Default value LocationProviderType = LocationProviderType.REALTIME,
	}) : time = time ?? DateTime.now().millisecondsSinceEpoch;

	 final Distance? accuracy;
	 final Distance? altitude;
	 final Angle? course;
	 final int elapsedRealtimeNanos;
	 final GeoPoint position;
	 final String provider;
	 final LocationProviderType providerType;
	 final Speed? speed;
	 final int time;

	Map<String, dynamic> toJson() => _$GeoLocationToJson(this);

	factory GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);
}