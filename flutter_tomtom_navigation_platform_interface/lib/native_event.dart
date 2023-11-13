import 'dart:convert';

/// This represent all the event possibilities from the native code

enum NativeEventType {
  unknown,
  navigationUpdate,
  routeUpdate,
  routePlanned,
  destinationArrival
}

extension NativeEventExtension on NativeEventType {
  int get value {
    switch (this) {
      case NativeEventType.unknown:
        return 0;
      case NativeEventType.routeUpdate:
        return 1;
      case NativeEventType.routePlanned:
        return 2;
      case NativeEventType.navigationUpdate:
        return 3;
      case NativeEventType.destinationArrival:
        return 4;
    }
  }

  static NativeEventType fromValue(int value) {
    switch (value) {
      case 1:
        return NativeEventType.routeUpdate;
      case 2:
        return NativeEventType.routePlanned;
      case 3:
        return NativeEventType.navigationUpdate;
      case 4:
        return NativeEventType.destinationArrival;
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
      nativeEventType:
          NativeEventExtension.fromValue(map['nativeEventType'] as int),
      data: map['data'] ?? '',
    );
  }

  factory NativeEvent.fromJson(String source) =>
      NativeEvent.fromMap(json.decode(source));
}
