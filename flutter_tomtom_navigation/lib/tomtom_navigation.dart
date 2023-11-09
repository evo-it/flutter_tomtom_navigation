import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';

/// The TomtomNavigation widget, which is used to show a map
/// and navigation interface to the user,
/// and allows the user to navigate using TomToms native SDKs.
class TomtomNavigation extends StatefulWidget {
  const TomtomNavigation({required this.apiKey, super.key});

  final String apiKey;

  @override
  State<TomtomNavigation> createState() => _TomtomNavigationState();
}

class _TomtomNavigationState extends State<TomtomNavigation> {
  @override
  Widget build(BuildContext context) {
    return FlutterTomtomNavigationPlatform.instance.buildView(widget.apiKey);
  }
}
