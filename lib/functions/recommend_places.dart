import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/model/travel_place.dart';

enum RecommendationReason { nearSaved, sharedTheme, surprise, featured }

class PlaceRecommendation {
  const PlaceRecommendation(this.place, this.reason);

  final TravelPlace place;
  final RecommendationReason reason;
}

/// 保存履歴から説明できる候補を選び、最後の1件に意外な場所を混ぜる。
/// データは端末内の厳選リストだけを使い、通信や個人情報の送信は行わない。
List<PlaceRecommendation> recommendPlaces({
  required List<TravelPlace> catalog,
  required Map<String, SavedPlace> savedPlaces,
  int limit = 3,
  int rotation = 0,
}) {
  if (limit <= 0 || catalog.isEmpty) return const [];

  final catalogById = {for (final place in catalog) place.id: place};
  final themeWeights = <PlaceTheme, int>{};
  for (final saved in savedPlaces.values) {
    final theme = catalogById[saved.id]?.theme;
    if (theme == null) continue;
    final weight = 1 +
        (saved.status == VisitStatus.visited ? 1 : 0) +
        (saved.isFavorite ? 2 : 0);
    themeWeights[theme] = (themeWeights[theme] ?? 0) + weight;
  }

  final candidates = <_Candidate>[];
  for (var index = 0; index < catalog.length; index++) {
    final place = catalog[index];
    if (savedPlaces.containsKey(place.id)) continue;

    var nearestKm = double.infinity;
    for (final saved in savedPlaces.values) {
      nearestKm = math.min(
        nearestKm,
        _distanceKm(saved.position, place.position),
      );
    }
    final nearBonus = nearestKm <= 30
        ? 6
        : nearestKm <= 100
            ? 4
            : 0;
    final themeWeight = themeWeights[place.theme] ?? 0;
    final reason = nearestKm <= 100
        ? RecommendationReason.nearSaved
        : themeWeight > 0
            ? RecommendationReason.sharedTheme
            : RecommendationReason.featured;
    candidates.add(_Candidate(
      place: place,
      reason: reason,
      score: nearBonus + themeWeight * 3,
      rotationOrder: (index - rotation) % catalog.length,
    ));
  }
  if (candidates.isEmpty) return const [];

  candidates.sort((a, b) {
    final scoreComparison = b.score.compareTo(a.score);
    return scoreComparison != 0
        ? scoreComparison
        : a.rotationOrder.compareTo(b.rotationOrder);
  });

  final selected = <PlaceRecommendation>[];
  final mainCount = limit == 1 ? 1 : limit - 1;
  while (selected.length < mainCount && selected.length < candidates.length) {
    final remaining = candidates.where(
      (candidate) =>
          !selected.any((item) => item.place.id == candidate.place.id),
    );
    final diverse = remaining.where(
      (candidate) => selected.every((item) =>
          _distanceKm(item.place.position, candidate.place.position) >= 180),
    );
    final candidate = diverse.isNotEmpty ? diverse.first : remaining.first;
    selected.add(PlaceRecommendation(candidate.place, candidate.reason));
  }

  if (selected.length < limit && limit > 1) {
    final unexpected = candidates
        .where((candidate) => candidate.place.isUnexpected)
        .where((candidate) =>
            !selected.any((item) => item.place.id == candidate.place.id))
        .toList()
      ..sort((a, b) => a.rotationOrder.compareTo(b.rotationOrder));
    final distant = unexpected.where((candidate) => selected.every((item) =>
        _distanceKm(item.place.position, candidate.place.position) >= 180));
    if (unexpected.isNotEmpty) {
      final candidate = distant.isNotEmpty ? distant.first : unexpected.first;
      selected.add(
          PlaceRecommendation(candidate.place, RecommendationReason.surprise));
    }
  }

  for (final candidate in candidates) {
    if (selected.length >= limit) break;
    if (!selected.any((item) => item.place.id == candidate.place.id)) {
      selected.add(PlaceRecommendation(candidate.place, candidate.reason));
    }
  }
  return selected;
}

class _Candidate {
  const _Candidate({
    required this.place,
    required this.reason,
    required this.score,
    required this.rotationOrder,
  });

  final TravelPlace place;
  final RecommendationReason reason;
  final int score;
  final int rotationOrder;
}

double _distanceKm(LatLng a, LatLng b) {
  const radiusKm = 6371.0;
  final latitudeDelta = _radians(b.latitude - a.latitude);
  final longitudeDelta = _radians(b.longitude - a.longitude);
  final sinLatitude = math.sin(latitudeDelta / 2);
  final sinLongitude = math.sin(longitudeDelta / 2);
  final haversine = sinLatitude * sinLatitude +
      math.cos(_radians(a.latitude)) *
          math.cos(_radians(b.latitude)) *
          sinLongitude *
          sinLongitude;
  return 2 * radiusKm * math.asin(math.sqrt(haversine.clamp(0, 1)));
}

double _radians(double degrees) => degrees * math.pi / 180;
