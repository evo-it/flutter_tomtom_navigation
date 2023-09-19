import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tomtom_navigation_ios_method_channel.dart';

abstract class FlutterTomtomNavigationIosPlatform extends PlatformInterface {
  /// Constructs a FlutterTomtomNavigationIosPlatform.
  FlutterTomtomNavigationIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTomtomNavigationIosPlatform _instance = MethodChannelFlutterTomtomNavigationIos();

  /// The default instance of [FlutterTomtomNavigationIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTomtomNavigationIos].
  static FlutterTomtomNavigationIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTomtomNavigationIosPlatform] when
  /// they register themselves.
  static set instance(FlutterTomtomNavigationIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
