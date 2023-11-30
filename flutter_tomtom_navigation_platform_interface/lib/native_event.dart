import 'dart:convert';

/// This represent all the event possibilities from the native code
enum NativeEventType {
  unknown(0),
  routeUpdate(1),
  routePlanned(2),
  navigationUpdate(3),
  destinationArrival(4),
  locationUpdate(5);

  const NativeEventType(this.value);

  final int value;

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
}

class NativeEvent {
  NativeEvent({
    required this.nativeEventType,
    required this.data,
  });

  final NativeEventType nativeEventType;
  final String data;

  factory NativeEvent.fromMap(Map<String, dynamic> map) {
    return NativeEvent(
      nativeEventType: NativeEventType.fromValue(map['nativeEventType'] as int),
      data: map['data'] ?? '',
    );
  }

  factory NativeEvent.fromJson(String source) =>
      NativeEvent.fromMap(json.decode(source));
}
