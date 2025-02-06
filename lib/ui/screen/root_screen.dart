import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/functions/geo_data_scan.dart';
import 'package:ticket_app/ui/screen/init_map_screen.dart';
import 'package:ticket_app/ui/screen/search_flight_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    // アイテムたち
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    final bar = BottomNavigationBar(
      items: items, // アイテムたち
      selectedItemColor: Colors.teal,
      currentIndex: index, // インデックス
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    // 画面たち
    const pages = [
      InitMapScreen(),
      SearchFlightScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: index == 0
            ? Text(
                AppLocalizations.of(context)!.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.search,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
        leading: index == 0
            ? IconButton(
                icon: Icon(Icons.menu,
                    color: Theme.of(context).colorScheme.onPrimary, size: 30),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
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
                          children: [
                            const SizedBox(height: 20),
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
                                              backgroundColor: Colors.white,
                                              duration:
                                                  const Duration(seconds: 2),
                                              content: Text(
                                                AppLocalizations.of(context)!
                                                    .show_polygon_and_area(
                                                        areas[selectedIndex]
                                                            ['name']!),
                                                style: const TextStyle(
                                                    color: Colors.black,
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
