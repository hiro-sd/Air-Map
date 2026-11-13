import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ticket_app/data/travel_catalog.dart';
import 'package:ticket_app/functions/select_visible_places.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TravelCatalog catalog;
  setUpAll(() async => catalog = await loadTravelCatalog());

  test('表示範囲から最大5件を選び、有名な場所と意外な場所を混ぜる', () {
    final bounds = LatLngBounds(
      southwest: const LatLng(35.55, 139.50),
      northeast: const LatLng(35.85, 139.90),
    );
    final selected = selectVisiblePlaces(
      catalog.places,
      bounds,
      const LatLng(35.70, 139.73),
    );

    expect(selected, isNotEmpty);
    expect(selected.length, lessThanOrEqualTo(5));
    expect(selected.every((place) => isInsideBounds(place.position, bounds)),
        isTrue);
    expect(selected.any((place) => place.isUnexpected), isTrue);
    expect(selected.any((place) => !place.isUnexpected), isTrue);
    expect(
        selectVisiblePlaces(catalog.places, bounds, const LatLng(35.70, 139.73),
                limit: 1)
            .length,
        1);
  });

  test('保存した分類・お気に入り・メモと追加場所を再読込できる', () async {
    final directory =
        await Directory.systemTemp.createTemp('travel-places-test-');
    Hive.init(directory.path);
    var box = await Hive.openBox<dynamic>('savedPlacesTest');
    try {
      final controller = SavedPlacesController(box);
      final curated = SavedPlace.fromCurated(catalog.places.first);
      await controller.setStatus(curated, VisitStatus.wantToGo);
      await controller.toggleFavorite(curated);
      await controller.updateNote(curated, '次の週末に行きたい');
      const custom = SavedPlace(
        id: 'custom_test',
        title: '自分で見つけた場所',
        position: LatLng(34.3, 134.0),
        status: VisitStatus.visited,
        isCustom: true,
      );
      await controller.addCustom(custom);

      await box.close();
      box = await Hive.openBox<dynamic>('savedPlacesTest');
      final reloaded = SavedPlacesController(box);
      expect(reloaded.state[curated.id]?.status, VisitStatus.wantToGo);
      expect(reloaded.state[curated.id]?.isFavorite, isTrue);
      expect(reloaded.state[curated.id]?.note, '次の週末に行きたい');
      expect(reloaded.state[custom.id]?.title, custom.title);
      expect(reloaded.state[custom.id]?.isCustom, isTrue);

      await reloaded.remove(custom.id);
      expect(SavedPlacesController(box).state.containsKey(custom.id), isFalse);
      controller.dispose();
      reloaded.dispose();
    } finally {
      await box.close();
      await directory.delete(recursive: true);
    }
  });
}
