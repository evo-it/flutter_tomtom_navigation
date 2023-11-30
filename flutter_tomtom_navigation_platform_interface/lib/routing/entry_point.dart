// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/location/model/com.tomtom.sdk.location/-entry-point/index.html

import 'geo_point.dart';
import 'entry_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_point.g.dart';


@JsonSerializable(explicitToJson: true)
class EntryPoint {
	const EntryPoint({
		required this.type,/// Default value EntryType,
		required this.position,/// Default value GeoPoint,
	});
	 final GeoPoint position;
	final EntryType type;

	Map<String, dynamic> toJson() => _$EntryPointToJson(this);

	factory EntryPoint.fromJson(Map<String, dynamic> json) => _$EntryPointFromJson(json);
}