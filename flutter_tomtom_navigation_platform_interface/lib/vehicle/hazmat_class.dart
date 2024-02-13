import 'package:json_annotation/json_annotation.dart';

part 'hazmat_class.g.dart';

/// Represents types of cargo that may be classified as hazardous materials and
/// restricted from some roads. The available values are UN Hazmat classes
/// 1 through 9 for use in the US, plus additional generic classifications
/// for use in other countries.
@JsonSerializable(explicitToJson: true)
class HazmatClass {
  /// Initialize a [HazmatClass] with its value.
  const HazmatClass(this.value);

  /// Parse a [HazmatClass] from its value in JSON.
  factory HazmatClass.fromJson(Map<String, dynamic> json) =>
      _$HazmatClassFromJson(json);

  /// Defines that the cargo contains explosives.
  static const unClass1Explosive = HazmatClass(0);

  /// Defines that the cargo contains hazardous gases.
  static const unClass2Gas = HazmatClass(1);

  /// Defines that the cargo contains flammable and combustible liquids.
  static const unClass3FlammableLiquid = HazmatClass(2);

  /// Defines that the cargo contains flammable solids.
  static const unClass4FlammableSolid = HazmatClass(3);

  /// Defines that the cargo contains
  /// oxidizing substances and organic peroxides.
  static const unClass5Oxidizing = HazmatClass(4);

  /// Defines that the cargo contains
  /// toxic substances and infectious substances.
  static const unClass6Toxic = HazmatClass(5);

  /// Defines that the cargo contains radioactive materials.
  static const unClass7Radioactive = HazmatClass(6);

  /// Defines that the cargo contains corrosives.
  static const unClass8Corrosive = HazmatClass(7);

  /// Defines that the cargo contains miscellaneous hazardous materials.
  static const unClass9Misc = HazmatClass(8);

  /// Defines that the cargo contains explosive materials.
  /// This is a generic classification for use in countries other than the US.
  static const intlExplosive = HazmatClass(9);

  /// Defines that the cargo contains general hazardous materials.
  /// This is a generic classification for use in countries other than the US.
  static const intlGeneral = HazmatClass(10);

  /// Defines that the cargo contains hazardous substances
  /// that are harmful to water.
  /// This is a generic classification for use in countries other than the US.
  static const intlHarmfulToWater = HazmatClass(11);

  /// Integer value representing this [HazmatClass]
  final int value;

  /// Stringify a [HazmatClass] to its JSON value.
  Map<String, dynamic> toJson() => _$HazmatClassToJson(this);
}
