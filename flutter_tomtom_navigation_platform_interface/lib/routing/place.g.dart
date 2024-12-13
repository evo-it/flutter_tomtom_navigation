// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      coordinate: GeoPoint.fromJson(json['coordinate'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      entryPoints: (json['entryPoints'] as List<dynamic>?)
              ?.map((e) => EntryPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'address': instance.address?.toJson(),
      'coordinate': instance.coordinate.toJson(),
      'entryPoints': instance.entryPoints.map((e) => e.toJson()).toList(),
      'name': instance.name,
      '_types': instance._types.map((e) => _$TypeEnumMap[e]!).toList(),
    };

const _$TypeEnumMap = {
  Type.bookmarkHome: 0,
  Type.bookmarkWork: 1,
  Type.bookmarkFavorite: 2,
  Type.recent: 3,
};
