import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/travel_place.dart';

const travelCatalogAsset = 'assets/data/travel_places.json';

final travelCatalogProvider = Provider<TravelCatalog>((ref) {
  throw StateError('TravelCatalog must be loaded before the app starts.');
});

Future<TravelCatalog> loadTravelCatalog() async => TravelCatalog.fromJsonString(
    await rootBundle.loadString(travelCatalogAsset));

class TravelCatalog {
  TravelCatalog._(this.places, this.regions, this._placesById);

  final List<TravelPlace> places;
  final Map<String, TravelRegion> regions;
  final Map<String, TravelPlace> _placesById;

  TravelPlace? byId(String id) => _placesById[id];

  factory TravelCatalog.fromJsonString(String source) {
    final data = _object(jsonDecode(source), 'catalog');
    if (data['schemaVersion'] != 1) {
      throw const FormatException('Unsupported travel catalog schema version');
    }

    final rawRegions = _list(data['regions'], 'regions');
    final regions = <String, TravelRegion>{};
    for (final raw in rawRegions) {
      final item = _object(raw, 'region');
      final id = _requiredString(item, 'id');
      if (!RegExp(r'^[a-z]{2}-[a-z0-9-]+$').hasMatch(id)) {
        throw FormatException('Invalid region id: $id');
      }
      if (regions.containsKey(id)) {
        throw FormatException('Duplicate region id: $id');
      }
      final countryCode = _requiredString(item, 'countryCode');
      if (!RegExp(r'^[A-Z]{2}$').hasMatch(countryCode) ||
          !id.startsWith('${countryCode.toLowerCase()}-')) {
        throw FormatException('Invalid country code for region: $id');
      }
      final name = _localized(item, 'name');
      regions[id] = TravelRegion(
        id: id,
        countryCode: countryCode,
        nameJa: name.ja,
        nameEn: name.en,
      );
    }

    final rawPlaces = _list(data['places'], 'places');
    final places = <TravelPlace>[];
    final placesById = <String, TravelPlace>{};
    for (final raw in rawPlaces) {
      final item = _object(raw, 'place');
      final id = _requiredString(item, 'id');
      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(id)) {
        throw FormatException('Invalid place id: $id');
      }
      if (placesById.containsKey(id)) {
        throw FormatException('Duplicate place id: $id');
      }
      final regionId = _requiredString(item, 'regionId');
      final region = regions[regionId];
      if (region == null) {
        throw FormatException('Unknown region $regionId for place $id');
      }
      final latitude = _coordinate(item, 'latitude', -90, 90, id);
      final longitude = _coordinate(item, 'longitude', -180, 180, id);
      final name = _localized(item, 'name');
      final teaser = _localized(item, 'teaser');
      final description = _localized(item, 'description');
      final themeName = _requiredString(item, 'theme');
      final theme = PlaceTheme.values.where((value) => value.name == themeName);
      if (theme.isEmpty) {
        throw FormatException('Unknown theme $themeName for place $id');
      }
      final isUnexpected = item['isUnexpected'];
      if (isUnexpected is! bool) {
        throw FormatException('isUnexpected must be a boolean for place $id');
      }
      final sourceInfo = _object(item['source'], 'source for place $id');
      final sourceName = _requiredString(sourceInfo, 'name');
      final sourceUrl = _requiredString(sourceInfo, 'url');
      final sourceUri = Uri.tryParse(sourceUrl);
      if (sourceUri == null ||
          sourceUri.scheme != 'https' ||
          sourceUri.host.isEmpty) {
        throw FormatException('Invalid source URL for place $id');
      }
      final reviewedOn = _requiredString(item, 'reviewedOn');
      final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(reviewedOn);
      final date = match == null ? null : DateTime.tryParse(reviewedOn);
      if (date == null ||
          date.year != int.parse(match!.group(1)!) ||
          date.month != int.parse(match.group(2)!) ||
          date.day != int.parse(match.group(3)!)) {
        throw FormatException('Invalid review date for place $id');
      }

      final place = TravelPlace(
        id: id,
        region: region,
        position: LatLng(latitude, longitude),
        nameJa: name.ja,
        nameEn: name.en,
        teaserJa: teaser.ja,
        teaserEn: teaser.en,
        descriptionJa: description.ja,
        descriptionEn: description.en,
        theme: theme.single,
        isUnexpected: isUnexpected,
        sourceName: sourceName,
        sourceUrl: sourceUrl,
        reviewedOn: reviewedOn,
      );
      places.add(place);
      placesById[id] = place;
    }

    return TravelCatalog._(
      List.unmodifiable(places),
      Map.unmodifiable(regions),
      Map.unmodifiable(placesById),
    );
  }
}

Map<String, dynamic> _object(Object? value, String field) {
  if (value is! Map<String, dynamic>) {
    throw FormatException('$field must be an object');
  }
  return value;
}

List<dynamic> _list(Object? value, String field) {
  if (value is! List<dynamic>) {
    throw FormatException('$field must be a list');
  }
  return value;
}

String _requiredString(Map<String, dynamic> item, String field) {
  final value = item[field];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$field must be a non-empty string');
  }
  return value;
}

({String ja, String en}) _localized(Map<String, dynamic> item, String field) {
  final value = _object(item[field], field);
  return (
    ja: _requiredString(value, 'ja'),
    en: _requiredString(value, 'en'),
  );
}

double _coordinate(Map<String, dynamic> item, String field, double min,
    double max, String placeId) {
  final value = item[field];
  if (value is! num || !value.isFinite || value < min || value > max) {
    throw FormatException('Invalid $field for place $placeId');
  }
  return value.toDouble();
}
