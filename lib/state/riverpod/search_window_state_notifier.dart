import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/env/env.dart';

// SearchWindowの状態を管理するStateNotifier
class SearchWindowStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  SearchWindowStateNotifier() : super([]);

  String apiKey = Env.key;

  // 検索候補の取得
  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      state = [];
      return;
    }

    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String requestUrl =
        '$baseUrl?input=$input&key=$apiKey&components=country:jp&types=airport'; // 日本限定, 空港限定

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'];
        state = predictions.map<Map<String, dynamic>>((dynamic prediction) {
          return {
            'description': prediction['description'],
            'place_id': prediction['place_id'],
          };
        }).toList();
      } else {
        //print('Failed to fetch suggestions: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error occurred while fetching suggestions: $e');
    }
  }

// 特定の場所の詳細情報を取得
  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    final String requestUrl = '$baseUrl?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        List<String>? photoReferences =
            (data['result']['photos'] as List<dynamic>?)
                ?.map((photo) => photo['photo_reference'] as String)
                .toList();
        return {
          'lat': location['lat'],
          'lng': location['lng'],
          'name': data['result']['name'],
          'photo_reference': photoReferences,
        };
      } else {
        //print('Failed to fetch place details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      //print('Error occurred while fetching place details: $e');
      return null;
    }
  }
}

// Providerの定義
final searchWindowProvider = StateNotifierProvider<SearchWindowStateNotifier,
    List<Map<String, dynamic>>>((ref) => SearchWindowStateNotifier());
