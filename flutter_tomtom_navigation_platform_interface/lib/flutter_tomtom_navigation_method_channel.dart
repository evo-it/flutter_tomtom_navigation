import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation_platform_interface/routing/route_planning_options.dart';

/// An implementation of [FlutterTomtomNavigationPlatform] that uses method channels.
class MethodChannelFlutterTomtomNavigation
    extends FlutterTomtomNavigationPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('flutter_tomtom_navigation');
  final eventChannel = const EventChannel('flutter_tomtom_navigation');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // buildView should be overridden by each platform!

  @override
  Future<void> planRoute(RoutePlanningOptions options) async {
    await methodChannel.invokeMethod('planRoute', {
      'latitude': options.destination.latitude,
      'longitude': options.destination.longitude,
    });
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

  // TODO move this into the platform-specific platform interfaces...
  @override
  Widget buildView(String apiKey) {
    // This is used in the platform side to register the view.
    const String viewType = '<tomtom-navigation>';
    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{
      'apiKey': apiKey,
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
}
