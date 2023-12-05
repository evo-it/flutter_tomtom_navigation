// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvoidOptions _$AvoidOptionsFromJson(Map<String, dynamic> json) => AvoidOptions(
      avoidTypes: (json['avoidTypes'] as List<dynamic>?)
              ?.map((e) => AvoidType.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      avoidAreas: (json['avoidAreas'] as List<dynamic>?)
              ?.map((e) => GeoBoundingBox.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      vignettes: json['vignettes'] == null
          ? null
          : Vignettes.fromJson(json['vignettes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvoidOptionsToJson(AvoidOptions instance) =>
    <String, dynamic>{
      'avoidAreas': instance.avoidAreas.map((e) => e.toJson()).toList(),
      'avoidTypes': instance.avoidTypes.map((e) => e.toJson()).toList(),
      'vignettes': instance.vignettes?.toJson(),
    };
