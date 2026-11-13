import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/screen/place_dialogs.dart';

void main() {
  testWidgets('場所追加ダイアログを保存・再表示・キャンセルしても例外が出ない', (tester) async {
    String? result;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ja'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(builder: (context) {
          return TextButton(
            onPressed: () async => result = await showAddPlaceDialog(context),
            child: const Text('開く'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('開く'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'この場所を追加'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '  私の場所  ');
    await tester.tap(find.widgetWithText(FilledButton, 'この場所を追加'));
    await tester.pumpAndSettle();
    expect(result, '私の場所');
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('開く'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('メモ入力ダイアログを保存・再表示・キャンセルしても例外が出ない', (tester) async {
    String? result;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ja'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(builder: (context) {
          return TextButton(
            onPressed: () async =>
                result = await showEditNoteDialog(context, '前のメモ'),
            child: const Text('開く'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('開く'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '新しいメモ');
    await tester.tap(find.widgetWithText(FilledButton, 'メモを保存'));
    await tester.pumpAndSettle();
    expect(result, '新しいメモ');
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('開く'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(tester.takeException(), isNull);
  });
}
