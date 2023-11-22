import 'package:json_annotation/json_annotation.dart';

part 'speed.g.dart';

@JsonSerializable(explicitToJson: true, constructor: '_')
class Speed {
  const Speed._(this.rawValue);

  static const _factorMetersPerSecond = 1e9;
  static const _factorMetersPerHour = 277778;
  static const _factorKilometersPerHour = 277778000;
  static const _factorMilesPerHour = 447040000;

  static const zero = Speed._(0);

  factory Speed.metersPerSecond(num metersPerSecond) => Speed._((metersPerSecond * _factorMetersPerSecond).round());

  factory Speed.metersPerHour(num metersPerHour) => Speed._((metersPerHour * _factorMetersPerHour).round());
  factory Speed.kilometersPerHour(num kilometersPerHour) => Speed._((kilometersPerHour * _factorKilometersPerHour).round());
  factory Speed.milesPerHour(num milesPerHour) => Speed._((milesPerHour * _factorMilesPerHour).round());

  final int rawValue;

  Map<String, dynamic> toJson() => _$SpeedToJson(this);

  factory Speed.fromJson(Map<String, dynamic> json) =>
      _$SpeedFromJson(json);
}
