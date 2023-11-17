import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation/tomtom_navigation.dart';
import 'package:flutter_tomtom_navigation/route_planning_options.dart';

// Get the API key from the environment
const apiKey = String.fromEnvironment('apiKey',
    defaultValue: 'SU9NKKWKyEVmZpuJ1gDrETFXLtWGdWzA');

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    title: 'TomTom Navigation',
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nav = const TomtomNavigation(apiKey: apiKey, debug: true);
  DateTime? eta;

  @override
  void initState() {
    super.initState();
    nav.registerRouteEventListener((value) {
      // It's currently a JSON String, get the desired value from it
      final map = jsonDecode(value) as Map;
      final remainingHalfNanos = map["remainingTime"];
      if (remainingHalfNanos is int) {
        // Duration from Kotlin is sent in half-nanoseconds
        final dt = DateTime.now().add(
            Duration(microseconds: (remainingHalfNanos / 1000 / 2).round()));
        setState(() => eta = dt);
      }
    });
    nav.registerDestinationArrivalEventListener((value) {
      print('Destination reached!');
    });
  }

  @override
  Widget build(BuildContext context) {
    final routePlanningOptions = RoutePlanningOptions(
      destination: ItineraryPoint(
        place: Place(
          coordinate: GeoPoint(latitude: 52.011747, longitude: 4.359328),
        ),
      ),
      vehicleType: VehicleType.truck,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            if (eta != null) Text('ETA: $eta'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            Column(children: [Expanded(child: nav)])),
                    child: const Text('Open map in dialog'),
                  ),
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => nav.planRoute(
                      routePlanningOptions: routePlanningOptions,
                    ),
                    child: const Text('Plan route'),
                  ),
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => nav.startNavigation(useSimulation: true),
                    child: const Text('Start Navigation (sim)'),
                  ),
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => nav.startNavigation(useSimulation: false),
                    child: const Text('Start Navigation (real)'),
                  ),
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => nav.stopNavigation(),
                    child: const Text('Stop Navigation'),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            Expanded(child: nav),
          ],
        ),
      ),
    );
  }
}
