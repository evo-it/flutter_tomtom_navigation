import 'package:json_annotation/json_annotation.dart';

part 'vehicle_load_type.g.dart';

@JsonSerializable(explicitToJson: true)
class VehicleLoadType {
  static const unHazmatClass1 = VehicleLoadType(0);
  static const unHazmatClass2 = VehicleLoadType(1);
  static const unHazmatClass3 = VehicleLoadType(2);
  static const unHazmatClass4 = VehicleLoadType(3);
  static const unHazmatClass5 = VehicleLoadType(4);
  static const unHazmatClass6 = VehicleLoadType(5);
  static const unHazmatClass7 = VehicleLoadType(6);
  static const unHazmatClass8 = VehicleLoadType(7);
  static const unHazmatClass9 = VehicleLoadType(8);
  static const otherHazmatExplosive = VehicleLoadType(9);
  static const otherHazmatGeneral = VehicleLoadType(10);
  static const otherHazmatHarmfulToWater = VehicleLoadType(11);

  const VehicleLoadType(this.value);

  final int value;

  Map<String, dynamic> toJson() => _$VehicleLoadTypeToJson(this);

  factory VehicleLoadType.fromJson(Map<String, dynamic> json) =>
      _$VehicleLoadTypeFromJson(json);
}
