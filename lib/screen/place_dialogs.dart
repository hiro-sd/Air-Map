import 'package:flutter/material.dart';
import 'package:ticket_app/l10n/app_localizations.dart';

Future<String?> showAddPlaceDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final formKey = GlobalKey<FormState>();
  var placeName = '';
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.add_place),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(labelText: l10n.place_name),
          validator: (value) =>
              value == null || value.trim().isEmpty ? l10n.place_name : null,
          onSaved: (value) => placeName = value?.trim() ?? '',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              Navigator.of(dialogContext).pop(placeName);
            }
          },
          child: Text(l10n.add_place),
        ),
      ],
    ),
  );
}

Future<String?> showEditNoteDialog(BuildContext context, String initialNote) {
  final l10n = AppLocalizations.of(context)!;
  var noteText = initialNote;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.personal_note),
      content: TextFormField(
        initialValue: initialNote,
        onChanged: (value) => noteText = value,
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
          onPressed: () => Navigator.of(dialogContext).pop(noteText),
          child: Text(l10n.save_note),
        ),
      ],
    ),
  );
}
