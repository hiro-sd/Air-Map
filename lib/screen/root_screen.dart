import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/functions/geo_data_scan.dart';
import 'package:ticket_app/screen/map_screen.dart';
import 'package:ticket_app/screen/discovery_screen.dart';
import 'package:ticket_app/screen/my_map_screen.dart';
import 'package:ticket_app/screen/airport_candidates_sheet.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/screen/settings_screen.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    // アイテムたち
    final items = [
      {
        'icon': Icons.explore_outlined,
        'label': AppLocalizations.of(context)!.discover
      },
      {
        'icon': Icons.bookmark_outline,
        'label': AppLocalizations.of(context)!.my_map
      },
      {
        'icon': Icons.flight_takeoff_outlined,
        'label': AppLocalizations.of(context)!.airports
      },
      {'icon': Icons.search, 'label': AppLocalizations.of(context)!.flights},
      {'icon': Icons.settings, 'label': AppLocalizations.of(context)!.settings},
    ]
        .map((item) => BottomNavigationBarItem(
              icon: Icon(item['icon'] as IconData),
              label: item['label'] as String,
            ))
        .toList();

    final bar = BottomNavigationBar(
      items: items, // アイテムたち
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 11,
      unselectedFontSize: 10,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      currentIndex: index, // インデックス
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    // 画面たち
    final pages = [
      DiscoveryScreen(onMyMapRequested: () {
        ref.read(indexProvider.notifier).state = 1;
      }),
      MyMapScreen(onExploreRequested: () {
        ref.read(indexProvider.notifier).state = 0;
      }),
      MapScreen(onSearchRequested: () {
        ref.read(indexProvider.notifier).state = 3;
      }),
      const SearchFlightScreen(),
      const SettingsScreen(),
    ];

    // タイトルたち
    final titles = [
      AppLocalizations.of(context)!.discover,
      AppLocalizations.of(context)!.my_map,
      AppLocalizations.of(context)!.title,
      AppLocalizations.of(context)!.flights,
      AppLocalizations.of(context)!.settings
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[index],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: index == 2
            ? IconButton(
                icon: Icon(Icons.menu,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  final rootContext = context;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      // リストに表示する地方名と対応する識別子
                      final List<Map<String, String>> areas = [
                        {
                          'name': AppLocalizations.of(context)!.hokkaido,
                          'key': 'hokkaido'
                        },
                        {
                          'name': AppLocalizations.of(context)!.tohoku,
                          'key': 'tohoku'
                        },
                        {
                          'name': AppLocalizations.of(context)!.kanto,
                          'key': 'kanto'
                        },
                        {
                          'name': AppLocalizations.of(context)!.chubu,
                          'key': 'chubu'
                        },
                        {
                          'name': AppLocalizations.of(context)!.kinki,
                          'key': 'kinki'
                        },
                        {
                          'name': AppLocalizations.of(context)!.chugoku,
                          'key': 'chugoku'
                        },
                        {
                          'name': AppLocalizations.of(context)!.shikoku,
                          'key': 'shikoku'
                        },
                        {
                          'name': AppLocalizations.of(context)!.kyushu,
                          'key': 'kyushu'
                        },
                        {
                          'name': AppLocalizations.of(context)!.okinawa,
                          'key': 'okinawa'
                        },
                      ];

                      int selectedIndex = 0; // Pickerの初期選択インデックス

                      return FractionallySizedBox(
                        heightFactor: 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              AppLocalizations.of(context)!.select_area,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 45, // 各項目の高さ
                                onSelectedItemChanged: (index) {
                                  selectedIndex = index;
                                  HapticFeedback.heavyImpact();
                                },
                                children: areas
                                    .map((area) => Center(
                                          child: Text(
                                            area['name']!,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // モーダルを閉じる
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.close,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                      width: 100,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // 選択された地方に基づいてポリゴンを描画
                                          Navigator.of(context)
                                              .pop(); // モーダルを閉じる
                                          ref
                                              .read(destinationPointProvider
                                                  .notifier)
                                              .state = null;
                                          final area =
                                              await loadAndDisplayAreaPolygon(
                                            areas[selectedIndex]['key']!,
                                            ref,
                                          );
                                          if (!rootContext.mounted) return;
                                          showAirportCandidatesSheet(
                                            context: rootContext,
                                            ref: ref,
                                            area: area,
                                            onSearchRequested: () {
                                              ref
                                                  .read(indexProvider.notifier)
                                                  .state = 3;
                                            },
                                          );
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.ok,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                ]),
                            const SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : null,
      ),
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}
