import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tomtom_navigation_method_channel.dart';

abstract class FlutterTomtomNavigationPlatform extends PlatformInterface {
  /// Constructs a FlutterTomtomNavigationPlatform.
  FlutterTomtomNavigationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTomtomNavigationPlatform _instance =
      MethodChannelFlutterTomtomNavigation();

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

  /// Build the TomtomNavigationView.
  Widget buildView(String apiKey) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  /// Plan a route, given the provided RoutePlanningOptions.
  Future<void> planRoute(RoutePlanningOptions options) {
    throw UnimplementedError('planRoute() has not been implemented.');
  }

  /// Start navigating. Depending on [useSimulation] a MapMatched or simulated location provider is used.
  Future<void> startNavigation(bool useSimulation) {
    throw UnimplementedError('startNavigation() has not been implemented.');
  }

  Future<void> stopNavigation() {
    throw UnimplementedError('stopNavigation() has not been implemented.');
  }

  Future<dynamic> registerRouteEventListener(
      ValueSetter<dynamic> listener) {
    throw UnimplementedError(
        'registerRouteEventListener() has not been implemented.');
  }

  Future<dynamic> registerPlannedRouteEventListener(
      ValueSetter<dynamic> listener) {
    throw UnimplementedError(
        'registerPlannedRouteEventListener() has not been implemented.');
  }

  Future<dynamic> registerNavigationEventListener(
      ValueSetter<dynamic> listener) {
    throw UnimplementedError(
        'registerNavigationEventListener() has not been implemented.');
  }
}
