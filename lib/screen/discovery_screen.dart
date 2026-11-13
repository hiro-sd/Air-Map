import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/data/travel_catalog.dart';
import 'package:ticket_app/functions/place_marker_icons.dart';
import 'package:ticket_app/functions/recommend_places.dart';
import 'package:ticket_app/functions/select_visible_places.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/model/travel_place.dart';
import 'package:ticket_app/screen/place_dialogs.dart';
import 'package:ticket_app/screen/travel_place_sheet.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

final discoveryCameraProvider = StateProvider<CameraPosition>((ref) =>
    const CameraPosition(target: LatLng(35.7000, 139.7300), zoom: 10.5));

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key, required this.onMyMapRequested});

  final VoidCallback onMyMapRequested;

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  GoogleMapController? _controller;
  late CameraPosition _camera;
  LatLngBounds? _bounds;
  List<TravelPlace> _visiblePlaces = const [];
  Map<PlaceTheme, BitmapDescriptor> _icons = const {};
  bool _showRecommendations = false;

  static const _mapStyle = '''[
    {"featureType":"poi","stylers":[{"visibility":"off"}]},
    {"featureType":"transit","stylers":[{"visibility":"off"}]},
    {"featureType":"landscape","stylers":[{"color":"#F7F5EF"}]},
    {"featureType":"water","stylers":[{"color":"#CBE9E3"}]}
  ]''';

  @override
  void initState() {
    super.initState();
    _camera = ref.read(discoveryCameraProvider);
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    try {
      final icons = await createPlaceMarkerIcons();
      if (mounted) setState(() => _icons = icons);
    } catch (_) {
      // カスタム画像を作れない端末では標準ピンを使う。
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    controller?.dispose();
    super.dispose();
  }

  Future<void> _refreshVisiblePlaces() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      final bounds = await controller.getVisibleRegion();
      if (!mounted) return;
      setState(() {
        _bounds = bounds;
        _visiblePlaces = selectVisiblePlaces(
          ref.read(travelCatalogProvider).places,
          bounds,
          _camera.target,
        );
      });
      ref.read(discoveryCameraProvider.notifier).state = _camera;
    } catch (_) {
      // 地図が描画される前は onCameraIdle で再試行する。
    }
  }

  Future<void> _addPersonalPlace(LatLng position) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showAddPlaceDialog(context);
    if (name == null || !mounted) return;

    final place = SavedPlace(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      title: name,
      position: position,
      status: VisitStatus.wantToGo,
      isCustom: true,
    );
    try {
      await ref.read(savedPlacesProvider.notifier).addCustom(place);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.place_saved)));
      await showTravelPlaceSheet(context, custom: place);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.save_failed)));
    }
  }

  Future<void> _openRecommendation(TravelPlace place) async {
    setState(() => _showRecommendations = false);
    try {
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(place.position, 10.5),
      );
    } catch (_) {
      // 地図の再生成中でも場所の紹介は開けるようにする。
    }
    if (mounted) await showTravelPlaceSheet(context, curated: place);
  }

  String _recommendationLabel(
          AppLocalizations l10n, RecommendationReason reason) =>
      switch (reason) {
        RecommendationReason.nearSaved => l10n.recommendation_near_saved,
        RecommendationReason.favoriteTheme =>
          l10n.recommendation_favorite_theme,
        RecommendationReason.wantToGoTheme => l10n.recommendation_want_theme,
        RecommendationReason.sharedTheme => l10n.recommendation_shared_theme,
        RecommendationReason.surprise => l10n.recommendation_surprise,
        RecommendationReason.featured => l10n.recommendation_featured,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final saved = ref.watch(savedPlacesProvider);
    final catalog = ref.watch(travelCatalogProvider);
    final recommendations = recommendPlaces(
      catalog: catalog.places,
      savedPlaces: saved,
      rotation: DateTime.now().difference(DateTime(2020)).inDays,
    );
    final cardCount =
        _showRecommendations ? recommendations.length : _visiblePlaces.length;
    final colors = Theme.of(context).colorScheme;
    final customMarkers = saved.values
        .where((place) => place.isCustom)
        .where((place) =>
            _bounds == null || isInsideBounds(place.position, _bounds!))
        .take(12);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _camera,
          style: _mapStyle,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          markers: {
            for (final place in _visiblePlaces)
              Marker(
                markerId: MarkerId('place_${place.id}'),
                position: place.position,
                icon: _icons[place.theme] ??
                    BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRose),
                onTap: () => showTravelPlaceSheet(context, curated: place),
              ),
            for (final place in customMarkers)
              Marker(
                markerId: MarkerId(place.id),
                position: place.position,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet),
                onTap: () => showTravelPlaceSheet(context, custom: place),
              ),
          },
          onMapCreated: (controller) {
            _controller = controller;
            unawaited(_refreshVisiblePlaces());
          },
          onCameraMove: (position) => _camera = position,
          onCameraIdle: () => unawaited(_refreshVisiblePlaces()),
          onLongPress: _addPersonalPlace,
        ),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Color(0x22000000), blurRadius: 14)
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: Color(0xFFDD8F70)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(l10n.discover_hint)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.97),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Color(0x25000000), blurRadius: 18)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            _showRecommendations
                                ? saved.isEmpty
                                    ? l10n.today_discoveries
                                    : l10n.recommended_places
                                : l10n.nearby_places,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () => setState(
                            () => _showRecommendations = !_showRecommendations),
                        child: Text(_showRecommendations
                            ? l10n.show_nearby_places
                            : l10n.show_recommendations),
                      ),
                      IconButton(
                        tooltip: l10n.my_map,
                        onPressed: widget.onMyMapRequested,
                        icon: const Icon(Icons.bookmark_outline),
                      ),
                    ],
                  ),
                  if (cardCount == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(_showRecommendations
                          ? l10n.no_recommendations
                          : l10n.no_curated_places),
                    )
                  else
                    SizedBox(
                      height: 118,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: cardCount,
                        separatorBuilder: (_, __) => const SizedBox(width: 9),
                        itemBuilder: (context, index) {
                          if (_showRecommendations) {
                            final item = recommendations[index];
                            return _PlaceCard(
                              place: item.place,
                              reason: _recommendationLabel(l10n, item.reason),
                              onTap: () => _openRecommendation(item.place),
                            );
                          }
                          final place = _visiblePlaces[index];
                          return _PlaceCard(
                            place: place,
                            onTap: () =>
                                showTravelPlaceSheet(context, curated: place),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(l10n.curated_note,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap, this.reason});

  final TravelPlace place;
  final VoidCallback onTap;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 188,
      child: Material(
        color: place.isUnexpected
            ? const Color(0xFFFFF0E6)
            : const Color(0xFFEAF5F0),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                        place.isUnexpected
                            ? Icons.auto_awesome_rounded
                            : Icons.place_rounded,
                        size: 18,
                        color: colors.primary),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        reason ??
                            (place.isUnexpected
                                ? l10n.unexpected_place
                                : l10n.familiar_place),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(place.name(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(place.teaser(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
