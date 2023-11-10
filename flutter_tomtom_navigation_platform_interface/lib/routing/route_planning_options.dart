// TODO Use actual (scraped) RoutePlanningOptions instead.
class RoutePlanningOptions {
  RoutePlanningOptions(this.destination);

  final GeoPoint destination;
}

class GeoPoint {
  GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}
