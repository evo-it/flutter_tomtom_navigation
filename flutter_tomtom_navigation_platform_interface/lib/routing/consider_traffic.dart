// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options.calculation/-consider-traffic/index.html

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ConsiderTraffic {
  yes(0),
  no(1);

  const ConsiderTraffic(this.value);

  final int value;
}
