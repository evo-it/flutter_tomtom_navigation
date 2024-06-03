import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation_platform_interface/location/geo_location.dart';
import 'package:flutter_tomtom_navigation_platform_interface/maps/map_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/native_event.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/navigation_status.dart';
import 'package:flutter_tomtom_navigation_platform_interface/navigation/route_progress.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/summary.dart'
    as tt;

/// An implementation of [FlutterTomtomNavigationPlatform]
/// that uses method channels.
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
  ValueSetter<tt.Summary>? _onPlannedRouteEvent;
  ValueSetter<NavigationStatus>? _onNavigationEvent;
  ValueSetter<dynamic>? _onDestinationArrivalEvent;
  ValueSetter<GeoLocation>? _onLocationEvent;

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
  Future<void> startNavigation({required bool useSimulation}) async {
    await methodChannel.invokeMethod('startNavigation', {
      'useSimulation': useSimulation,
    });
  }

  @override
  Future<void> stopNavigation() async {
    await methodChannel.invokeMethod('stopNavigation');
  }

  // buildView should be overridden by each platform!
  // TODO(Frank): move this into the platform-specific platform interfaces...
  @override
  Widget buildView(MapOptions mapOptions, {required bool debug}) {
    // This is used in the platform side to register the view.
    const viewType = '<tomtom-navigation>';
    // Pass parameters to the platform side.
    final creationParams = <String, dynamic>{
      'mapOptions': jsonEncode(mapOptions),
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
  void registerRouteEventListener(
    ValueSetter<RouteProgress> listener,
  ) {
    _onRouteEvent = listener;
  }

  @override
  void registerPlannedRouteEventListener(ValueSetter<tt.Summary> listener) {
    _onPlannedRouteEvent = listener;
  }

  @override
  void registerNavigationEventListener(ValueSetter<NavigationStatus> listener) {
    _onNavigationEvent = listener;
  }

  @override
  void registerDestinationArrivalEventListener(ValueSetter<dynamic> listener) {
    _onDestinationArrivalEvent = listener;
  }

  @override
  void registerLocationEventListener(ValueSetter<GeoLocation> listener) {
    _onLocationEvent = listener;
  }

  NativeEvent _parseNativeEvent(String event) {
    final eventObject = NativeEvent.fromJson(event);
    return eventObject;
  }

  void _onProgressData(NativeEvent event) {
    // TODO(Matyas): Clean up to/from JSONs
    switch (event.nativeEventType) {
      case NativeEventType.routePlanned:
        _onPlannedRouteEvent?.call(
          tt.Summary.fromJson(jsonDecode(event.data) as Map<String, dynamic>),
        );
      case NativeEventType.routeUpdate:
        _onRouteEvent?.call(
          RouteProgress.fromJson(
            jsonDecode(event.data) as Map<String, dynamic>,
          ),
        );
      case NativeEventType.navigationUpdate:
        final statusInt = (jsonDecode(event.data)
            as Map<String, dynamic>)['navigationStatus'] as int;
        final status = NavigationStatus.values.firstWhere(
          (element) => element.value == statusInt,
          orElse: () => NavigationStatus.unknown,
        );
        _onNavigationEvent?.call(status);
      case NativeEventType.destinationArrival:
        _onDestinationArrivalEvent?.call(event.data);
      case NativeEventType.locationUpdate:
        _onLocationEvent?.call(
          GeoLocation.fromJson(jsonDecode(event.data) as Map<String, dynamic>),
        );
      case NativeEventType.unknown:
        if (kDebugMode) {
          print('Got unexpected stream event $event');
        }
    }
  }
}
