// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.38.0/maps/display-api/com.tomtom.sdk.map.display.style/-style-mode/index.html

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum StyleMode {
  main,
  dark,
}
