// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options.calculation/-avoid-type/index.html

import 'package:json_annotation/json_annotation.dart';

part 'avoid_type.g.dart';

@JsonSerializable(explicitToJson: true)
class AvoidType {
  const AvoidType(this.value);

  static const tollRoads = AvoidType(0);
  static const motorways = AvoidType(1);
  static const ferries = AvoidType(2);
  static const unpavedRoads = AvoidType(3);
  static const carPools = AvoidType(4);
  static const alreadyUsedRoads = AvoidType(5);
  static const borderCrossings = AvoidType(6);
  static const tunnels = AvoidType(7);
  static const carTrains = AvoidType(8);
  static const lowEmissionZones = AvoidType(9);

  final int value;

  Map<String, dynamic> toJson() => _$AvoidTypeToJson(this);

  factory AvoidType.fromJson(Map<String, dynamic> json) =>
      _$AvoidTypeFromJson(json);
}
