import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/functions/geo_data_scan.dart';
import 'package:ticket_app/screen/map_screen.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/screen/settings_screen.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    List<BottomNavigationBarItem> items;

    // アイテムたち
    items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.map),
        label: AppLocalizations.of(context)!.map,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: AppLocalizations.of(context)!.search,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: AppLocalizations.of(context)!.settings,
      ),
    ];

    final bar = BottomNavigationBar(
      items: items, // アイテムたち
      selectedItemColor: Theme.of(context).colorScheme.primary,
      currentIndex: index, // インデックス
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    // 画面たち
    const pages = [
      MapScreen(),
      SearchFlightScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: index == 0
            ? Text(
                AppLocalizations.of(context)!.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : index == 1
                ? Text(
                    AppLocalizations.of(context)!.search,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
        leading: index == 0
            ? IconButton(
                icon: Icon(Icons.menu,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () {
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
                                        onPressed: () {
                                          // 選択された地方に基づいてポリゴンを描画
                                          loadAndDisplayAreaPolygon(
                                              areas[selectedIndex]['key']!,
                                              ref,
                                              context);
                                          Navigator.of(context)
                                              .pop(); // モーダルを閉じる
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              content: Text(
                                                AppLocalizations.of(context)!
                                                    .show_polygon_and_area(
                                                        areas[selectedIndex]
                                                            ['name']!),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
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
