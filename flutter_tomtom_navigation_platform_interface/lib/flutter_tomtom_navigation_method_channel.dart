import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface%20copy.dart';

/// An implementation of [FlutterTomtomNavigationPlatform] that uses method channels.
class MethodChannelFlutterTomtomNavigation
    extends FlutterTomtomNavigationPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('flutter_tomtom_navigation');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
