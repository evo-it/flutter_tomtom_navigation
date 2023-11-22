// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.38.0/maps/display-api/com.tomtom.sdk.map.display.common.screen/-padding/index.html

import 'package:json_annotation/json_annotation.dart';

part 'padding.g.dart';

@JsonSerializable(explicitToJson: true)
class Padding {
  const Padding({
    int padding = 0,
  })  : top = padding,
        left = padding,
        right = padding,
        bottom = padding;

  @JsonKey(includeToJson: true, includeFromJson: true)
  final int bottom;
  @JsonKey(includeToJson: true, includeFromJson: true)
  final int left;
  @JsonKey(includeToJson: true, includeFromJson: true)
  final int right;
  @JsonKey(includeToJson: true, includeFromJson: true)
  final int top;

  Map<String, dynamic> toJson() => _$PaddingToJson(this);

  factory Padding.fromJson(Map<String, dynamic> json) =>
      _$PaddingFromJson(json);
}
