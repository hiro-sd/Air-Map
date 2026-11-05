import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:ticket_app/functions/geo_data_scan.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/airport_candidate.dart';
import 'package:ticket_app/screen/airport_candidates_sheet.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('四国の地域データでも範囲内と範囲外の候補が得られる', () async {
    final polygons = await loadAreaGeoJson('shikoku');
    final candidates = findAirportCandidates(
      AirportSearchArea.region(const LatLng(33.73, 133.50), polygons),
      airportData,
    );

    expect(candidates.singleWhere((item) => item.code == 'TAK').isInside, isTrue);
    expect(candidates.singleWhere((item) => item.code == 'OKJ').isInside, isFalse);
  });

  test('選択範囲内と、境界に近い範囲外の空港を分けて返す', () {
    const area = AirportSearchArea.region(
      LatLng(33.8, 133.5),
      [
        [
          LatLng(33.2, 132.0),
          LatLng(33.2, 135.0),
          LatLng(34.4, 135.0),
          LatLng(34.4, 132.0),
        ],
      ],
    );

    final candidates = findAirportCandidates(area, airportData);
    final takamatsu = candidates.singleWhere((item) => item.code == 'TAK');
    final okayama = candidates.singleWhere((item) => item.code == 'OKJ');

    expect(takamatsu.isInside, isTrue);
    expect(okayama.isInside, isFalse);
    expect(okayama.distanceToAreaKm, lessThan(150));
    expect(candidates.where((item) => !item.isInside), isNotEmpty);
  });

  testWidgets('候補選択で到着空港コードを検索画面へ引き継ぐ', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    var searchRequested = false;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              return TextButton(
                onPressed: () => showAirportCandidatesSheet(
                  context: context,
                  ref: ref,
                  area: const AirportSearchArea.point(LatLng(34.214, 134.016)),
                  onSearchRequested: () => searchRequested = true,
                ),
                child: const Text('候補を開く'),
              );
            }),
          ),
        ),
      ),
    );

    await tester.tap(find.text('候補を開く'));
    await tester.pumpAndSettle();
    expect(find.textContaining('就航情報: 未確認'), findsWidgets);
    await tester.tap(find.textContaining('(TAK)').first);
    await tester.pumpAndSettle();

    expect(container.read(destinationCodeProvider), 'TAK');
    expect(searchRequested, isTrue);
  });
}
