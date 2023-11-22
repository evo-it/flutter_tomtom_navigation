import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'status')
enum NavigationStatus {
  unknown(-1),
  initializing(0),
  ready(1),
  running(2),
  stopped(3),
  failed(4);

  const NavigationStatus(this.value);

  final int value;
}
