// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.38.0/maps/display-api/com.tomtom.sdk.map.display.camera/-camera-options/index.html

import 'package:flutter_tomtom_navigation_platform_interface/routing/geo_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camera_options.g.dart';

@JsonSerializable(explicitToJson: true)
class CameraOptions {
  const CameraOptions({
    this.position,

    /// Default value GeoPoint? = null,
    this.zoom,

    /// Default value Double? = null,
    this.tilt,

    /// Default value Double? = null,
    this.rotation,

    /// Default value Double? = null,
    this.fieldOfView,

    /// Default value Double? = null,
  });

  // TODO(Frank): These JSON keys are very odd, but that's how they are read in the SDK...
  @JsonKey(name: 'e')
  final double? fieldOfView;
  @JsonKey(name: 'a')
  final GeoPoint? position;
  @JsonKey(name: 'd')
  final double? rotation;
  @JsonKey(name: 'c')
  final double? tilt;
  @JsonKey(name: 'b')
  final double? zoom;

  Map<String, dynamic> toJson() => _$CameraOptionsToJson(this);

  factory CameraOptions.fromJson(Map<String, dynamic> json) =>
      _$CameraOptionsFromJson(json);
}
