import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation/location.dart';
import 'package:flutter_tomtom_navigation/maps.dart';
import 'package:flutter_tomtom_navigation/navigation.dart';
import 'package:flutter_tomtom_navigation/routing.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';

/// The TomtomNavigation widget, which is used to show a map
/// and navigation interface to the user,
/// and allows the user to navigate using TomToms native SDKs.
class TomtomNavigation extends StatelessWidget {
  /// Create a new TomTom navigation Widget.
  const TomtomNavigation({
    required this.mapOptions,
    this.debug = false,
    super.key,
  });

  /// The mapOptions used to create and configure the initial map.
  final MapOptions mapOptions;

  /// Are we debugging? If so, you can tap and hold the map to quickly plan
  /// a route and tap this route to start basic simulated navigation.
  final bool debug;

  @override
  Widget build(BuildContext context) {
    return FlutterTomtomNavigationPlatform.instance
        .buildView(mapOptions, debug: debug);
  }

  /// Synchronously plans a route
  /// using the provided [RoutePlanningOptions] object.
  Future<void> planRoute({
    required RoutePlanningOptions routePlanningOptions,
  }) async {
    await FlutterTomtomNavigationPlatform.instance
        .planRoute(routePlanningOptions);
  }

  /// Starts navigation with provided RoutePlan.
  Future<void> startNavigation({bool? useSimulation}) async {
    await FlutterTomtomNavigationPlatform.instance
        .startNavigation(useSimulation: useSimulation ?? debug);
  }

  /// Stops the navigation.
  Future<void> stopNavigation() async {
    await FlutterTomtomNavigationPlatform.instance.stopNavigation();
  }

  /// Listen to events about the lifecycle of this [TomtomNavigation] Widget.
  void registerNavigationEventListener(
    void Function(NavigationStatus) onNavigationEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerNavigationEventListener(onNavigationEvent);
  }

  /// Used to inform caller about progress on Route.
  void registerRouteEventListener(
    void Function(RouteProgress) onRouteEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerRouteEventListener(onRouteEvent);
  }

  /// Called when each route is successfully calculated.
  void registerPlannedRouteEventListener(
    void Function(Summary) onPlannedRouteEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerPlannedRouteEventListener(onPlannedRouteEvent);
  }

  /// Called when destination arrival is detected by the ArrivalDetectionEngine.
  void registerDestinationArrivalEventListener(
    void Function(dynamic) onDestinationArrivalEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerDestinationArrivalEventListener(onDestinationArrivalEvent);
  }

  /// Triggered when new [GeoLocation] has been received from LocationProvider.
  void registerLocationEventListener(
    void Function(GeoLocation) onLocationEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerLocationEventListener(onLocationEvent);
  }
}
