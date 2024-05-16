package com.tomtom.flutter_tomtom_navigation_android.platform_channel

import com.tomtom.sdk.routing.route.Route

class DestinationArrivalPublisher(publish: (String) -> Unit) :
    NativeEventPublisher(publish) {
    fun publish(route: Route) {
        val jsonString = "{\"routeId\": \"${route.id}\"}"
        publishMessage(
            getNativeEventJson(
                jsonString,
                NativeEventType.DESTINATION_ARRIVAL,
            )
        )
    }
}