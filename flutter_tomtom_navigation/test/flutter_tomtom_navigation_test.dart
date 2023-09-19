import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tomtom_navigation/flutter_tomtom_navigation.dart';
import 'package:flutter_tomtom_navigation/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation/flutter_tomtom_navigation_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTomtomNavigationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTomtomNavigationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTomtomNavigationPlatform initialPlatform = FlutterTomtomNavigationPlatform.instance;

  test('$MethodChannelFlutterTomtomNavigation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTomtomNavigation>());
  });

  test('getPlatformVersion', () async {
    FlutterTomtomNavigation flutterTomtomNavigationPlugin = FlutterTomtomNavigation();
    MockFlutterTomtomNavigationPlatform fakePlatform = MockFlutterTomtomNavigationPlatform();
    FlutterTomtomNavigationPlatform.instance = fakePlatform;

    expect(await flutterTomtomNavigationPlugin.getPlatformVersion(), '42');
  });
}
