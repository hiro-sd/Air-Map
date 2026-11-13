import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/data/curated_places.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/screen/travel_place_sheet.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

class MyMapScreen extends ConsumerStatefulWidget {
  const MyMapScreen({super.key, required this.onExploreRequested});

  final VoidCallback onExploreRequested;

  @override
  ConsumerState<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends ConsumerState<MyMapScreen> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    final controller = _controller;
    controller?.dispose();
    super.dispose();
  }

  void _openPlace(BuildContext context, SavedPlace place) {
    final curated = curatedPlaceById(place.id);
    showTravelPlaceSheet(context,
        curated: curated, custom: curated == null ? place : null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final places = ref.watch(savedPlacesProvider).values.toList()
      ..sort((a, b) {
        if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
        return a.title.compareTo(b.title);
      });

    if (places.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_rounded,
                  size: 68, color: Color(0xFF79A889)),
              const SizedBox(height: 16),
              Text(l10n.my_map_empty,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(l10n.my_map_empty_hint, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: widget.onExploreRequested,
                icon: const Icon(Icons.map_outlined),
                label: Text(l10n.explore_places),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: places.first.position, zoom: 9),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: {
              for (final place in places)
                Marker(
                  markerId: MarkerId('saved_${place.id}'),
                  position: place.position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    place.isFavorite
                        ? BitmapDescriptor.hueRose
                        : place.status == VisitStatus.visited
                            ? BitmapDescriptor.hueGreen
                            : BitmapDescriptor.hueAzure,
                  ),
                  onTap: () => _openPlace(context, place),
                ),
            },
            onMapCreated: (controller) => _controller = controller,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(l10n.my_map,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Text('${places.length}',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              final curated = curatedPlaceById(place.id);
              final title = curated?.name(context) ?? place.title;
              final status = switch (place.status) {
                VisitStatus.wantToGo => l10n.want_to_go,
                VisitStatus.visited => l10n.visited,
                VisitStatus.none => l10n.personal_note,
              };
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(place.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.place_rounded),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    place.note.isEmpty ? status : '$status · ${place.note}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _controller
                        ?.animateCamera(CameraUpdate.newLatLng(place.position));
                    _openPlace(context, place);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l10n.local_only_note,
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
