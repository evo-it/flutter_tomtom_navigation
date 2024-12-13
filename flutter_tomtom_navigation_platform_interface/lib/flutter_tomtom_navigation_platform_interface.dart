import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_method_channel.dart';
import 'package:flutter_tomtom_navigation_platform_interface/location/geo_location.dart';
import 'package:flutter_tomtom_navigation_platform_interface/maps/map_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/navigation_status.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/route_progress.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/summary.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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
  /// platform-specific class that extends [FlutterTomtomNavigationPlatform]
  /// when they register themselves.
  static set instance(FlutterTomtomNavigationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Build the TomtomNavigationView.
  Widget buildView(MapOptions mapOptions, {required bool debug, required bool initialSoundEnabled}) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  /// Plan a route, given the provided RoutePlanningOptions.
  Future<void> planRoute(RoutePlanningOptions options) {
    throw UnimplementedError('planRoute() has not been implemented.');
  }

  /// Start navigating. Depending on [useSimulation] a MapMatched
  /// or simulated location provider is used.
  Future<void> startNavigation({required bool useSimulation}) {
    throw UnimplementedError('startNavigation() has not been implemented.');
  }

  Future<void> stopNavigation() {
    throw UnimplementedError('stopNavigation() has not been implemented.');
  }

  void registerRouteEventListener(ValueSetter<RouteProgress> listener) {
    throw UnimplementedError(
      'registerRouteEventListener() has not been implemented.',
    );
  }

  void registerPlannedRouteEventListener(ValueSetter<Summary> listener) {
    throw UnimplementedError(
      'registerPlannedRouteEventListener() has not been implemented.',
    );
  }

  void registerNavigationEventListener(ValueSetter<NavigationStatus> listener) {
    throw UnimplementedError(
      'registerNavigationEventListener() has not been implemented.',
    );
  }

  void registerDestinationArrivalEventListener(ValueSetter<dynamic> listener) {
    throw UnimplementedError(
      'registerDestinationArrivalEventListener() has not been implemented.',
    );
  }

  void registerLocationEventListener(ValueSetter<GeoLocation> listener) {
    throw UnimplementedError(
      'registerLocationEventListener() has not been implemented.',
    );
  }
}
