// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StyleDescriptor _$StyleDescriptorFromJson(Map<String, dynamic> json) =>
    StyleDescriptor(
      uri: Uri.parse(json['uri'] as String),
      darkUri:
          json['darkUri'] == null ? null : Uri.parse(json['darkUri'] as String),
      layerMappingUri: json['layerMappingUri'] == null
          ? null
          : Uri.parse(json['layerMappingUri'] as String),
      darkLayerMappingUri: json['darkLayerMappingUri'] == null
          ? null
          : Uri.parse(json['darkLayerMappingUri'] as String),
    );

Map<String, dynamic> _$StyleDescriptorToJson(StyleDescriptor instance) =>
    <String, dynamic>{
      'darkLayerMappingUri': instance.darkLayerMappingUri?.toString(),
      'darkUri': instance.darkUri?.toString(),
      'layerMappingUri': instance.layerMappingUri?.toString(),
      'uri': instance.uri.toString(),
    };
