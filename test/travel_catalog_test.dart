import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/data/travel_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late String source;
  setUpAll(() async {
    source = await rootBundle.loadString(travelCatalogAsset);
  });

  test('同梱カタログに地域・紹介文・出典が揃い、IDから検索できる', () {
    final catalog = TravelCatalog.fromJsonString(source);
    expect(catalog.places.length, greaterThanOrEqualTo(22));
    expect(catalog.regions, isNotEmpty);
    const originalIds = {
      'sensoji',
      'nezu_shrine',
      'kiyosumi_garden',
      'inokashira_park',
      'ritsurin_garden',
      'chichibugahama',
      'iya_vine_bridge',
      'jiufen',
      'burano',
      'hallgrimskirkja',
      'ueno_park',
      'hamarikyu_gardens',
      'moerenuma_park',
      'blue_pond_biei',
      'fushimi_inari',
      'philosophers_path',
      'dazaifu_tenmangu',
      'lake_kinrin',
      'taipei_101',
      'xiangshan_viewpoint',
      'gardens_by_the_bay',
      'haw_par_villa',
    };
    expect(catalog.places.map((place) => place.id).toSet(),
        containsAll(originalIds));
    for (final place in catalog.places) {
      expect(catalog.byId(place.id), same(place));
      expect(catalog.regions[place.region.id], same(place.region));
      expect(place.descriptionJa, isNotEmpty);
      expect(place.descriptionEn, isNotEmpty);
      expect(Uri.parse(place.sourceUrl).host, isNotEmpty);
      expect(place.reviewedOn, isNotEmpty);
    }
    expect(catalog.byId('unknown'), isNull);
  });

  test('重複IDや不正な位置・参照先を含む更新は拒否する', () {
    Map<String, dynamic> catalogJson() =>
        jsonDecode(source) as Map<String, dynamic>;

    final duplicate = catalogJson();
    final duplicatePlaces = duplicate['places'] as List<dynamic>;
    duplicatePlaces[1]['id'] = duplicatePlaces[0]['id'];
    expect(() => TravelCatalog.fromJsonString(jsonEncode(duplicate)),
        throwsFormatException);

    final badRegion = catalogJson();
    (badRegion['places'] as List<dynamic>)[0]['regionId'] = 'jp-missing';
    expect(() => TravelCatalog.fromJsonString(jsonEncode(badRegion)),
        throwsFormatException);

    final badLatitude = catalogJson();
    (badLatitude['places'] as List<dynamic>)[0]['latitude'] = 91;
    expect(() => TravelCatalog.fromJsonString(jsonEncode(badLatitude)),
        throwsFormatException);

    final badSource = catalogJson();
    (badSource['places'] as List<dynamic>)[0]['source']['url'] =
        'http://example.com';
    expect(() => TravelCatalog.fromJsonString(jsonEncode(badSource)),
        throwsFormatException);

    final badDate = catalogJson();
    (badDate['places'] as List<dynamic>)[0]['reviewedOn'] = '2026-02-31';
    expect(() => TravelCatalog.fromJsonString(jsonEncode(badDate)),
        throwsFormatException);
  });
}
