import 'dart:convert';

/// This represent all the event possibilities from the native code
enum NativeEventType {
  /// An unknown event.
  unknown(0),

  /// An update on the route progress.
  routeUpdate(1),

  /// A callback when the route was planned.
  routePlanned(2),

  /// A navigation view lifecycle update.
  navigationUpdate(3),

  /// A callback when the destination was reached.
  destinationArrival(4),

  /// An updated location.
  locationUpdate(5);

  const NativeEventType(this.value);

  /// Create a native event type from its integer value.
  factory NativeEventType.fromValue(int value) {
    switch (value) {
      case 1:
        return NativeEventType.routeUpdate;
      case 2:
        return NativeEventType.routePlanned;
      case 3:
        return NativeEventType.navigationUpdate;
      case 4:
        return NativeEventType.destinationArrival;
      case 5:
        return NativeEventType.locationUpdate;
      case 0:
      default:
        return NativeEventType.unknown;
    }
  }

  /// The integer value representing this status.
  final int value;
}

/// A container class representing an event from the native SDKs.
class NativeEvent {
  /// Create a new native event.
  NativeEvent({
    required this.nativeEventType,
    required this.data,
  });

  /// Create a new native event from a key/value map.
  factory NativeEvent.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is String ? map['data'] as String : '';
    return NativeEvent(
      nativeEventType: NativeEventType.fromValue(map['nativeEventType'] as int),
      data: data,
    );
  }

  /// Create a new native event from a JSON encoded String.
  factory NativeEvent.fromJson(String source) =>
      NativeEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  /// The type of event.
  final NativeEventType nativeEventType;

  /// The data payload of this event, represented as a JSON String.
  final String data;
}
