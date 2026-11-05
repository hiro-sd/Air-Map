import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/functions/get_markers_inside_polygon.dart';

/// A map point or a selected region. For a region, [reference] is the
/// approximate center used only for the displayed straight-line distance.
class AirportSearchArea {
  final LatLng reference;
  final List<List<LatLng>> polygons;

  const AirportSearchArea.point(this.reference) : polygons = const [];

  const AirportSearchArea.region(this.reference, this.polygons);

  factory AirportSearchArea.fromPolygon(List<LatLng> polygon) {
    assert(polygon.isNotEmpty);
    final latitudes = polygon.map((point) => point.latitude);
    final longitudes = polygon.map((point) => point.longitude);
    return AirportSearchArea.region(
      LatLng(
        (latitudes.reduce(math.min) + latitudes.reduce(math.max)) / 2,
        (longitudes.reduce(math.min) + longitudes.reduce(math.max)) / 2,
      ),
      [polygon],
    );
  }

  bool get isPoint => polygons.isEmpty;
}

class AirportCandidate {
  final Map<String, dynamic> airport;
  final bool isInside;
  final double distanceKm;
  final double distanceToAreaKm;

  const AirportCandidate({
    required this.airport,
    required this.isInside,
    required this.distanceKm,
    required this.distanceToAreaKm,
  });

  LatLng get position => airport['position'] as LatLng;
  String get code => airport['IATA'] as String;
}

/// Returns every airport inside a region and all airports within
/// [nearbyRadiusKm] of its boundary (or of the chosen point).
/// No flight availability is inferred from this geographical search.
List<AirportCandidate> findAirportCandidates(
  AirportSearchArea area,
  List<Map<String, dynamic>> airports, {
  double nearbyRadiusKm = 150,
}) {
  final inside = <AirportCandidate>[];
  final nearby = <AirportCandidate>[];

  for (final airport in airports) {
    final position = airport['position'] as LatLng;
    final distanceKm = Geolocator.distanceBetween(
          area.reference.latitude,
          area.reference.longitude,
          position.latitude,
          position.longitude,
        ) /
        1000;
    final isInside =
        area.polygons.any((polygon) => isPointInPolygon(position, polygon));
    final distanceToAreaKm = area.isPoint
        ? distanceKm
        : (isInside ? 0.0 : _distanceToBoundaryKm(position, area.polygons));
    final candidate = AirportCandidate(
      airport: airport,
      isInside: isInside,
      distanceKm: distanceKm,
      distanceToAreaKm: distanceToAreaKm,
    );
    if (isInside) {
      inside.add(candidate);
    } else if (distanceToAreaKm <= nearbyRadiusKm) {
      nearby.add(candidate);
    }
  }

  inside.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  nearby.sort((a, b) => a.distanceToAreaKm.compareTo(b.distanceToAreaKm));
  return [...inside, ...nearby];
}

double _distanceToBoundaryKm(LatLng point, List<List<LatLng>> polygons) {
  var closest = double.infinity;
  final longitudeScale = 111.32 * math.cos(point.latitude * math.pi / 180);
  for (final polygon in polygons) {
    if (polygon.isEmpty) continue;
    for (var index = 0; index < polygon.length; index++) {
      final start = polygon[index];
      final end = polygon[(index + 1) % polygon.length];
      final ax = (start.longitude - point.longitude) * longitudeScale;
      final ay = (start.latitude - point.latitude) * 111.32;
      final bx = (end.longitude - point.longitude) * longitudeScale;
      final by = (end.latitude - point.latitude) * 111.32;
      final dx = bx - ax;
      final dy = by - ay;
      final lengthSquared = dx * dx + dy * dy;
      final fraction =
          lengthSquared == 0 ? 0.0 : (-ax * dx - ay * dy) / lengthSquared;
      final t = fraction.clamp(0.0, 1.0);
      closest = math.min(
        closest,
        math.sqrt(math.pow(ax + t * dx, 2) + math.pow(ay + t * dy, 2)),
      );
    }
  }
  return closest;
}
