import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticket_app/env/env.dart';

const String baseUrl = "https://test.api.amadeus.com";

Future<String?> getAccessToken() async {
  final String apiKey = Env.amadeusApiKey;
  final String apiSecret = Env.amadeusApiSecret;

  final response = await http.post(
    Uri.parse("$baseUrl/v1/security/oauth2/token"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      "grant_type": "client_credentials",
      "client_id": apiKey,
      "client_secret": apiSecret
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['access_token'];
  } else {
    print("Failed to get access token: ${response.body}");
    return null;
  }
}

Future<List<dynamic>?> searchFlights(
    String origin, String destination, DateTime date, int number) async {
  String? accessToken = await getAccessToken();
  if (accessToken == null) return null;

  // 日付を YYYY-MM-DD 形式に変換
  String formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  final response = await http.get(
    Uri.parse(
        "https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=$origin&destinationLocationCode=$destination&departureDate=$formattedDate&adults=$number&nonStop=true&max=5&currencyCode=JPY"),
    headers: {
      "Authorization": "Bearer $accessToken",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'];
  } else {
    print("Error fetching flights: ${response.body}");
    return null;
  }
}

// TODO: 無料枠のlimit気を付ける
// TODO: 出発地と目的地を指定すると、最適な経路を返す
// TODO: 出発する空港と行き先を指定したら、適切な経路や値段を表示する。
// これを応用して、複数の出発地・目的地候補から、最も適切な出発地や目的地を選択する？？
