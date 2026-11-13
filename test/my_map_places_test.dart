import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/functions/my_map_places.dart';
import 'package:ticket_app/model/saved_place.dart';

void main() {
  const wantToGo = SavedPlace(
    id: 'want',
    title: '行きたい場所',
    position: LatLng(35, 139),
    status: VisitStatus.wantToGo,
    isFavorite: true,
  );
  const visited = SavedPlace(
    id: 'visited',
    title: '行った場所',
    position: LatLng(43, 141),
    status: VisitStatus.visited,
  );
  const favoriteOnly = SavedPlace(
    id: 'favorite',
    title: 'お気に入りだけの場所',
    position: LatLng(34, 135),
    isFavorite: true,
  );
  final places = [wantToGo, visited, favoriteOnly];

  test('マイマップの分類はお気に入りと訪問状態を別々に判定する', () {
    expect(filterSavedPlaces(places, SavedPlaceFilter.all), places);
    expect(filterSavedPlaces(places, SavedPlaceFilter.wantToGo), [wantToGo]);
    expect(filterSavedPlaces(places, SavedPlaceFilter.visited), [visited]);
    expect(filterSavedPlaces(places, SavedPlaceFilter.favorites),
        [wantToGo, favoriteOnly]);
    expect(filterSavedPlaces([visited], SavedPlaceFilter.favorites), isEmpty);
  });

  test('保存地点が広く離れていても全地点を含む境界を作る', () {
    final bounds = savedPlaceBounds(places)!;
    expect(places.every((place) => bounds.contains(place.position)), isTrue);
    expect(bounds.southwest.latitude, lessThanOrEqualTo(34));
    expect(bounds.northeast.latitude, greaterThanOrEqualTo(43));
  });

  test('日付変更線をまたぐ地点は狭い側の経度範囲に収める', () {
    const acrossDateLine = [
      SavedPlace(id: 'east', title: '東', position: LatLng(35, 179)),
      SavedPlace(id: 'west', title: '西', position: LatLng(36, -179)),
    ];
    final bounds = savedPlaceBounds(acrossDateLine)!;
    expect(bounds.southwest.longitude, 179);
    expect(bounds.northeast.longitude, -179);
    expect(acrossDateLine.every((place) => bounds.contains(place.position)),
        isTrue);
  });

  test('同じ位置だけなら単一地点のズームを使う', () {
    expect(savedPlaceBounds([]), isNull);
    expect(savedPlaceBounds([wantToGo]), isNull);
    expect(savedPlaceBounds([wantToGo, wantToGo]), isNull);
  });
}
