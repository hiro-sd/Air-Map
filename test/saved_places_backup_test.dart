import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ticket_app/data/saved_places_backup.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const curated = SavedPlace(
    id: 'curated_test',
    title: '紹介スポット',
    position: LatLng(35.4, 139.5),
    status: VisitStatus.wantToGo,
    isFavorite: true,
    note: 'また行きたい',
  );
  const custom = SavedPlace(
    id: 'custom_test',
    title: '自分で見つけた場所',
    position: LatLng(-33.8, 151.2),
    status: VisitStatus.visited,
    note: '景色がよかった',
    isCustom: true,
  );

  test('書き出したファイルから全ての保存情報を復元できる', () {
    final content = encodeSavedPlacesBackup(
      [custom, curated],
      DateTime.utc(2026, 11, 13),
    );
    final backup = decodeSavedPlacesBackup(content);

    expect(backup.places.map((place) => place.id),
        ['curated_test', 'custom_test']);
    expect(backup.places.first.status, VisitStatus.wantToGo);
    expect(backup.places.first.isFavorite, isTrue);
    expect(backup.places.first.note, 'また行きたい');
    expect(backup.places.last.isCustom, isTrue);
    expect(backup.places.last.position, const LatLng(-33.8, 151.2));
    expect(backup.places.last.note, '景色がよかった');
  });

  test('形式違い・壊れた地点・重複IDを読み込まない', () {
    final content = encodeSavedPlacesBackup([curated], DateTime.utc(2026));
    final data = jsonDecode(content) as Map<String, dynamic>;
    expect(() => decodeSavedPlacesBackup('{'), throwsFormatException);

    expect(
      () => decodeSavedPlacesBackup(jsonEncode({...data, 'version': 2})),
      throwsFormatException,
    );
    expect(
      () => decodeSavedPlacesBackup(jsonEncode({
        ...data,
        'places': [
          {...curated.toJson(), 'latitude': 100},
        ],
      })),
      throwsFormatException,
    );
    expect(
      () => decodeSavedPlacesBackup(jsonEncode({
        ...data,
        'places': [curated.toJson(), curated.toJson()],
      })),
      throwsFormatException,
    );
  });

  test('通常は既存記録を守り、選択時にはバックアップで復元できる', () async {
    final directory = await Directory.systemTemp.createTemp('map-backup-test-');
    Hive.init(directory.path);
    final box = await Hive.openBox<dynamic>('backupTest');
    final controller = SavedPlacesController(box);
    try {
      await controller.addCustom(custom);
      final changed = curated.copyWith(note: '古いファイルの内容');
      final backup = decodeSavedPlacesBackup(
        encodeSavedPlacesBackup(
            [custom.copyWith(note: '上書きしたい内容'), changed], DateTime.utc(2026)),
      );

      expect(await controller.importPlaces(backup.places), 1);
      expect(controller.state[custom.id]?.note, '景色がよかった');
      expect(controller.state[curated.id]?.note, '古いファイルの内容');
      expect(await controller.importPlaces(backup.places), 0);

      expect(
          await controller.importPlaces(backup.places, overwriteExisting: true),
          2);
      expect(controller.state[custom.id]?.note, '上書きしたい内容');

      final reloaded = SavedPlacesController(box);
      expect(reloaded.state[custom.id]?.note, '上書きしたい内容');
      expect(reloaded.state[curated.id]?.isFavorite, isTrue);
      reloaded.dispose();
    } finally {
      controller.dispose();
      await box.close();
      await directory.delete(recursive: true);
    }
  });
}
