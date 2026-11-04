import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/flight_offer.dart';
import 'package:ticket_app/screen/flight_result_screen.dart';

void main() {
  testWidgets('通信失敗を便なしと区別し、再試行できる', (tester) async {
    var calls = 0;

    Future<List<FlightOffer>> flightSearch(String origin, String destination,
        DateTime date, int passengers) async {
      calls++;
      if (calls == 1) throw Exception('offline');
      return [];
    }

    final screen = FlightResultScreen(
      origin: '羽田空港',
      originCode: 'HND',
      destination: '高知空港',
      destinationCode: 'KCZ',
      date: DateTime(2026, 11, 7),
      passengers: 1,
      flightSearch: flightSearch,
    );

    Widget app() => MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen,
        );

    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.textContaining('フライト情報を取得できませんでした'), findsOneWidget);
    expect(find.text('現在のデータでは、この条件の便を確認できませんでした。'), findsNothing);

    await tester.pumpWidget(app());
    await tester.pump();
    expect(calls, 1);

    await tester.tap(find.text('再試行'));
    await tester.pump();
    await tester.pump();

    expect(calls, 2);
    expect(find.text('現在のデータでは、この条件の便を確認できませんでした。'), findsOneWidget);
  });
}
