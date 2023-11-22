// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.38.0/maps/display-api/com.tomtom.sdk.map.display/-map-options/index.html

import 'camera_options.dart';
import 'style_descriptor.dart';
import 'padding.dart';
import 'style_mode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_options.g.dart';


@JsonSerializable(explicitToJson: true)
class MapOptions {
	const MapOptions({
		required this.mapKey,/// Default value String,
		this.cameraOptions, /// Default value CameraOptions? = null,
		this.padding = const Padding(),/// Default value Padding = Padding(),
		this.mapStyle, /// Default value StyleDescriptor? = null,
		this.styleMode = StyleMode.main,/// Default value StyleMode = StyleMode.MAIN,
		// required this.onlineCachePolicy,/// Default value OnlineCachePolicy = OnlineCachePolicy.Default,
		this.renderToTexture = false,/// Default value Boolean = false,
	});
 
	 final CameraOptions? cameraOptions;
	 final String mapKey;
	 final StyleDescriptor? mapStyle;
	 // final OnlineCachePolicy onlineCachePolicy;
	 final Padding padding;
	 final bool renderToTexture;
	 final StyleMode styleMode;

	Map<String, dynamic> toJson() => _$MapOptionsToJson(this);

	factory MapOptions.fromJson(Map<String, dynamic> json) => _$MapOptionsFromJson(json);
}