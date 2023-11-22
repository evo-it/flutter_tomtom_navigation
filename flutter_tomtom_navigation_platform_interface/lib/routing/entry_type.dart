// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/location/model/com.tomtom.sdk.location/-entry-type/index.html

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'type')
enum EntryType {
  main(0),
  minor(1);

  const EntryType(this.type);

  final int type;
}
