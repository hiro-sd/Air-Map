import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/functions/modal_sheet.dart';
import 'package:ticket_app/state/riverpod/polygon_drawing_notifier.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/functions/airport_list.dart';
import 'package:http/http.dart' as http;

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
  final airportMarkers = airportData;
  final markersInsidePolygon = polygons
      .map((polygonPoints) =>
          getMarkersInsidePolygon(polygonPoints, airportMarkers))
      .expand((markers) => markers)
      .toList();
  // マーカーをGoogleMap上に反映
  final newMarkers = markersInsidePolygon.map((marker) {
    final title = marker['title'](context);
    final snippet = marker['snippet'](context);
    return Marker(
      markerId: MarkerId(marker['id']),
      position: marker['position'],
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
      onTap: () => onMarkerTapped(marker, ref, context),
    );
  }).toSet();

  // StateNotifierを使用してマーカーを更新
  ref.read(mapScreenProvider.notifier).updateMarkers(newMarkers);
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

// マーカータップ時の処理
Future<void> onMarkerTapped(
    // TODO: マーカーをタップするとエラーになる
    Map<String, dynamic> marker,
    WidgetRef ref,
    BuildContext context) async {
  final apiKey = Env.googleMapsApiKey;
  final String title = marker['title'](context);

  try {
    // Place IDの取得
    final placeSearchUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$title&inputtype=textquery&fields=place_id&key=$apiKey';
    final placeSearchResponse = await http.get(Uri.parse(placeSearchUrl));
    if (placeSearchResponse.statusCode != 200) return;

    final placeSearchData = jsonDecode(placeSearchResponse.body);
    if (placeSearchData['status'] != 'OK') return;

    final placeId = placeSearchData['candidates'][0]['place_id'];

    // Photo Referencesの取得
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';
    final detailsResponse = await http.get(Uri.parse(detailsUrl));
    if (detailsResponse.statusCode != 200) return;

    final detailsData = jsonDecode(detailsResponse.body);
    if (detailsData['status'] != 'OK') return;

    final photos = detailsData['result']['photos'] as List<dynamic>?;

    // Photo URLsを生成
    final List<String> photoUrls = photos?.map((photo) {
          final photoRef = photo['photo_reference'];
          return 'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey';
        }).toList() ??
        [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showCustomBottomSheet(context, ref, null, title, photoUrls);
      }
    });
  } catch (e) {
    // エラーハンドリング
    print('Error occurred: $e');
  }
}
