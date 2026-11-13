import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart' show XTypeGroup, openFile;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticket_app/data/saved_places_backup.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/state/saved_places_controller.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('URLを開くことができませんでした: $url')),
    );
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _contactUrl = 'https://forms.gle/NkXVb3CU1JLB4pJa8';
  static const _shareUrl =
      'https://apps.apple.com/jp/app/air-map/id6742508414?l=ja';
  static const _termsUrl =
      'https://yummy-clownfish-5b7.notion.site/1a6c73c0d34080f3aac1e300589a4c97';
  static const _privacyPolicyUrl =
      'https://yummy-clownfish-5b7.notion.site/1a6c73c0d3408094b2c3d5eb18f6dab8';

  bool _busy = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _exportPlaces() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      final places = ref.read(savedPlacesProvider).values;
      final now = DateTime.now();
      final backup = encodeSavedPlacesBackup(places, now);
      final bytes = Uint8List.fromList(utf8.encode(backup));
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'application/json')],
        fileNameOverrides: [
          'my-map-backup-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.json',
        ],
        sharePositionOrigin:
            box == null ? null : box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (_) {
      if (mounted) _showMessage(l10n.backup_export_failed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importPlaces() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      const typeGroup = XTypeGroup(
        label: 'JSON',
        extensions: ['json'],
        mimeTypes: ['application/json'],
        uniformTypeIdentifiers: ['public.json'],
      );
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;
      if (await file.length() > savedPlacesBackupMaxBytes) {
        throw const FormatException('Backup file is too large');
      }
      final backup = decodeSavedPlacesBackup(await file.readAsString());
      if (!mounted) return;
      final existing = ref.read(savedPlacesProvider);
      final newCount = backup.places
          .where((place) => !existing.containsKey(place.id))
          .length;
      final duplicateCount = backup.places.length - newCount;
      var overwriteExisting = false;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.backup_import_title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(overwriteExisting
                    ? l10n.backup_import_replace_summary(backup.places.length)
                    : l10n.backup_import_summary(newCount, duplicateCount)),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.backup_replace_existing),
                  subtitle: Text(l10n.backup_replace_warning),
                  value: overwriteExisting,
                  onChanged: (value) =>
                      setDialogState(() => overwriteExisting = value),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: backup.places.isEmpty ||
                        (!overwriteExisting && newCount == 0)
                    ? null
                    : () => Navigator.pop(context, true),
                child: Text(l10n.backup_import_action),
              ),
            ],
          ),
        ),
      );
      if (confirmed != true || !mounted) return;
      final count = await ref
          .read(savedPlacesProvider.notifier)
          .importPlaces(backup.places, overwriteExisting: overwriteExisting);
      if (mounted) _showMessage(l10n.backup_import_success(count));
    } on FormatException {
      if (mounted) _showMessage(l10n.backup_invalid_file);
    } catch (_) {
      if (mounted) _showMessage(l10n.backup_import_failed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasPlaces = ref.watch(savedPlacesProvider).isNotEmpty;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          Text(l10n.backup_section_title,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l10n.backup_description),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.ios_share_rounded),
                  title: Text(l10n.backup_export_action),
                  subtitle: Text(l10n.backup_export_hint),
                  onTap: _busy || !hasPlaces ? null : _exportPlaces,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.file_open_rounded),
                  title: Text(l10n.backup_import_action),
                  subtitle: Text(l10n.backup_import_hint),
                  onTap: _busy ? null : _importPlaces,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: Text(l10n.contact_us),
            onTap: () => openUrl(context, _contactUrl),
          ),
          ListTile(
            title: Text(l10n.share_this_app),
            onTap: () => Share.share(_shareUrl),
          ),
          ListTile(
            title: Text(l10n.terms_of_use),
            onTap: () => openUrl(context, _termsUrl),
          ),
          ListTile(
            title: Text(l10n.privacy_policy),
            onTap: () => openUrl(context, _privacyPolicyUrl),
          ),
        ],
      ),
    );
  }
}
