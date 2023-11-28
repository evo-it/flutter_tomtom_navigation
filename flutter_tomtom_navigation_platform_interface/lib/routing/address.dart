// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/location/model/com.tomtom.sdk.location/-address/index.html

import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';


@JsonSerializable(explicitToJson: true)
class Address {
	const Address({
		required this.streetNumber,/// Default value String = "",
		required this.streetName,/// Default value String = "",
		required this.municipalitySubdivision,/// Default value String = "",
		required this.municipality,/// Default value String = "",
		required this.countrySecondarySubdivision,/// Default value String = "",
		required this.countryTertiarySubdivision,/// Default value String = "",
		required this.countrySubdivision,/// Default value String = "",
		required this.postalCode,/// Default value String = "",
		required this.extendedPostalCode,/// Default value String = "",
		required this.countryCode,/// Default value String = "",
		required this.country,/// Default value String = "",
		required this.countryCodeIso3,/// Default value String = "",
		required this.freeformAddress,/// Default value String = "",
		required this.countrySubdivisionName,/// Default value String = "",
		required this.localName,/// Default value String = "",
		required this.streetNameAndNumber,/// Default value String = "",
		required this.postalName,/// Default value String = "",
		required this.countrySubdivisionCode,/// Default value String = "",
		required this.neighborhoodName,/// Default value String = "",
	}); 
 
	 final String country;
	 final String countryCode;
	 final String countryCodeIso3;
	 final String countrySecondarySubdivision;
	 final String countrySubdivision;
	 final String countrySubdivisionCode;
	 final String countrySubdivisionName;
	 final String countryTertiarySubdivision;
	 final String extendedPostalCode;
	 final String freeformAddress;
	 final String localName;
	 final String municipality;
	 final String municipalitySubdivision;
	 final String neighborhoodName;
	 final String postalCode;
	 final String postalName;
	 final String streetName;
	 final String streetNameAndNumber;
	 final String streetNumber;

	Map<String, dynamic> toJson() => _$AddressToJson(this);

	factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}