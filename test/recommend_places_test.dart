import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/data/travel_catalog.dart';
import 'package:ticket_app/functions/recommend_places.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/model/travel_place.dart';

const _testRegion = TravelRegion(
  id: 'jp-tokyo',
  countryCode: 'JP',
  nameJa: '東京都',
  nameEn: 'Tokyo',
);

const _catalog = <TravelPlace>[
  TravelPlace(
    id: 'saved_nature',
    region: _testRegion,
    position: LatLng(35, 139),
    nameJa: '保存済み',
    nameEn: 'Saved',
    teaserJa: '',
    teaserEn: '',
    descriptionJa: '',
    descriptionEn: '',
    theme: PlaceTheme.nature,
    isUnexpected: false,
    sourceName: 'Test source',
    sourceUrl: 'https://example.com',
    reviewedOn: '2026-11-13',
  ),
  TravelPlace(
    id: 'near_culture',
    region: _testRegion,
    position: LatLng(35.01, 139.01),
    nameJa: '近く',
    nameEn: 'Nearby',
    teaserJa: '',
    teaserEn: '',
    descriptionJa: '',
    descriptionEn: '',
    theme: PlaceTheme.culture,
    isUnexpected: true,
    sourceName: 'Test source',
    sourceUrl: 'https://example.com',
    reviewedOn: '2026-11-13',
  ),
  TravelPlace(
    id: 'same_theme_far',
    region: _testRegion,
    position: LatLng(34, 135),
    nameJa: '同じテーマ',
    nameEn: 'Same theme',
    teaserJa: '',
    teaserEn: '',
    descriptionJa: '',
    descriptionEn: '',
    theme: PlaceTheme.nature,
    isUnexpected: false,
    sourceName: 'Test source',
    sourceUrl: 'https://example.com',
    reviewedOn: '2026-11-13',
  ),
  TravelPlace(
    id: 'surprise_far',
    region: _testRegion,
    position: LatLng(1.28, 103.78),
    nameJa: '意外',
    nameEn: 'Surprise',
    teaserJa: '',
    teaserEn: '',
    descriptionJa: '',
    descriptionEn: '',
    theme: PlaceTheme.town,
    isUnexpected: true,
    sourceName: 'Test source',
    sourceUrl: 'https://example.com',
    reviewedOn: '2026-11-13',
  ),
];

TravelPlace _place(
  String id,
  PlaceTheme theme, {
  LatLng position = const LatLng(10, 10),
  TravelRegion region = _testRegion,
  bool unexpected = false,
}) =>
    TravelPlace(
      id: id,
      region: region,
      position: position,
      nameJa: id,
      nameEn: id,
      teaserJa: id,
      teaserEn: id,
      descriptionJa: id,
      descriptionEn: id,
      theme: theme,
      isUnexpected: unexpected,
      sourceName: 'Test source',
      sourceUrl: 'https://example.com',
      reviewedOn: '2026-11-13',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TravelCatalog catalog;
  setUpAll(() async => catalog = await loadTravelCatalog());

  test('掲載データのIDと座標が妥当で、国内外の候補がある', () {
    final curatedPlaces = catalog.places;
    expect(curatedPlaces.length, greaterThanOrEqualTo(22));
    expect(curatedPlaces.map((place) => place.id).toSet().length,
        curatedPlaces.length);
    expect(
        curatedPlaces.every((place) =>
            place.position.latitude >= -90 &&
            place.position.latitude <= 90 &&
            place.position.longitude >= -180 &&
            place.position.longitude <= 180 &&
            place.nameJa.isNotEmpty &&
            place.nameEn.isNotEmpty &&
            place.teaserJa.isNotEmpty &&
            place.teaserEn.isNotEmpty),
        isTrue);
    expect(curatedPlaces.any((place) => place.position.latitude < 20), isTrue);
    expect(curatedPlaces.any((place) => place.position.latitude > 40), isTrue);
  });

  test('保存場所を除き、近い場所・同じテーマ・意外な場所を理由付きで選ぶ', () {
    final saved = SavedPlace.fromCurated(_catalog.first)
        .copyWith(status: VisitStatus.visited, isFavorite: true);
    final recommendations = recommendPlaces(
      catalog: _catalog,
      savedPlaces: {saved.id: saved},
      rotation: 0,
    );

    expect(recommendations.map((item) => item.place.id).toSet().length, 3);
    expect(recommendations.any((item) => item.place.id == saved.id), isFalse);
    expect(
      recommendations
          .singleWhere((item) => item.place.id == 'near_culture')
          .reason,
      RecommendationReason.nearSaved,
    );
    expect(
      recommendations
          .singleWhere((item) => item.place.id == 'same_theme_far')
          .reason,
      RecommendationReason.favoriteTheme,
    );
    expect(
      recommendations
          .singleWhere((item) => item.place.id == 'surprise_far')
          .reason,
      RecommendationReason.surprise,
    );
  });

  test('保存履歴がなくても候補を返し、全件保存済みなら空にする', () {
    final first = recommendPlaces(
      catalog: catalog.places,
      savedPlaces: const {},
      rotation: 0,
    );
    final next = recommendPlaces(
      catalog: catalog.places,
      savedPlaces: const {},
      rotation: 1,
    );
    expect(first.length, 3);
    expect(first.any((item) => item.reason == RecommendationReason.surprise),
        isTrue);
    expect(first.map((item) => item.place.id).toList(),
        isNot(next.map((item) => item.place.id).toList()));

    final allSaved = {
      for (final place in catalog.places)
        place.id: SavedPlace.fromCurated(place)
    };
    expect(
      recommendPlaces(catalog: catalog.places, savedPlaces: allSaved),
      isEmpty,
    );
  });

  test('自分で登録した場所の近さもおすすめ理由に使う', () {
    const custom = SavedPlace(
      id: 'custom',
      title: '自分の場所',
      position: LatLng(35, 139),
      isCustom: true,
      status: VisitStatus.wantToGo,
    );
    final result = recommendPlaces(
      catalog: _catalog.sublist(1),
      savedPlaces: {custom.id: custom},
    );
    expect(
      result.singleWhere((item) => item.place.id == 'near_culture').reason,
      RecommendationReason.nearSaved,
    );
  });

  test('お気に入り・行きたい・行ったの順に好みを反映し、理由を示す', () {
    final savedFavorite = _place('saved_favorite', PlaceTheme.town,
        position: const LatLng(35, 139));
    final savedWant = _place('saved_want', PlaceTheme.nature,
        position: const LatLng(35, 139));
    final savedVisited = _place('saved_visited', PlaceTheme.culture,
        position: const LatLng(35, 139));
    final places = [
      savedFavorite,
      savedWant,
      savedVisited,
      _place('favorite_candidate', PlaceTheme.town),
      _place('want_candidate', PlaceTheme.nature),
      _place('visited_candidate', PlaceTheme.culture),
    ];
    final saved = {
      savedFavorite.id:
          SavedPlace.fromCurated(savedFavorite).copyWith(isFavorite: true),
      savedWant.id: SavedPlace.fromCurated(savedWant)
          .copyWith(status: VisitStatus.wantToGo),
      savedVisited.id: SavedPlace.fromCurated(savedVisited)
          .copyWith(status: VisitStatus.visited),
    };

    final favoriteFirst = recommendPlaces(
      catalog: places,
      savedPlaces: saved,
      limit: 1,
    ).single;
    expect(favoriteFirst.place.id, 'favorite_candidate');
    expect(favoriteFirst.reason, RecommendationReason.favoriteTheme);

    saved[savedFavorite.id] = SavedPlace.fromCurated(savedFavorite);
    final wantFirst = recommendPlaces(
      catalog: places,
      savedPlaces: saved,
      limit: 1,
    ).single;
    expect(wantFirst.place.id, 'want_candidate');
    expect(wantFirst.reason, RecommendationReason.wantToGoTheme);

    saved[savedWant.id] = SavedPlace.fromCurated(savedWant);
    final visitedFirst = recommendPlaces(
      catalog: places,
      savedPlaces: saved,
      limit: 1,
    ).single;
    expect(visitedFirst.place.id, 'visited_candidate');
    expect(visitedFirst.reason, RecommendationReason.sharedTheme);
  });

  test('同じ地域・テーマへの偏りを避けて別地域の関連候補も選ぶ', () {
    const kyoto = TravelRegion(
      id: 'jp-kyoto',
      countryCode: 'JP',
      nameJa: '京都府',
      nameEn: 'Kyoto',
    );
    final favorite =
        _place('favorite', PlaceTheme.nature, position: const LatLng(35, 139));
    final secondFavorite = _place('second_favorite', PlaceTheme.nature,
        position: const LatLng(35, 139));
    final want =
        _place('want', PlaceTheme.culture, position: const LatLng(35, 139));
    final places = [
      favorite,
      secondFavorite,
      want,
      _place('tokyo_nature_1', PlaceTheme.nature,
          position: const LatLng(35.1, 139.1)),
      _place('tokyo_nature_2', PlaceTheme.nature,
          position: const LatLng(35.2, 139.2)),
      _place('kyoto_culture', PlaceTheme.culture,
          position: const LatLng(35, 135), region: kyoto),
    ];
    final result = recommendPlaces(
      catalog: places,
      savedPlaces: {
        favorite.id:
            SavedPlace.fromCurated(favorite).copyWith(isFavorite: true),
        secondFavorite.id:
            SavedPlace.fromCurated(secondFavorite).copyWith(isFavorite: true),
        want.id:
            SavedPlace.fromCurated(want).copyWith(status: VisitStatus.wantToGo),
      },
      limit: 2,
    );

    expect(result.first.place.id, 'tokyo_nature_1');
    expect(result.last.place.id, 'kyoto_culture');
    expect(result.last.reason, RecommendationReason.wantToGoTheme);
  });
}
