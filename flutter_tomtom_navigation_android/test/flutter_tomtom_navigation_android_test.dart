import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tomtom_navigation_android/flutter_tomtom_navigation_android.dart';
import 'package:flutter_tomtom_navigation_android/flutter_tomtom_navigation_android_platform_interface.dart';
import 'package:flutter_tomtom_navigation_android/flutter_tomtom_navigation_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTomtomNavigationAndroidPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTomtomNavigationAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTomtomNavigationAndroidPlatform initialPlatform = FlutterTomtomNavigationAndroidPlatform.instance;

  test('$MethodChannelFlutterTomtomNavigationAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTomtomNavigationAndroid>());
  });

  test('getPlatformVersion', () async {
    FlutterTomtomNavigationAndroid flutterTomtomNavigationAndroidPlugin = FlutterTomtomNavigationAndroid();
    MockFlutterTomtomNavigationAndroidPlatform fakePlatform = MockFlutterTomtomNavigationAndroidPlatform();
    FlutterTomtomNavigationAndroidPlatform.instance = fakePlatform;

    expect(await flutterTomtomNavigationAndroidPlugin.getPlatformVersion(), '42');
  });
}
