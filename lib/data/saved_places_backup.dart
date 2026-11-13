import 'dart:convert';

import 'package:ticket_app/model/saved_place.dart';

const savedPlacesBackupMaxBytes = 5 * 1024 * 1024;
const _backupFormat = 'travel-map-saved-places';
const _backupVersion = 1;

class SavedPlacesBackup {
  const SavedPlacesBackup(this.places);

  final List<SavedPlace> places;
}

String encodeSavedPlacesBackup(
    Iterable<SavedPlace> places, DateTime exportedAt) {
  final sorted = places.toList()..sort((a, b) => a.id.compareTo(b.id));
  return jsonEncode({
    'format': _backupFormat,
    'version': _backupVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'places': [for (final place in sorted) place.toJson()],
  });
}

SavedPlacesBackup decodeSavedPlacesBackup(String source) {
  final dynamic decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    throw const FormatException('Invalid JSON');
  }
  if (decoded is! Map ||
      decoded['format'] != _backupFormat ||
      decoded['version'] != _backupVersion ||
      decoded['places'] is! List) {
    throw const FormatException('Unsupported backup format');
  }

  final rawPlaces = decoded['places'] as List;
  if (rawPlaces.length > 10000) {
    throw const FormatException('Too many places');
  }
  final places = <SavedPlace>[];
  final ids = <String>{};
  for (final raw in rawPlaces) {
    if (raw is! Map || !_validPlace(raw)) {
      throw const FormatException('Invalid place');
    }
    final place = SavedPlace.fromJson(raw);
    if (!ids.add(place.id)) {
      throw const FormatException('Duplicate place ID');
    }
    places.add(place);
  }
  return SavedPlacesBackup(places);
}

bool _validPlace(Map<dynamic, dynamic> raw) {
  final id = raw['id'];
  final title = raw['title'];
  final latitude = raw['latitude'];
  final longitude = raw['longitude'];
  final note = raw['note'];
  return id is String &&
      id.trim().isNotEmpty &&
      id.length <= 200 &&
      title is String &&
      title.trim().isNotEmpty &&
      title.length <= 500 &&
      latitude is num &&
      latitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude is num &&
      longitude.isFinite &&
      longitude >= -180 &&
      longitude <= 180 &&
      VisitStatus.values.any((status) => status.name == raw['status']) &&
      raw['isFavorite'] is bool &&
      note is String &&
      note.length <= 10000 &&
      raw['isCustom'] is bool;
}
