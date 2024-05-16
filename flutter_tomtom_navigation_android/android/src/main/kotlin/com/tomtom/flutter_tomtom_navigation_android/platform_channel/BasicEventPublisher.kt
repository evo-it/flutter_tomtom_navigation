package com.tomtom.flutter_tomtom_navigation_android.platform_channel

import com.google.gson.Gson

class BasicEventPublisher(
    publish: (String) -> Unit,
    private val type: NativeEventType
) :
    NativeEventPublisher(publish) {
    private val gson = Gson()

    fun publish(data: Any) {
        val jsonString = gson.toJson(data)
        publishMessage(getNativeEventJson(jsonString, type))
    }
}