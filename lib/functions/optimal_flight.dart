import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/ui/screen/flight_result_screen.dart';

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

Future<List<FlightOffer>?> searchFlights(String originCode,
    String destinationCode, DateTime date, int passengers) async {
  String? accessToken = await getAccessToken();
  if (accessToken == null) {
    print("Failed to get access token");
    return null;
  }

  // 日付を YYYY-MM-DD 形式に変換
  String formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  final response = await http.get(
    Uri.parse(
        "https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=$originCode&destinationLocationCode=$destinationCode&departureDate=$formattedDate&adults=$passengers&nonStop=true&max=30&currencyCode=JPY"),
    headers: {
      "Authorization": "Bearer $accessToken",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['data'] as List)
        .map((offer) => FlightOffer.fromJson(offer))
        .toList();
  } else {
    print("Error fetching flights: ${response.body}");
    return null;
  }
}

// TODO: これを応用して、複数の出発地・目的地候補から、最も適切な出発地や目的地を選択する？？
