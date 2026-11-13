import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/model/saved_place.dart';
import 'package:ticket_app/model/travel_place.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

Future<void> showTravelPlaceSheet(
  BuildContext context, {
  TravelPlace? curated,
  SavedPlace? custom,
}) {
  assert(curated != null || custom != null);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _TravelPlaceSheet(curated: curated, custom: custom),
  );
}

class _TravelPlaceSheet extends ConsumerWidget {
  const _TravelPlaceSheet({this.curated, this.custom});

  final TravelPlace? curated;
  final SavedPlace? custom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final seed = custom ?? SavedPlace.fromCurated(curated!);
    final saved = ref.watch(savedPlacesProvider)[seed.id] ?? seed;
    final title = curated?.name(context) ?? saved.title;
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    _iconFor(curated?.theme),
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (curated != null)
                        Text(
                          curated!.isUnexpected
                              ? l10n.unexpected_place
                              : l10n.familiar_place,
                          style: TextStyle(color: colors.primary),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (curated != null) ...[
              const SizedBox(height: 18),
              Text(curated!.teaser(context),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(curated!.description(context)),
            ],
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  avatar: const Icon(Icons.flag_outlined, size: 18),
                  label: Text(l10n.want_to_go),
                  selected: saved.status == VisitStatus.wantToGo,
                  onSelected: (_) => _runSave(
                    context,
                    () => ref
                        .read(savedPlacesProvider.notifier)
                        .setStatus(saved, VisitStatus.wantToGo),
                  ),
                ),
                FilterChip(
                  avatar: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(l10n.visited),
                  selected: saved.status == VisitStatus.visited,
                  onSelected: (_) => _runSave(
                    context,
                    () => ref
                        .read(savedPlacesProvider.notifier)
                        .setStatus(saved, VisitStatus.visited),
                  ),
                ),
                FilterChip(
                  avatar: const Icon(Icons.favorite_border, size: 18),
                  label: Text(l10n.favorite),
                  selected: saved.isFavorite,
                  onSelected: (_) => _runSave(
                    context,
                    () => ref
                        .read(savedPlacesProvider.notifier)
                        .toggleFavorite(saved),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.personal_note,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _editNote(context, ref, saved),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 68),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  saved.note.isEmpty ? l10n.write_note : saved.note,
                  style: TextStyle(
                    color: saved.note.isEmpty
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.local_only_note,
                style: Theme.of(context).textTheme.bodySmall),
            if (saved.isCustom) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () async {
                  final removed = await _runSave(
                      context,
                      () => ref
                          .read(savedPlacesProvider.notifier)
                          .remove(saved.id));
                  if (removed && context.mounted) Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.remove_place),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editNote(
      BuildContext context, WidgetRef ref, SavedPlace place) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: place.note);
    final note = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.personal_note),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(hintText: l10n.write_note),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.save_note),
          ),
        ],
      ),
    );
    controller.dispose();
    if (note != null && context.mounted) {
      await _runSave(context,
          () => ref.read(savedPlacesProvider.notifier).updateNote(place, note));
    }
  }

  Future<bool> _runSave(
      BuildContext context, Future<void> Function() operation) async {
    try {
      await operation();
      return true;
    } catch (_) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.save_failed)),
      );
      return false;
    }
  }
}

IconData _iconFor(PlaceTheme? theme) => switch (theme) {
      PlaceTheme.nature => Icons.park_rounded,
      PlaceTheme.culture => Icons.account_balance_rounded,
      PlaceTheme.town => Icons.holiday_village_rounded,
      PlaceTheme.art => Icons.palette_rounded,
      null => Icons.place_rounded,
    };
