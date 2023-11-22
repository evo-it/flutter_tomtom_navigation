import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation_platform_interface/native_event.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/route_progress.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';

/// An implementation of [FlutterTomtomNavigationPlatform] that uses method channels.
class MethodChannelFlutterTomtomNavigation
    extends FlutterTomtomNavigationPlatform {
  MethodChannelFlutterTomtomNavigation() {
    nativeEventsListener!.listen(_onProgressData);
  }

  /// The method and event channels used to interact with the native platform.
  final methodChannel = const MethodChannel('flutter_tomtom_navigation');
  final eventChannel = const EventChannel('flutter_tomtom_navigation/updates');

  // Callbacks to the client
  ValueSetter<RouteProgress>? _onRouteEvent;
  ValueSetter<dynamic>? _onPlannedRouteEvent;
  ValueSetter<dynamic>? _onNavigationEvent;
  ValueSetter<dynamic>? _onDestinationArrivalEvent;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> planRoute(RoutePlanningOptions options) async {
    await methodChannel.invokeMethod('planRoute', jsonEncode(options));
  }

  @override
  Future<void> startNavigation(bool useSimulation) async {
    await methodChannel.invokeMethod('startNavigation', {
      'useSimulation': useSimulation,
    });
  }

  @override
  Future<void> stopNavigation() async {
    await methodChannel.invokeMethod('stopNavigation');
  }

  // buildView should be overridden by each platform!
  // TODO move this into the platform-specific platform interfaces...
  @override
  Widget buildView(String apiKey, bool debug) {
    // This is used in the platform side to register the view.
    const String viewType = '<tomtom-navigation>';
    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{
      'apiKey': apiKey,
      'debug': debug,
    };

    return PlatformViewLink(
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initExpensiveAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
      viewType: viewType,
    );
  }

  Stream<NativeEvent>? get nativeEventsListener {
    return eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => _parseNativeEvent(event as String));
  }

  @override
  void registerRouteEventListener(ValueSetter<RouteProgress> listener) async {
    _onRouteEvent = listener;
  }

  @override
  void registerPlannedRouteEventListener(ValueSetter<dynamic> listener) {
    _onPlannedRouteEvent = listener;
  }

  @override
  void registerNavigationEventListener(ValueSetter<dynamic> listener) {
    _onNavigationEvent = listener;
  }

  @override
  void registerDestinationArrivalEventListener(ValueSetter<dynamic> listener) {
    _onDestinationArrivalEvent = listener;
  }

  NativeEvent _parseNativeEvent(String event) {
    final eventObject = NativeEvent.fromJson(event);
    return eventObject;
  }

  _onProgressData(NativeEvent event) {
    //TODO(Matyas): Clean up to/from JSONs
    switch (event.nativeEventType) {
      case NativeEventType.routePlanned:
        _onPlannedRouteEvent?.call(event.data);
      case NativeEventType.routeUpdate:
        _onRouteEvent?.call(RouteProgress.fromJson(jsonDecode(event.data)));
      case NativeEventType.navigationUpdate:
        final statusInt = jsonDecode(event.data)['navigationStatus'] as int;
        _onNavigationEvent?.call(statusInt);
      case NativeEventType.destinationArrival:
        _onDestinationArrivalEvent?.call(event.data);
      case NativeEventType.unknown:
        print("Got unexpected stream event $event");
    }
  }
}
