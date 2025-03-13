import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/functions/modal_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/main.dart';

Map<String, String> placeIdCache = {}; // Place IDのキャッシュ
Map<String, List<String>> photoUrlCache = {}; // Photo URLのキャッシュ
var box = Hive.box('cacheBox');

// 空港のマーカーを生成する関数
Set<Marker> generateMarkers(List<Map<String, dynamic>> airports) {
  return airports.map((airport) {
    return Marker(
        markerId: MarkerId(airport['id']),
        position: airport['position'],
        onTap: () async {
          BuildContext? currentContext =
              globalNavigatorKey.currentContext; // タップ時にcontextを取得

          if (currentContext == null || !currentContext.mounted) return;

          String apiKey = Env.googleMapsApiKey;
          final String title = airport['title'](currentContext);
          final String snippet = airport['snippet'](currentContext);
          final String airportCode = airport['IATA'];

          try {
            String placeId = await _getPlaceId(title, apiKey);
            List<String> photoUrls = await _getPhotoUrls(placeId, apiKey);

            if (currentContext.mounted) {
              final ref = ProviderScope.containerOf(
                  currentContext); // refをウィジェットツリーから取得
              showCustomBottomSheet(
                  currentContext, ref, title, snippet, photoUrls, airportCode);
            }
          } catch (e) {
            print("Error: $e");
          }
        });
  }).toSet();
}

// Place IDを取得する関数
Future<String> _getPlaceId(String title, String apiKey) async {
  // Place IDのキャッシュがあればそれを使う
  if (box.containsKey('placeId_$title')) {
    return box.get('placeId_$title');
  } else {
    // Place IDの取得
    final placeSearchUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$title&inputtype=textquery&fields=place_id&key=$apiKey';

    final placeSearchResponse = await http.get(Uri.parse(placeSearchUrl));
    if (placeSearchResponse.statusCode != 200) {
      throw Exception('Failed to fetch place ID');
    }

    final placeSearchData = jsonDecode(placeSearchResponse.body);
    if (placeSearchData['status'] != 'OK') {
      throw Exception(
          'Place search response status: ${placeSearchData['status']}');
    }

    final placeId = placeSearchData['candidates'][0]['place_id'];
    box.put('placeId_$title', placeId); // キャッシュに保存
    return placeId;
  }
}

// Photo URLを取得する関数
Future<List<String>> _getPhotoUrls(String placeId, String apiKey) async {
  // Photo URLのキャッシュがあればそれを使う
  if (box.containsKey('photoUrls_$placeId')) {
    return List<String>.from(box.get('photoUrls_$placeId'));
  } else {
    // Photo Referencesの取得
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';
    final detailsResponse = await http.get(Uri.parse(detailsUrl));
    if (detailsResponse.statusCode != 200) {
      throw Exception('Failed to fetch place details');
    }

    final detailsData = jsonDecode(detailsResponse.body);
    if (detailsData['status'] != 'OK') {
      throw Exception(
          'Place details response status: ${detailsData['status']}');
    }

    final photos = detailsData['result']['photos'] as List<dynamic>?;

    // Photo URLsを生成
    final photoUrls = photos?.map((photo) {
          final photoRef = photo['photo_reference'];
          return 'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey';
        }).toList() ??
        [];
    box.put('photoUrls_$placeId', photoUrls); // キャッシュに保存
    return photoUrls;
  }
}
