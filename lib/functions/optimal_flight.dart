import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/screen/flight_result_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const String baseUrl = "https://test.api.amadeus.com";

// アクセストークンを取得
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

// フライトを検索
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

// 各サイトにリダイレクト
Future<void> launchBookingSite(
    String carrier,
    String flightNumber,
    String originCode,
    String destinationCode,
    DateTime date,
    int passengers) async {
  String departureDate = // Jetstarの場合、日付を DD-MM-YYYY 形式に変換
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  final airlineUrls = {
    'NH': 'https://www.ana.co.jp/ja/jp/search/domestic/flight/',
    'JL': 'https://www.jal.co.jp/jp/ja/dom/', // JALやANAはURLで検索できない
    'GK':
        'https://www.jetstar.com/jp/ja/home?adults=$passengers&children=0&destination=$destinationCode&flexible=1&flight-type=1&infants=0&origin=$originCode&selected-departure-date=$departureDate&tab=1',
    'NU': 'https://jta-okinawa.com/'
  };

  final baseUrl = airlineUrls[carrier] ??
      'https://www.google.com/search?q=$carrier+$flightNumber';

  final url = Uri.parse(baseUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  } else {
    throw 'Could not launch $url';
  }
}

// TODO: これを応用して、複数の出発地・目的地候補から、最も適切な出発地や目的地を選択する？？
