package com.tomtom.flutter_tomtom_navigation_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterTomtomNavigationAndroidPlugin */
class FlutterTomtomNavigationAndroidPlugin: FlutterPlugin, StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
//  private lateinit var channel : MethodChannel
  private lateinit var channel: EventChannel
  private var eventSink: EventSink? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_tomtom_navigation/updates")
    channel.setStreamHandler(this)

    // Register the Flutter TomTom Navigation View
    flutterPluginBinding.platformViewRegistry.registerViewFactory("<tomtom-navigation>", FlutterTomtomNavigationViewFactory(flutterPluginBinding.binaryMessenger, ::publish))
  }

  // Publish the given event on the event channel
  private fun publish(value: String) {
    eventSink?.success(value)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
}
