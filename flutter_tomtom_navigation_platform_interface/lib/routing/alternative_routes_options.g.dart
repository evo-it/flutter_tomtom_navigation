// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternative_routes_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternativeRoutesOptions _$AlternativeRoutesOptionsFromJson(
        Map<String, dynamic> json) =>
    AlternativeRoutesOptions(
      maxAlternatives: (json['maxAlternatives'] as num?)?.toInt() ?? 0,
      alternativeType: $enumDecodeNullable(
          _$AlternativeTypeEnumMap, json['alternativeType']),
      minDeviationDistance:
          distanceFromRawValue((json['minDeviationDistance'] as num).toInt()),
      minDeviationTime: durationFromHalfNanoseconds(
          (json['minDeviationTime'] as num).toInt()),
    );

Map<String, dynamic> _$AlternativeRoutesOptionsToJson(
        AlternativeRoutesOptions instance) =>
    <String, dynamic>{
      'maxAlternatives': instance.maxAlternatives,
      'alternativeType': _$AlternativeTypeEnumMap[instance.alternativeType],
      'minDeviationDistance': instance.minDeviationDistance?.toJson(),
      'minDeviationTime': instance.minDeviationTime?.inMicroseconds,
    };

const _$AlternativeTypeEnumMap = {
  AlternativeType.anyRoute: 0,
  AlternativeType.betterRoute: 1,
};
