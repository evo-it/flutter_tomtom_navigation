// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/location/model/com.tomtom.sdk.location/-place/index.html

import 'package:flutter_tomtom_navigation_platform_interface/routing/address.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/entry_point.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/geo_point.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable(explicitToJson: true)
class Place {
  const Place({
    required this.coordinate,

    /// Default value GeoPoint,
    this.name = '',

    /// Default value String = "",
    this.address,

    /// Default value Address? = null,
    this.entryPoints = const [],

    /// Default value List<EntryPoint> = emptyList(),
  }) : _types = const [];

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  final Address? address;
  final GeoPoint coordinate;
  final List<EntryPoint> entryPoints;
  final String name;
  @JsonKey(includeFromJson: true, includeToJson: true)
  final List<Type> _types;

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
