import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation/flutter_tomtom_navigation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Get the API key from the environment
/// Which is set by adding --dart-define apiKey=<tomtom-api-key> to your
/// Dart run command
const apiKey = String.fromEnvironment(
  'apiKey',
  defaultValue: 'nAGM7dRzTVKuCU2Eu3FpeaSJLa1bpSjq',
);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: 'TomTom Navigation',
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
    ),
  );
}

/// Example app for Tomtom Navigation in Flutter.
class MyApp extends StatefulWidget {
  /// Create a new app.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nav = const TomtomNavigation(
    mapOptions: MapOptions(
      mapKey: apiKey,
      cameraOptions: CameraOptions(
        position: GeoPoint(latitude: 52.1, longitude: 5.3),
        zoom: 6,
      ),
    ),
    debug: true,
    initialSoundEnabled: true,
  );
  DateTime? eta;

  @override
  void initState() {
    super.initState();

    // Request permission location
    Permission.location.request();

    // Add listeners to the navigation view.
    nav
      ..registerRouteEventListener((routeProgress) {
        // Calculating eta for the next destination
        final lastStopEta =
            routeProgress.remainingRouteStopsProgress.last.remainingTime;

        setState(() => eta = DateTime.now().add(lastStopEta));
      })
      ..registerDestinationArrivalEventListener((value) {
        if (kDebugMode) {
          print('Destination reached!');
        }
      })
      ..registerLocationEventListener((location) {
        // Do something when a new location is received
      });
  }

  @override
  Widget build(BuildContext context) {
    final routePlanningOptions = RoutePlanningOptions(
      alternativeRoutesOptions: AlternativeRoutesOptions(
        maxAlternatives: 2,
      ),
      costModel: const CostModel(
        routeType: RouteType.short,
        considerTraffic: ConsiderTraffic.no,
        avoidOptions: AvoidOptions(
          avoidTypes: {
            AvoidType.lowEmissionZones,
            AvoidType.motorways,
          },
        ),
      ),
      itinerary: Itinerary(
        origin: ItineraryPoint(
          place: const Place(
            // coordinate: GeoPoint(latitude: 51.984956, longitude: 4.344450),
            coordinate: GeoPoint.currentLocation,
          ),
        ),
        destination: ItineraryPoint(
          place: const Place(
            coordinate: GeoPoint(latitude: 51.984213, longitude: 4.328665),
          ),
        ),
      ),
      vehicle: Truck(
        maxSpeed: Speed.kilometersPerHour(80),
        dimensions: VehicleDimensions(
          height: Distance.meters(3.5),
          width: Distance.meters(2.5),
          length: Distance.meters(12),
          axleWeight: Weight.metricTons(4),
          weight: Weight.metricTons(12),
          numberOfAxles: 3,
        ),
        // adrTunnelRestrictionCode: AdrTunnelRestrictionCode.C,
        // hazmatClasses: {
        //   HazmatClass.intlExplosive,
        //   HazmatClass.unClass2Gas,
        //   HazmatClass.intlHarmfulToWater,
        // },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: nav),
            if (eta != null) Text('ETA: $eta'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) =>
                          Column(children: [Expanded(child: nav)]),
                    ),
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
                    onPressed: nav.stopNavigation,
                    child: const Text('Stop Navigation'),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
