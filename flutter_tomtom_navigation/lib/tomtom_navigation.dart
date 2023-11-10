import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_android/flutter_tomtom_navigation_android.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';

/// The TomtomNavigation widget, which is used to show a map
/// and navigation interface to the user,
/// and allows the user to navigate using TomToms native SDKs.
class TomtomNavigation extends StatelessWidget {
  const TomtomNavigation({required this.apiKey, super.key});

  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return FlutterTomtomNavigationPlatform.instance.buildView(apiKey);
  }

  Future<void> planRoute(
      {required double latitude, required double longitude}) async {
    await FlutterTomtomNavigationPlatform.instance.planRoute(
      RoutePlanningOptions(GeoPoint(latitude, longitude)),
    );
  }

  Future<void> startNavigation({bool useSimulation = true}) async {
    await FlutterTomtomNavigationPlatform.instance
        .startNavigation(useSimulation);
  }

  Future<void> stopNavigation() async {
    await FlutterTomtomNavigationPlatform.instance.stopNavigation();
  }
}
