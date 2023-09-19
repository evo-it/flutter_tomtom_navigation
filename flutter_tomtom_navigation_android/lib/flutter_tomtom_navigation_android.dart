
import 'flutter_tomtom_navigation_android_platform_interface.dart';

class FlutterTomtomNavigationAndroid {
  Future<String?> getPlatformVersion() {
    return FlutterTomtomNavigationAndroidPlatform.instance.getPlatformVersion();
  }
}
