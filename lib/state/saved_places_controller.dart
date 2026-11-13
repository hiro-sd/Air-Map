import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ticket_app/model/saved_place.dart';

final savedPlacesBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box<dynamic>('savedPlaces'));

final savedPlacesProvider =
    StateNotifierProvider<SavedPlacesController, Map<String, SavedPlace>>(
        (ref) {
  return SavedPlacesController(ref.watch(savedPlacesBoxProvider));
});

class SavedPlacesController extends StateNotifier<Map<String, SavedPlace>> {
  SavedPlacesController(this._box) : super(_readSavedPlaces(_box));

  final Box<dynamic> _box;

  static Map<String, SavedPlace> _readSavedPlaces(Box<dynamic> box) {
    final places = <String, SavedPlace>{};
    for (final key in box.keys) {
      final value = box.get(key);
      if (value is! Map) continue;
      try {
        final place = SavedPlace.fromJson(value);
        places[place.id] = place;
      } catch (_) {
        // 古い・壊れた記録は読み飛ばし、他の保存場所を使えるようにする。
      }
    }
    return places;
  }

  Future<void> _save(SavedPlace place) async {
    await _box.put(place.id, place.toJson());
    state = {...state, place.id: place};
  }

  Future<void> setStatus(SavedPlace place, VisitStatus status) async {
    final current = state[place.id] ?? place;
    final nextStatus = current.status == status ? VisitStatus.none : status;
    final updated = current.copyWith(status: nextStatus);
    if (!updated.isCustom &&
        nextStatus == VisitStatus.none &&
        !updated.isFavorite &&
        updated.note.isEmpty) {
      await remove(place.id);
    } else {
      await _save(updated);
    }
  }

  Future<void> toggleFavorite(SavedPlace place) async {
    final current = state[place.id] ?? place;
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    if (!updated.isCustom &&
        updated.status == VisitStatus.none &&
        !updated.isFavorite &&
        updated.note.isEmpty) {
      await remove(place.id);
    } else {
      await _save(updated);
    }
  }

  Future<void> updateNote(SavedPlace place, String note) async {
    final current = state[place.id] ?? place;
    final updated = current.copyWith(note: note.trim());
    if (!updated.isCustom &&
        updated.status == VisitStatus.none &&
        !updated.isFavorite &&
        updated.note.isEmpty) {
      await remove(place.id);
    } else {
      await _save(updated);
    }
  }

  Future<void> addCustom(SavedPlace place) => _save(place);

  Future<void> remove(String id) async {
    await _box.delete(id);
    state = {...state}..remove(id);
  }
}
