// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'padding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Padding _$PaddingFromJson(Map<String, dynamic> json) => Padding._(
      (json['top'] as num).toInt(),
      (json['left'] as num).toInt(),
      (json['right'] as num).toInt(),
      (json['bottom'] as num).toInt(),
    );

Map<String, dynamic> _$PaddingToJson(Padding instance) => <String, dynamic>{
      'bottom': instance.bottom,
      'left': instance.left,
      'right': instance.right,
      'top': instance.top,
    };
