import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tomtom_navigation_android_method_channel.dart';

abstract class FlutterTomtomNavigationAndroidPlatform extends PlatformInterface {
  /// Constructs a FlutterTomtomNavigationAndroidPlatform.
  FlutterTomtomNavigationAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTomtomNavigationAndroidPlatform _instance = MethodChannelFlutterTomtomNavigationAndroid();

  /// The default instance of [FlutterTomtomNavigationAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTomtomNavigationAndroid].
  static FlutterTomtomNavigationAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTomtomNavigationAndroidPlatform] when
  /// they register themselves.
  static set instance(FlutterTomtomNavigationAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
