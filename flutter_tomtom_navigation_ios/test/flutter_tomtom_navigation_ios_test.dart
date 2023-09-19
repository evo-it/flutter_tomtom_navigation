import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tomtom_navigation_ios/flutter_tomtom_navigation_ios.dart';
import 'package:flutter_tomtom_navigation_ios/flutter_tomtom_navigation_ios_platform_interface.dart';
import 'package:flutter_tomtom_navigation_ios/flutter_tomtom_navigation_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTomtomNavigationIosPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTomtomNavigationIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTomtomNavigationIosPlatform initialPlatform = FlutterTomtomNavigationIosPlatform.instance;

  test('$MethodChannelFlutterTomtomNavigationIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTomtomNavigationIos>());
  });

  test('getPlatformVersion', () async {
    FlutterTomtomNavigationIos flutterTomtomNavigationIosPlugin = FlutterTomtomNavigationIos();
    MockFlutterTomtomNavigationIosPlatform fakePlatform = MockFlutterTomtomNavigationIosPlatform();
    FlutterTomtomNavigationIosPlatform.instance = fakePlatform;

    expect(await flutterTomtomNavigationIosPlugin.getPlatformVersion(), '42');
  });
}
