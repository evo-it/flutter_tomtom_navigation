// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapOptions _$MapOptionsFromJson(Map<String, dynamic> json) => MapOptions(
      mapKey: json['mapKey'] as String,
      cameraOptions: json['cameraOptions'] == null
          ? null
          : CameraOptions.fromJson(
              json['cameraOptions'] as Map<String, dynamic>),
      padding: json['padding'] == null
          ? const Padding()
          : Padding.fromJson(json['padding'] as Map<String, dynamic>),
      mapStyle: json['mapStyle'] == null
          ? null
          : StyleDescriptor.fromJson(json['mapStyle'] as Map<String, dynamic>),
      styleMode: $enumDecodeNullable(_$StyleModeEnumMap, json['styleMode']) ??
          StyleMode.main,
      renderToTexture: json['renderToTexture'] as bool? ?? false,
    );

Map<String, dynamic> _$MapOptionsToJson(MapOptions instance) =>
    <String, dynamic>{
      'cameraOptions': instance.cameraOptions?.toJson(),
      'mapKey': instance.mapKey,
      'mapStyle': instance.mapStyle?.toJson(),
      'padding': instance.padding.toJson(),
      'renderToTexture': instance.renderToTexture,
      'styleMode': _$StyleModeEnumMap[instance.styleMode]!,
    };

const _$StyleModeEnumMap = {
  StyleMode.main: 'MAIN',
  StyleMode.dark: 'DARK',
};
