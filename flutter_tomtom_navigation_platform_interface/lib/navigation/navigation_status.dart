import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'status')
enum NavigationStatus {
  unknown(-1),
  initializing(0),
  mapLoaded(1),
  restrictionsLoaded(2),
  ready(3),
  running(4),
  stopped(5),
  failed(6);

  const NavigationStatus(this.value);

  final int value;
}
