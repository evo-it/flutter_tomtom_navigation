package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterTomtomNavigationViewFactory(binaryMessenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val binaryMessenger: BinaryMessenger
    init {
        this.binaryMessenger = binaryMessenger
    }

    override fun create(
        context: Context,
        viewId: Int,
        args: Any?
    ): PlatformView {
        val creationParams = HashMap<String?, Any?>()

        val map = args as Map<*,*>
        for (entry in map) {
            if (entry.key is String) {
                creationParams[entry.key as String] = entry.value
            }
        }
        creationParams["binaryMessenger"] = binaryMessenger
        return FlutterTomtomNavigationView(context, viewId, creationParams)
    }

}