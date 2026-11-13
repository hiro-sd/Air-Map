import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ticket_app/data/travel_catalog.dart';
import 'package:ticket_app/screen/root_screen.dart';
import 'package:ticket_app/state/saved_places_controller.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

final globalNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return globalNavigatorKey;
});

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('cacheBox');
  final savedPlacesBox = await Hive.openBox<dynamic>('savedPlaces');
  final travelCatalog = await loadTravelCatalog();
  runApp(ProviderScope(
    overrides: [
      savedPlacesBoxProvider.overrideWithValue(savedPlacesBox),
      travelCatalogProvider.overrideWithValue(travelCatalog),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: '旅の地図',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF79A889),
            brightness: Brightness.light,
          ),
          useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF79A889),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Root(),
    );
  }
}
