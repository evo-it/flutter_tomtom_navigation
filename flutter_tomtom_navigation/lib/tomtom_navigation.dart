import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation/routing.dart';
import 'package:flutter_tomtom_navigation/navigation.dart';

/// The TomtomNavigation widget, which is used to show a map
/// and navigation interface to the user,
/// and allows the user to navigate using TomToms native SDKs.
class TomtomNavigation extends StatelessWidget {
  const TomtomNavigation({required this.apiKey, this.debug = false, super.key});

  final String apiKey;
  final bool debug;

  @override
  Widget build(BuildContext context) {
    return FlutterTomtomNavigationPlatform.instance.buildView(apiKey, debug);
  }

  Future<void> planRoute(
      {required RoutePlanningOptions routePlanningOptions}) async {
    await FlutterTomtomNavigationPlatform.instance.planRoute(routePlanningOptions);
  }

  Future<void> startNavigation({bool useSimulation = true}) async {
    await FlutterTomtomNavigationPlatform.instance
        .startNavigation(useSimulation);
  }

  Future<void> stopNavigation() async {
    await FlutterTomtomNavigationPlatform.instance.stopNavigation();
  }

  void registerNavigationEventListener(
    void Function(dynamic) onNavigationEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerNavigationEventListener(onNavigationEvent);
  }

  void registerRouteEventListener(
    void Function(RouteProgress) onRouteEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerRouteEventListener(onRouteEvent);
  }

  void registerPlannedRouteEventListener(
    void Function(dynamic) onPlannedRouteEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerPlannedRouteEventListener(onPlannedRouteEvent);
  }

  void registerDestinationArrivalEventListener(
    void Function(dynamic) onDestinationArrivalEvent,
  ) {
    FlutterTomtomNavigationPlatform.instance
        .registerDestinationArrivalEventListener(onDestinationArrivalEvent);
  }
}
