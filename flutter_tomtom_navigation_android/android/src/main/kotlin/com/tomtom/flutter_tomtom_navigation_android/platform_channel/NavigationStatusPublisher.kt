package com.tomtom.flutter_tomtom_navigation_android.platform_channel

/**
 * Publish navigation updates to Flutter.
 */
class NavigationStatusPublisher(publish: (String) -> Unit) :
    NativeEventPublisher(publish) {

    /**
     * The navigation status used for communication between Android and Flutter.
     *
     * These correspond to those defined in Dart
     */
    enum class NavigationStatus(val value: Int) {
        INITIALIZING(0),
        MAP_LOADED(1),
        RESTRICTIONS_LOADED(2),
        READY(3),
        RUNNING(4),
        STOPPED(5),
    }

    fun publish(status: NavigationStatus) {
        val jsonString = "{\"navigationStatus\": ${status.value}}"
        publishMessage(
            getNativeEventJson(
                jsonString,
                NativeEventType.NAVIGATION_UPDATE
            )
        )
    }
}