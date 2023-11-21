import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation/routing.dart';
import 'package:flutter_tomtom_navigation/vehicle.dart';
import 'package:flutter_tomtom_navigation/tomtom_navigation.dart';

// Get the API key from the environment
const apiKey = String.fromEnvironment(
  'apiKey',
  defaultValue: '<fallback-tomtom-api-key>',
);

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
      setState(() => eta = DateTime.now().add(value.remainingTime));
    });
    nav.registerDestinationArrivalEventListener((value) {
      if (kDebugMode) {
        print('Destination reached!');
      }
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
      // vehicleType: VehicleType.truck,
      // vehicleDimensions: VehicleDimensions(
      //   height: Distance.meters(3.5),
      //   width: Distance.meters(2.5),
      //   length: Distance.meters(12),
      //   axleWeight: Weight.metricTons(6),
      //   weight: Weight.metricTons(6),
      //   numberOfAxles: 3,
      // ),
      vehicle: const Truck(),
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
