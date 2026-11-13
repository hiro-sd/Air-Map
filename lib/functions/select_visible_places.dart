import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/travel_place.dart';

bool isInsideBounds(LatLng point, LatLngBounds bounds) {
  if (point.latitude < bounds.southwest.latitude ||
      point.latitude > bounds.northeast.latitude) {
    return false;
  }
  final west = bounds.southwest.longitude;
  final east = bounds.northeast.longitude;
  return west <= east
      ? point.longitude >= west && point.longitude <= east
      : point.longitude >= west || point.longitude <= east;
}

List<TravelPlace> selectVisiblePlaces(
  Iterable<TravelPlace> places,
  LatLngBounds bounds,
  LatLng center, {
  int limit = 5,
}) {
  if (limit <= 0) return const [];
  final visible = places
      .where((place) => isInsideBounds(place.position, bounds))
      .toList()
    ..sort((a, b) => _distanceSquared(a.position, center)
        .compareTo(_distanceSquared(b.position, center)));

  final selected = <TravelPlace>[];
  for (final unexpected in [false, true]) {
    for (final place in visible) {
      if (place.isUnexpected == unexpected) {
        selected.add(place);
        break;
      }
    }
    if (selected.length == limit) return selected;
  }
  for (final place in visible) {
    if (!selected.contains(place)) selected.add(place);
    if (selected.length == limit) break;
  }
  return selected;
}

double _distanceSquared(LatLng a, LatLng b) {
  final latitudeDelta = a.latitude - b.latitude;
  final longitudeDelta = ((a.longitude - b.longitude + 540) % 360) - 180;
  final scaledLongitude = longitudeDelta * math.cos(b.latitude * math.pi / 180);
  return latitudeDelta * latitudeDelta + scaledLongitude * scaledLongitude;
}
