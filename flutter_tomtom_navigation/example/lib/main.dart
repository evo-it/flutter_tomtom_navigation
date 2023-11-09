import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation/flutter_tomtom_navigation.dart';
import 'package:flutter_tomtom_navigation/tomtom_navigation.dart';

// Get the API key from the environment
const apiKey = String.fromEnvironment('apiKey');

void main() {
  runApp(const MaterialApp(
    title: 'TomTom Navigation',
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterTomtomNavigationPlugin = FlutterTomtomNavigation();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterTomtomNavigationPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapKey = apiKey.isNotEmpty ? apiKey : 'SU9NKKWKyEVmZpuJ1gDrETFXLtWGdWzA';
    final nav = Expanded(child: TomtomNavigation(apiKey: mapKey));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Column(children: [nav])),
              child: const Text('Open map in dialog'),
            ),
            nav,
            Text('Running on: $_platformVersion\n'),
          ],
        ),
      ),
    ) ;
  }
}
