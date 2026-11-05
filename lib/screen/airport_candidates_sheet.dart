import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:ticket_app/functions/generate_markers.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/airport_candidate.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';
import 'package:ticket_app/state/map_state_controller.dart';

Future<void> showAirportCandidatesSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AirportSearchArea area,
  required VoidCallback onSearchRequested,
}) async {
  final candidates = findAirportCandidates(area, airportData);
  ref.read(mapStateControllerProvider.notifier).updateMarkers(
        generateMarkers(
            candidates.map((candidate) => candidate.airport).toList()),
      );

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext)!;
      final inside =
          candidates.where((candidate) => candidate.isInside).toList();
      final nearby =
          candidates.where((candidate) => !candidate.isInside).toList();

      Widget candidateTile(AirportCandidate candidate) {
        final name = candidate.airport['title'](sheetContext) as String;
        return ListTile(
          leading: const Icon(Icons.local_airport),
          title: Text('$name (${candidate.code})'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${area.isPoint ? l10n.straight_line_from_point : l10n.straight_line_from_area_center}: ${candidate.distanceKm.round()} km',
              ),
              Text(l10n.route_status_unchecked),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ref
                .read(mapStateControllerProvider.notifier)
                .updateSelectedDestination(name);
            ref.read(destinationCodeProvider.notifier).state = candidate.code;
            Navigator.of(sheetContext).pop();
            onSearchRequested();
          },
        );
      }

      return FractionallySizedBox(
        heightFactor: 0.72,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.airport_candidates,
                        style: Theme.of(sheetContext).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(l10n.candidate_distance_note,
                        style: Theme.of(sheetContext).textTheme.bodySmall),
                  ],
                ),
              ),
              Expanded(
                child: candidates.isEmpty
                    ? Center(child: Text(l10n.no_airport_candidates))
                    : ListView(
                        children: [
                          if (inside.isNotEmpty) ...[
                            _sectionHeading(
                                sheetContext, l10n.airports_in_area),
                            ...inside.map(candidateTile),
                          ],
                          if (nearby.isNotEmpty) ...[
                            _sectionHeading(
                                sheetContext, l10n.airports_near_area),
                            ...nearby.map(candidateTile),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _sectionHeading(BuildContext context, String title) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
