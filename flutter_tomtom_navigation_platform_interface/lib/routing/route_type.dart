// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options.calculation/-route-type/index.html

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.pascal)
enum RouteType {
  fast,
  short,
  efficient,
  // TODO(Frank): Support configurable thrilling as a class.
  thrilling;
}
