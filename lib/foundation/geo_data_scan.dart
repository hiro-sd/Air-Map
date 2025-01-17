import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/foundation/modal_sheet.dart';
import 'package:ticket_app/state/riverpod/polygon_drawing_notifier.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/ui/screen/airport_list_screen.dart';
import 'package:http/http.dart' as http;

// geojsonファイルを読み込む
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

List<Map<String, dynamic>> centerLatLngs = [
  {'hokkaido': const LatLng(43.420962, 142.781281), 'zoom': 6.4},
  {'tohoku': const LatLng(39.23286365076151, 140.5830066571554), 'zoom': 7.4},
  {'kanto': const LatLng(35.13941202176295, 139.673593517746336), 'zoom': 7.7},
  {'chubu': const LatLng(35.96401444205463, 137.68091997993142), 'zoom': 7.0},
  {'kinki': const LatLng(34.64280347749818, 135.5739247499291), 'zoom': 7.7},
  {'chugoku': const LatLng(34.99872056192886, 132.71277144634544), 'zoom': 7.3},
  {
    'shikoku': const LatLng(33.729026776168574, 133.49864327030613),
    'zoom': 7.8
  },
  {'kyushu': const LatLng(30.883730385817117, 129.97552166585507), 'zoom': 6.8},
  {'okinawa': const LatLng(25.76023575080417, 127.06245890649342), 'zoom': 6.1},
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
  final List<List<LatLng>> polygons = await loadAreaGeoJson(area);

  final Set<Polygon> polygonSet = {};
  for (var points in polygons) {
    final polygon = Polygon(
      polygonId: PolygonId(area + polygons.indexOf(points).toString()),
      points: points,
      strokeWidth: 3,
      strokeColor: Colors.blue.withOpacity(0.8),
      fillColor: Colors.blue.withOpacity(0.2),
    );
    polygonSet.add(polygon);
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
        onTap: () async {
          String apiKey = Env.key;
          //final String title = marker['title'](context);

          // TODO: markerタップでbottomSheetを表示できるようにする
          // Place IDの取得
          final placeSearchUrl =
              'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$title&inputtype=textquery&fields=place_id&key=$apiKey';

          final placeSearchResponse = await http.get(Uri.parse(placeSearchUrl));
          final placeSearchData = jsonDecode(placeSearchResponse.body);

          if (placeSearchData['status'] != 'OK') {
            return;
          }

          final placeId = placeSearchData['candidates'][0]['place_id'];

          // Photo Referencesの取得
          final detailsUrl =
              'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';

          final detailsResponse = await http.get(Uri.parse(detailsUrl));
          final detailsData = jsonDecode(detailsResponse.body);

          if (detailsData['status'] != 'OK') {
            return;
          }

          final photos = detailsData['result']['photos'] as List<dynamic>?;

          // Photo URLsを生成
          final List<String> photoUrls = photos?.map((photo) {
                final photoRef = photo['photo_reference'];
                return 'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey';
              }).toList() ??
              [];
          // ignore: use_build_context_synchronously
          showCustomBottomSheet(context, ref, null, title, photoUrls);
        });
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
