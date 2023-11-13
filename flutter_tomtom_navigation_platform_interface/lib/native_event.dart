import 'dart:convert';

/// This represent all the event possibilities from the native code

enum NativeEventType { unknown, navigationUpdate, routeUpdate, routePlanned }

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
      default:
        return -1;
    }
  }

  static NativeEventType fromValue(int value) {
    switch (value) {
      case 0:
        return NativeEventType.unknown;
      case 1:
        return NativeEventType.routeUpdate;
      case 2:
        return NativeEventType.routePlanned;
      case 3:
        return NativeEventType.navigationUpdate;
      default:
        return NativeEventType.unknown;
    }
  }

//

  bool get isRouteUpdate => this == NativeEventType.routeUpdate;
  bool get isRoutePlanned => this == NativeEventType.routePlanned;
  bool get isNavigationUpdate => this == NativeEventType.navigationUpdate;
  bool get isUnknown => this == NativeEventType.unknown;
}

class NativeEvent {
  NativeEvent({
    required this.nativeEventType,
    required this.data,
  });

  final NativeEventType nativeEventType;
  final String data;

  // Map<String, dynamic> toMap() {
  //   return {
  //     'nativeEventType': NativeEventType.value,
  //     'data': data,
  //   };
  // }

  factory NativeEvent.fromMap(Map<String, dynamic> map) {
    return NativeEvent(
      nativeEventType:
      NativeEventExtension.fromValue(map['nativeEventType'] as int),
      data: map['data'] ?? '',
    );
  }

  // String toJson() => json.encode(toMap());

  factory NativeEvent.fromJson(String source) =>
      NativeEvent.fromMap(json.decode(source));
}
