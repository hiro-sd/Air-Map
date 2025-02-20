import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/functions/generate_markers.dart';
import 'package:ticket_app/state/polygon_drawing_notifier.dart';
import 'package:ticket_app/state/map_screen_state_notifier.dart';
import 'package:ticket_app/airport_list.dart';

// GeoJSONファイルを読み込む
Future<List<List<LatLng>>> loadAreaGeoJson(String area) async {
  final String geojsonString =
      await rootBundle.loadString('assets/geodata/$area.geojson');
  final Map<String, dynamic> geojson = json.decode(geojsonString);

  final List<List<LatLng>> polygons = [];

  final List<dynamic> features = geojson['features'];
  for (var feature in features) {
    if (feature['geometry']['type'] == 'MultiPolygon') {
      final List<dynamic> coordinates = feature['geometry']['coordinates'];

      for (var polygon in coordinates) {
        final List<LatLng> points = [];
        for (var ring in polygon) {
          for (var coord in ring) {
            final double lat = coord[1];
            final double lng = coord[0];
            points.add(LatLng(lat, lng));
          }
        }
        polygons.add(points);
      }
    }
  }
  return polygons;
}

// 地域ごとの中心座標とズームレベル
const List<Map<String, dynamic>> centerLatLngs = [
  {'hokkaido': LatLng(43.42, 142.78), 'zoom': 6.4},
  {'tohoku': LatLng(39.23, 140.58), 'zoom': 7.4},
  {'kanto': LatLng(35.14, 139.67), 'zoom': 7.7},
  {'chubu': LatLng(35.964, 137.681), 'zoom': 7.0},
  {'kinki': LatLng(34.643, 135.574), 'zoom': 7.7},
  {'chugoku': LatLng(34.999, 132.713), 'zoom': 7.3},
  {'shikoku': LatLng(33.73, 133.50), 'zoom': 7.8},
  {'kyushu': LatLng(30.884, 129.976), 'zoom': 6.8},
  {'okinawa': LatLng(25.760, 127.062), 'zoom': 6.1},
];

// 読み込んだ座標をもとにポリゴンを描画する
Future<void> loadAndDisplayAreaPolygon(
    String area, WidgetRef ref, BuildContext context) async {
  ref.read(polygonSetProvider).clear();
  ref.read(polylineSetProvider).clear();
  ref.read(circleProvider.notifier).state.clear();
  ref.read(mapScreenProvider).tmpLand
      ? {
          ref.read(mapScreenProvider.notifier).toggleTmpLand(),
          ref.read(mapScreenProvider.notifier).clearMarkers()
        }
      : null;
  ref.read(mapScreenProvider).tmpTakeoff
      ? {
          ref.read(mapScreenProvider.notifier).toggleTmpTakeoff(),
          ref.read(mapScreenProvider.notifier).clearMarkers()
        }
      : null;

  // GeoJSONファイルを読み込む
  final polygons = await loadAreaGeoJson(area);

  // ポリゴンを描画
  final Set<Polygon> polygonSet = {};
  for (var points in polygons) {
    polygonSet.add(Polygon(
      polygonId: PolygonId(area + polygons.indexOf(points).toString()),
      points: points,
      strokeWidth: 3,
      strokeColor: Colors.blue.withOpacity(0.8),
      fillColor: Colors.blue.withOpacity(0.2),
    ));
  }

  ref.read(polygonSetProvider.notifier).state = polygonSet;
  final markersInsidePolygon = polygons
      .map((polygonPoints) =>
          getMarkersInsidePolygon(polygonPoints, airportData))
      .expand((markers) => markers)
      .toList();
  ref
      .read(mapScreenProvider.notifier)
      .updateMarkers(generateMarkers(markersInsidePolygon));
  // centerLatLngsの座標に移動
  final centerLatLngData = centerLatLngs.firstWhere(
    (element) => element.containsKey(area),
  );

  final GoogleMapController? controller =
      ref.read(mapScreenProvider.notifier).mapController;
  if (controller != null) {
    final centerLatLng = centerLatLngData[area] as LatLng;
    final zoomLevel = centerLatLngData['zoom'] as double;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: centerLatLng, zoom: zoomLevel),
    ));
  }
}
