import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';

class TomtomNavigation extends StatefulWidget {
  const TomtomNavigation({super.key});

  @override
  State<TomtomNavigation> createState() => _TomtomNavigationState();
}

class _TomtomNavigationState extends State<TomtomNavigation> {
  @override
  Widget build(BuildContext context) {
    return FlutterTomtomNavigationPlatform.instance.buildView();
  }
}
