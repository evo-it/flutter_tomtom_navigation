import 'package:flutter/material.dart';
import 'package:flutter_tomtom_navigation/tomtom_navigation.dart';

// Get the API key from the environment
const apiKey = String.fromEnvironment('apiKey');

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
  @override
  Widget build(BuildContext context) {
    final mapKey =
        apiKey.isNotEmpty ? apiKey : 'SU9NKKWKyEVmZpuJ1gDrETFXLtWGdWzA';
    final nav = TomtomNavigation(apiKey: mapKey);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
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
                    onPressed: () =>
                        nav.planRoute(latitude: 52.014609, longitude: 4.442599),
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
