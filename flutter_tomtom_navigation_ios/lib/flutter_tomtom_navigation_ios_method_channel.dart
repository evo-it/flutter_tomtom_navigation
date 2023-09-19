import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tomtom_navigation_ios_platform_interface.dart';

/// An implementation of [FlutterTomtomNavigationIosPlatform] that uses method channels.
class MethodChannelFlutterTomtomNavigationIos extends FlutterTomtomNavigationIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tomtom_navigation_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
