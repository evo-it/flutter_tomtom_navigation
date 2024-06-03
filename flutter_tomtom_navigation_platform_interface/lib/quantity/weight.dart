import 'package:json_annotation/json_annotation.dart';

part 'weight.g.dart';

@JsonSerializable(explicitToJson: true, constructor: '_')
class Weight {
  factory Weight.grams(num grams) => Weight._((grams * _factorGrams).round());

  factory Weight.kilograms(num kilograms) =>
      Weight._((kilograms * _factorKilograms).round());

  factory Weight.ounces(num ounces) =>
      Weight._((ounces * _factorOunces).round());

  factory Weight.pounds(num pounds) =>
      Weight._((pounds * _factorPounds).round());

  factory Weight.shortTons(num shortTons) =>
      Weight._((shortTons * _factorShortTons).round());

  factory Weight.metricTons(num metricTons) =>
      Weight._((metricTons * _factorMetricTons).round());

  factory Weight.longTons(num longTons) =>
      Weight._((longTons * _factorLongTons).round());

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);
  const Weight._(this.rawValue);

  static const _factorGrams = 1e6;
  static const _factorKilograms = 1e9;
  static const _factorOunces = 28349523;
  static const _factorPounds = 453592370;
  static const _factorShortTons = 907184740000;
  static const _factorMetricTons = 1e12;
  static const _factorLongTons = 1016046908800;

  static const zero = Weight._(0);

  final int rawValue;

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}
