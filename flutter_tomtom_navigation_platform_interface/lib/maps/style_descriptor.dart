// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.38.0/maps/display-api/com.tomtom.sdk.map.display.style/-style-descriptor/index.html

import 'package:json_annotation/json_annotation.dart';

part 'style_descriptor.g.dart';

@JsonSerializable(explicitToJson: true)
class StyleDescriptor {
  const StyleDescriptor({
    required this.uri, // Default value Uri,
    this.darkUri, // Default value Uri? = null,
    this.layerMappingUri, // Default value Uri? = null,
    this.darkLayerMappingUri, // Default value Uri? = null,
  });

  factory StyleDescriptor.fromJson(Map<String, dynamic> json) =>
      _$StyleDescriptorFromJson(json);

  final Uri? darkLayerMappingUri;
  final Uri? darkUri;
  final Uri? layerMappingUri;
  final Uri uri;

  Map<String, dynamic> toJson() => _$StyleDescriptorToJson(this);
}
