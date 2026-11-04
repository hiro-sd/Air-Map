import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';
import 'package:ticket_app/state/map_state_controller.dart';

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

  testWidgets('同じ空港を出発地と目的地に選ぶと検索しない', (tester) async {
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

    final container = ProviderScope.containerOf(
        tester.element(find.byType(SearchFlightScreen)));
    final map = container.read(mapStateControllerProvider.notifier);
    map.updateSelectedDeparture('羽田空港');
    map.updateSelectedDestination('羽田空港');
    container.read(originCodeProvider.notifier).state = 'HND';
    container.read(destinationCodeProvider.notifier).state = 'HND';
    container.read(dateProvider.notifier).state = DateTime.now();
    container.read(passengerProvider.notifier).state = 1;
    await tester.pump();

    await tester.tap(find.text('フライト検索'));
    await tester.pump();

    expect(find.text('出発地と目的地に同じ空港は指定できません。'), findsOneWidget);
  });
}
