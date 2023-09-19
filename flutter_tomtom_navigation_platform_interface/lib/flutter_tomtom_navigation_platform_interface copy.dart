
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tomtom_navigation_method_channel.dart';

abstract class FlutterTomtomNavigationPlatform extends PlatformInterface {
  /// Constructs a FlutterTomtomNavigationPlatform.
  FlutterTomtomNavigationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTomtomNavigationPlatform _instance = MethodChannelFlutterTomtomNavigation();

  /// The default instance of [FlutterTomtomNavigationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTomtomNavigation].
  static FlutterTomtomNavigationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTomtomNavigationPlatform] when
  /// they register themselves.
  static set instance(FlutterTomtomNavigationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
