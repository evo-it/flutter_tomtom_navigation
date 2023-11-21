import 'package:json_annotation/json_annotation.dart';

part 'vehicle_load_type.g.dart';

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum VehicleLoadType {
  unHazmatClass1(0),
  unHazmatClass2(1),
  unHazmatClass3(2),
  unHazmatClass4(3),
  unHazmatClass5(4),
  unHazmatClass6(5),
  unHazmatClass7(6),
  unHazmatClass8(7),
  unHazmatClass9(8),
  otherHazmatExplosive(9),
  otherHazmatGeneral(10),
  otherHazmatHarmfulToWater(11);

  const VehicleLoadType(this.value);

  final int value;
}
