import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/saved_place.dart';

enum SavedPlaceFilter { all, wantToGo, visited, favorites }

List<SavedPlace> filterSavedPlaces(
    Iterable<SavedPlace> places, SavedPlaceFilter filter) {
  return places.where((place) {
    return switch (filter) {
      SavedPlaceFilter.all => true,
      SavedPlaceFilter.wantToGo => place.status == VisitStatus.wantToGo,
      SavedPlaceFilter.visited => place.status == VisitStatus.visited,
      SavedPlaceFilter.favorites => place.isFavorite,
    };
  }).toList();
}

/// Returns the smallest longitude arc containing the places, including when
/// they straddle the international date line. A single position needs a zoom
/// level instead of bounds, so it returns null.
LatLngBounds? savedPlaceBounds(Iterable<SavedPlace> places) {
  final positions = places.map((place) => place.position).toList();
  if (positions.length < 2 || positions.every((p) => p == positions.first)) {
    return null;
  }

  var south = positions.first.latitude;
  var north = south;
  final longitudes = <double>[];
  for (final position in positions) {
    if (position.latitude < south) south = position.latitude;
    if (position.latitude > north) north = position.latitude;
    longitudes.add(position.longitude);
  }
  longitudes.sort();

  var largestGap = -1.0;
  var gapStart = 0;
  for (var i = 0; i < longitudes.length; i++) {
    final next =
        i == longitudes.length - 1 ? longitudes.first + 360 : longitudes[i + 1];
    final gap = next - longitudes[i];
    if (gap > largestGap) {
      largestGap = gap;
      gapStart = i;
    }
  }

  var west = longitudes[(gapStart + 1) % longitudes.length];
  var east = longitudes[gapStart];
  // Keep bounds nonzero when places share a latitude or longitude.
  if (south == north) {
    south = (south - 0.01).clamp(-90.0, 90.0);
    north = (north + 0.01).clamp(-90.0, 90.0);
  }
  if (west == east) {
    west = (west - 0.01).clamp(-180.0, 180.0);
    east = (east + 0.01).clamp(-180.0, 180.0);
  }

  return LatLngBounds(
    southwest: LatLng(south, west),
    northeast: LatLng(north, east),
  );
}
