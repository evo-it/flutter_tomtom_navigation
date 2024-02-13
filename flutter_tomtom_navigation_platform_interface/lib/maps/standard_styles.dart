// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.44.0/maps/display-api/com.tomtom.sdk.map.display.style/-standard-styles/index.html

import 'package:flutter_tomtom_navigation_platform_interface/maps/style_descriptor.dart';

class StandardStyles {
  static final browsing = StyleDescriptor(
    uri: Uri.parse('tomtom://styles/standard/browsing'),
    darkUri: Uri.parse('tomtom://styles/standard/browsingDark'),
  );

  static final driving = StyleDescriptor(
    uri: Uri.parse('tomtom://styles/standard/driving'),
    darkUri: Uri.parse('tomtom://styles/standard/drivingDark'),
  );

  static final satellite = StyleDescriptor(
    uri: Uri.parse('tomtom://styles/standard/satellite'),
    layerMappingUri: Uri.parse('tomtom://styles/standard/satellite'),
  );

  static final vehicleRestrictions = StyleDescriptor(
    uri: Uri.parse('tomtom://styles/standard/vehicleRestriction'),
    darkUri: Uri.parse('tomtom://styles/standard/vehicleRestrictionDark'),
  );
}
