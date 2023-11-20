import 'package:json_annotation/json_annotation.dart';

part 'distance.g.dart';

@JsonSerializable(explicitToJson: true, constructor: '_')
class Distance {
  const Distance._(this.rawValue);

  static const _factorMillimeters = 1e3;
  static const _factorCentimeters = 1e4;
  static const _factorMeters = 1e6;
  static const _factorKilometers = 1e9;
  static const _factorInches = 25400;
  static const _factorFeet = 304800;
  static const _factorYards = 914400;
  static const _factorMiles = 1609344000;

  static const zero = Distance._(0);

  factory Distance.millimeters(num millimeters) =>
      Distance._((millimeters * _factorMillimeters).round());

  factory Distance.centimeters(num centimeters) =>
      Distance._((centimeters * _factorCentimeters).round());

  factory Distance.meters(num meters) =>
      Distance._((meters * _factorMeters).round());

  factory Distance.kilometers(num kilometers) =>
      Distance._((kilometers * _factorKilometers).round());

  factory Distance.inches(num inches) =>
      Distance._((inches * _factorInches).round());

  factory Distance.feet(num feet) => Distance._((feet * _factorFeet).round());

  factory Distance.yards(num yards) =>
      Distance._((yards * _factorYards).round());

  factory Distance.miles(num miles) =>
      Distance._((miles * _factorMiles).round());

  final int rawValue;

  Map<String, dynamic> toJson() => _$DistanceToJson(this);

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);
}
