import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_method_channel.dart';
import 'package:flutter_tomtom_navigation_platform_interface/flutter_tomtom_navigation_platform_interface.dart';
import 'package:flutter_tomtom_navigation_platform_interface/maps/map_options.dart';

class FlutterTomtomNavigationAndroid
    extends MethodChannelFlutterTomtomNavigation {
  /// Registers this class as the default instance of [FlutterTomtomNavigationPlatform].
  static void registerWith() {
    FlutterTomtomNavigationPlatform.instance = FlutterTomtomNavigationAndroid();
  }

  @override
  Future<String?> getPlatformVersion() {
    return FlutterTomtomNavigationPlatform.instance.getPlatformVersion();
  }

  @override
  Widget buildView(MapOptions mapOptions, {required bool debug}) {
    // This is used in the platform side to register the view.
    const String viewType = '<tomtom-navigation>';
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
}
