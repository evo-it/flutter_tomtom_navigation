// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostModel _$CostModelFromJson(Map<String, dynamic> json) => CostModel(
      routeType: $enumDecodeNullable(_$RouteTypeEnumMap, json['routeType']) ??
          RouteType.fast,
      considerTraffic: $enumDecodeNullable(
              _$ConsiderTrafficEnumMap, json['considerTraffic']) ??
          ConsiderTraffic.yes,
      avoidOptions: json['avoidOptions'] == null
          ? null
          : AvoidOptions.fromJson(json['avoidOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CostModelToJson(CostModel instance) => <String, dynamic>{
      'avoidOptions': instance.avoidOptions?.toJson(),
      'considerTraffic': _$ConsiderTrafficEnumMap[instance.considerTraffic]!,
      'routeType': _$RouteTypeEnumMap[instance.routeType]!,
    };

const _$RouteTypeEnumMap = {
  RouteType.fast: 'Fast',
  RouteType.short: 'Short',
  RouteType.efficient: 'Efficient',
  RouteType.thrilling: 'Thrilling',
};

const _$ConsiderTrafficEnumMap = {
  ConsiderTraffic.yes: 0,
  ConsiderTraffic.no: 1,
};
