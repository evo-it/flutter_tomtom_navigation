package com.tomtom.flutter_tomtom_navigation_android.platform_channel

import com.google.gson.JsonObject

/**
 * A native event publisher is used to dispatch events to Flutter from Android.
 */
abstract class NativeEventPublisher(val publishMessage: (String) -> (Unit)) {
    /**
     * The native event type should be provided by each class implementing the NativeEventPublisher.
     *
     * These correspond to those defined in Dart
     */
    enum class NativeEventType(val value: Int) {
        ROUTE_UPDATE(1),
        ROUTE_PLANNED(2),
        NAVIGATION_UPDATE(3),
        DESTINATION_ARRIVAL(4),
        LOCATION_UPDATE(5),
    }

    fun getNativeEventJson(
        json: String,
        status: NativeEventType,
    ): String {
        val newJsonObject = JsonObject()
        newJsonObject.addProperty("nativeEventType", status.value)
        newJsonObject.addProperty("data", json)

        return newJsonObject.toString()
    }
}
