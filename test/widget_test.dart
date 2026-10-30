import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';

void main() {
  testWidgets('検索条件が未入力なら案内を表示する', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SearchFlightScreen(),
        ),
      ),
    );

    await tester.tap(find.text('フライト検索'));
    await tester.pump();

    expect(find.text('全ての欄を埋めてください。'), findsOneWidget);
  });
}
