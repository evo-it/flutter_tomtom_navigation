
import 'flutter_tomtom_navigation_ios_platform_interface.dart';

class FlutterTomtomNavigationIos {
  Future<String?> getPlatformVersion() {
    return FlutterTomtomNavigationIosPlatform.instance.getPlatformVersion();
  }
}
