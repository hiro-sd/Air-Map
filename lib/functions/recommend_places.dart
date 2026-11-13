import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/model/travel_place.dart';

enum RecommendationReason {
  nearSaved,
  favoriteTheme,
  wantToGoTheme,
  sharedTheme,
  surprise,
  featured,
}

class PlaceRecommendation {
  const PlaceRecommendation(this.place, this.reason);

  final TravelPlace place;
  final RecommendationReason reason;
}

/// 保存した分類を好みの強さとして扱い、近さ・テーマ・候補の多様性で選ぶ。
/// 「行った」だけでは好みを断定せず、強い信号は「お気に入り」と「行きたい」に置く。
List<PlaceRecommendation> recommendPlaces({
  required List<TravelPlace> catalog,
  required Map<String, SavedPlace> savedPlaces,
  int limit = 3,
  int rotation = 0,
}) {
  if (limit <= 0 || catalog.isEmpty) return const [];

  final catalogById = {for (final place in catalog) place.id: place};
  final themeSignals = <PlaceTheme, _ThemeSignal>{};
  final savedSignals = <_SavedSignal>[];
  for (final saved in savedPlaces.values) {
    final weight = _interestWeight(saved);
    if (weight == 0) continue;
    savedSignals.add(_SavedSignal(saved.position, weight));

    final theme = catalogById[saved.id]?.theme;
    if (theme == null) continue;
    final previous = themeSignals[theme];
    themeSignals[theme] = _ThemeSignal(
      math.min(10, (previous?.score ?? 0) + weight * 2),
      saved.isFavorite
          ? RecommendationReason.favoriteTheme
          : saved.status == VisitStatus.wantToGo
              ? previous?.reason == RecommendationReason.favoriteTheme
                  ? RecommendationReason.favoriteTheme
                  : RecommendationReason.wantToGoTheme
              : previous?.reason ?? RecommendationReason.sharedTheme,
    );
  }

  final candidates = <_Candidate>[];
  for (var index = 0; index < catalog.length; index++) {
    final place = catalog[index];
    if (savedPlaces.containsKey(place.id)) continue;

    final theme = themeSignals[place.theme];
    var nearScore = 0;
    for (final saved in savedSignals) {
      final distanceKm = _distanceKm(saved.position, place.position);
      final distanceScore = distanceKm <= 30
          ? 5
          : distanceKm <= 120
              ? 3
              : distanceKm <= 300
                  ? 1
                  : 0;
      nearScore = math.max(
          nearScore, (distanceScore * math.min(saved.weight, 4) / 3).ceil());
    }

    final themeScore = theme?.score ?? 0;
    candidates.add(_Candidate(
      place: place,
      reason: themeScore >= nearScore && themeScore > 0
          ? theme!.reason
          : nearScore > 0
              ? RecommendationReason.nearSaved
              : RecommendationReason.featured,
      score: themeScore > 0 ? themeScore + (nearScore / 2).ceil() : nearScore,
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
  final hasUnexpected =
      candidates.any((candidate) => candidate.place.isUnexpected);
  final mainCount = limit > 1 && hasUnexpected ? limit - 1 : limit;
  while (selected.length < mainCount && selected.length < candidates.length) {
    final remaining = candidates
        .where((candidate) =>
            !selected.any((item) => item.place.id == candidate.place.id))
        .toList();
    final candidate = _pickDiverse(remaining, selected);
    selected.add(PlaceRecommendation(candidate.place, candidate.reason));
  }

  if (selected.length < limit && limit > 1) {
    final unexpected = candidates
        .where((candidate) => candidate.place.isUnexpected)
        .where((candidate) =>
            !selected.any((item) => item.place.id == candidate.place.id))
        .toList()
      ..sort((a, b) => a.rotationOrder.compareTo(b.rotationOrder));
    if (unexpected.isNotEmpty) {
      final candidate =
          _pickDiverse(unexpected, selected, useScoreThreshold: false);
      selected.add(
          PlaceRecommendation(candidate.place, RecommendationReason.surprise));
    }
  }

  while (selected.length < limit && selected.length < candidates.length) {
    final remaining = candidates
        .where((candidate) =>
            !selected.any((item) => item.place.id == candidate.place.id))
        .toList();
    final candidate = _pickDiverse(remaining, selected);
    selected.add(PlaceRecommendation(candidate.place, candidate.reason));
  }
  return selected;
}

_Candidate _pickDiverse(
  List<_Candidate> candidates,
  List<PlaceRecommendation> selected, {
  bool useScoreThreshold = true,
}) {
  if (selected.isEmpty) return candidates.first;
  final eligible = useScoreThreshold
      ? candidates
          .where((candidate) => candidate.score >= candidates.first.score * .35)
          .toList()
      : candidates;
  for (final criterion in <bool Function(_Candidate)>[
    (candidate) => selected.every((item) =>
        item.place.region.id != candidate.place.region.id &&
        item.place.theme != candidate.place.theme),
    (candidate) => selected
        .every((item) => item.place.region.id != candidate.place.region.id),
    (candidate) =>
        selected.every((item) => item.place.theme != candidate.place.theme),
  ]) {
    for (final candidate in eligible) {
      if (criterion(candidate)) return candidate;
    }
  }
  return eligible.first;
}

int _interestWeight(SavedPlace saved) {
  final statusWeight = switch (saved.status) {
    VisitStatus.wantToGo => 3,
    VisitStatus.visited => 1,
    VisitStatus.none => 0,
  };
  return statusWeight + (saved.isFavorite ? 4 : 0);
}

class _ThemeSignal {
  const _ThemeSignal(this.score, this.reason);

  final int score;
  final RecommendationReason reason;
}

class _SavedSignal {
  const _SavedSignal(this.position, this.weight);

  final LatLng position;
  final int weight;
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
