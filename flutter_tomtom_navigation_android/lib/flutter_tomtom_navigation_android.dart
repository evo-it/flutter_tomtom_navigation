import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface%20copy.dart';

class FlutterTomtomNavigationAndroid {
  Future<String?> getPlatformVersion() {
    return FlutterTomtomNavigationPlatform.instance.getPlatformVersion();
  }
}
