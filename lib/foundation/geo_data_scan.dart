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
Future<List<LatLng>> loadAreaGeoJson(String area) async {
  final String geojsonString =
      await rootBundle.loadString('lib/assets/geodata/$area.geojson');
  final Map<String, dynamic> geojson = json.decode(geojsonString);

  final List<LatLng> points = [];

  final List<dynamic> features = geojson['features'];
  for (var feature in features) {
    if (feature['geometry']['type'] == 'MultiPolygon') {
      final List<dynamic> coordinates = feature['geometry']['coordinates'];

      for (var polygon in coordinates) {
        for (var ring in polygon) {
          for (var coord in ring) {
            final double lat = coord[1];
            final double lng = coord[0];
            points.add(LatLng(lat, lng));
          }
        }
      }
    }
  }

  return points;
}

// 読み込んだ座標をもとにポリゴンを描画する
Future<void> loadAndDisplayAreaPolygon(
    String area, WidgetRef ref, BuildContext context) async {
  ref.read(polygonDrawingProvider.notifier).clearPolygons(ref);
  final List<LatLng> points = await loadAreaGeoJson(area);
  final polygon = Polygon(
    polygonId: PolygonId(area),
    points: points,
    strokeWidth: 3,
    strokeColor: Colors.blue.withOpacity(0.8),
    fillColor: Colors.blue.withOpacity(0.2),
  );

  ref.read(polygonSetProvider.notifier).state = {polygon};
  final airportMarkers = airportData;
  final markersInsidePolygon = getMarkersInsidePolygon(points, airportMarkers);
  // マーカーをGoogleMap上に反映
  final newMarkers = markersInsidePolygon.map((marker) {
    return Marker(
        markerId: MarkerId(marker['id']),
        position: marker['position'],
        infoWindow: InfoWindow(
          title: marker['title'](context),
          snippet: marker['snippet'](context),
        ),
        onTap: () async {
          String apiKey = Env.key;
          final String title = marker['title'](context);

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
}
