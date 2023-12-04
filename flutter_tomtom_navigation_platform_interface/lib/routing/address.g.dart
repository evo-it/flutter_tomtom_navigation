// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      streetNumber: json['streetNumber'] as String,
      streetName: json['streetName'] as String,
      municipalitySubdivision: json['municipalitySubdivision'] as String,
      municipality: json['municipality'] as String,
      countrySecondarySubdivision:
          json['countrySecondarySubdivision'] as String,
      countryTertiarySubdivision: json['countryTertiarySubdivision'] as String,
      countrySubdivision: json['countrySubdivision'] as String,
      postalCode: json['postalCode'] as String,
      extendedPostalCode: json['extendedPostalCode'] as String,
      countryCode: json['countryCode'] as String,
      country: json['country'] as String,
      countryCodeIso3: json['countryCodeIso3'] as String,
      freeformAddress: json['freeformAddress'] as String,
      countrySubdivisionName: json['countrySubdivisionName'] as String,
      localName: json['localName'] as String,
      streetNameAndNumber: json['streetNameAndNumber'] as String,
      postalName: json['postalName'] as String,
      countrySubdivisionCode: json['countrySubdivisionCode'] as String,
      neighborhoodName: json['neighborhoodName'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'country': instance.country,
      'countryCode': instance.countryCode,
      'countryCodeIso3': instance.countryCodeIso3,
      'countrySecondarySubdivision': instance.countrySecondarySubdivision,
      'countrySubdivision': instance.countrySubdivision,
      'countrySubdivisionCode': instance.countrySubdivisionCode,
      'countrySubdivisionName': instance.countrySubdivisionName,
      'countryTertiarySubdivision': instance.countryTertiarySubdivision,
      'extendedPostalCode': instance.extendedPostalCode,
      'freeformAddress': instance.freeformAddress,
      'localName': instance.localName,
      'municipality': instance.municipality,
      'municipalitySubdivision': instance.municipalitySubdivision,
      'neighborhoodName': instance.neighborhoodName,
      'postalCode': instance.postalCode,
      'postalName': instance.postalName,
      'streetName': instance.streetName,
      'streetNameAndNumber': instance.streetNameAndNumber,
      'streetNumber': instance.streetNumber,
    };
