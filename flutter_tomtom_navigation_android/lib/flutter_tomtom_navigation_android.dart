import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';

class FlutterTomtomNavigationAndroid extends FlutterTomtomNavigationPlatform {
  @override
  Future<String?> getPlatformVersion() {
    return FlutterTomtomNavigationPlatform.instance.getPlatformVersion();
  }
}
