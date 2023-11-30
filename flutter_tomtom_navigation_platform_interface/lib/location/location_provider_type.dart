// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.39.1/location/model/com.tomtom.sdk.location/-location-provider-type/index.html

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum LocationProviderType {
	/// Location provided has been triangulated in realtime, eg from GPS satellites or a NETWORK.
	realtime,
	/// Location calculated programmatically, e.g.: extrapolated from map data based on speed profiles of a current road.
	softDr,
}