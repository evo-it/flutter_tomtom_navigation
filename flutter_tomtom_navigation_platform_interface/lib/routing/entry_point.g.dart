// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntryPoint _$EntryPointFromJson(Map<String, dynamic> json) => EntryPoint(
      type: $enumDecode(_$EntryTypeEnumMap, json['type']),
      position: GeoPoint.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntryPointToJson(EntryPoint instance) =>
    <String, dynamic>{
      'position': instance.position.toJson(),
      'type': _$EntryTypeEnumMap[instance.type]!,
    };

const _$EntryTypeEnumMap = {
  EntryType.main: 0,
  EntryType.minor: 1,
};
