import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum VehicleType {
  car(0),
  truck(1),
  taxi(2),
  bus(3),
  van(4),
  motorcycle(5),
  bicycle(6),
  pedestrian(7);

  const VehicleType(this.value);

  final int value;
}
