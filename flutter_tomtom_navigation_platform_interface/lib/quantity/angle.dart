import 'package:json_annotation/json_annotation.dart';

part 'angle.g.dart';

@JsonSerializable(explicitToJson: true, constructor: '_')
class Angle {
  const Angle._(this.rawValue);

  static const _factorDegrees = 1e9;
  static const _factorNanodegrees = 1;
  static const _factorRadians = 57295779513;

  static const zero = Angle._(0);

  factory Angle.degrees(num degrees) =>
      Angle._((degrees * _factorDegrees).round());

  factory Angle.nanodegrees(num nanodegrees) =>
      Angle._((nanodegrees * _factorNanodegrees).round());

  factory Angle.radians(num radians) =>
      Angle._((radians * _factorRadians).round());

  final int rawValue;

  Map<String, dynamic> toJson() => _$AngleToJson(this);

  factory Angle.fromJson(Map<String, dynamic> json) =>
      _$AngleFromJson(json);
}
