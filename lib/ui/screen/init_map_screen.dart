import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/foundation/geo_data_scan.dart';
import 'package:ticket_app/state/riverpod/polygon_drawing_notifier.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/ui/screen/airport_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 初めに表示するmapScreen
class InitMapScreen extends ConsumerStatefulWidget {
  const InitMapScreen({super.key});

  @override
  InitMapScreenState createState() => InitMapScreenState();
}

class InitMapScreenState extends ConsumerState<InitMapScreen> {
  double _iconRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapScreenProvider);
    final drawPolygonEnabled = ref.watch(drawPolygonEnabledProvider);
    final circles = ref.watch(circleProvider);

    return Scaffold(
      appBar: AppBar(
        // TODO: AppBarのUI整理
        toolbarHeight: 140,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leadingWidth: 30,
        title: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(10, 10))
              ],
            ),
            // 検索ウィンドウ
            child: TextButton(
              onPressed: () {
                ref
                    .read(mapScreenProvider.notifier)
                    .openSearchWindow(context, ref, 'tmpTakeoff', true);
              },
              child: Row(children: [
                const SizedBox(width: 7.5),
                Icon(
                  state.tmpTakeoff ? Icons.flight_takeoff : Icons.search,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tmpTakeoff
                        ? state.selectedDeparture != null
                            ? state.selectedDeparture!
                            : AppLocalizations.of(context)!
                                .search_departing_airport
                        : AppLocalizations.of(context)!
                            .search_departing_airport,
                    style: TextStyle(
                        color: state.tmpTakeoff
                            ? state.selectedDeparture != null
                                ? Colors.black
                                : const Color.fromARGB(255, 100, 100, 100)
                            : const Color.fromARGB(255, 100, 100, 100),
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                state.tmpTakeoff
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        color: const Color.fromARGB(255, 100, 100, 100),
                        padding: EdgeInsets.zero, // 中央に配置されるようにする
                        onPressed: () {
                          // TODO: 押した時にボタンなどで取得した全てのマーカーが消えてしまう
                          ref
                              .read(mapScreenProvider.notifier)
                              .clearSelectedDeparture();
                          state.departureMarkers.clear();
                          ref
                              .read(mapScreenProvider.notifier)
                              .updateMarkers(state.destinationMarkers);
                          ref
                              .read(mapScreenProvider.notifier)
                              .toggleTmpTakeoff();
                        },
                      )
                    : const SizedBox(width: 0),
              ]),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(10, 10))
              ],
            ),
            child: TextButton(
              // 検索フォーム
              onPressed: () {
                ref
                    .read(mapScreenProvider.notifier)
                    .openSearchWindow(context, ref, 'tmpLand', false);
              },
              child: Row(children: [
                const SizedBox(width: 7.5),
                Icon(
                  state.tmpLand ? Icons.flight_land : Icons.search,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tmpLand
                        ? state.selectedDestination != null
                            ? state.selectedDestination!
                            : AppLocalizations.of(context)!.search_airport
                        : AppLocalizations.of(context)!.search_airport,
                    style: TextStyle(
                        color: state.tmpLand
                            ? state.selectedDestination != null
                                ? Colors.black
                                : const Color.fromARGB(255, 100, 100, 100)
                            : const Color.fromARGB(255, 100, 100, 100),
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                state.tmpLand
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        color: const Color.fromARGB(255, 100, 100, 100),
                        padding: EdgeInsets.zero, // 中央に配置されるようにする
                        onPressed: () {
                          ref
                              .read(mapScreenProvider.notifier)
                              .clearSelectedDestination();
                          state.destinationMarkers.clear();
                          ref
                              .read(mapScreenProvider.notifier)
                              .updateMarkers(state.departureMarkers);
                          ref.read(mapScreenProvider.notifier).toggleTmpLand();
                        },
                      )
                    : const SizedBox(width: 0),
              ]),
            ),
          ),
        ]),
        leading: IconButton(
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
                  {'name': AppLocalizations.of(context)!.kanto, 'key': 'kanto'},
                  {'name': AppLocalizations.of(context)!.chubu, 'key': 'chubu'},
                  {'name': AppLocalizations.of(context)!.kinki, 'key': 'kinki'},
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 100,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // モーダルを閉じる
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
                                    Navigator.of(context).pop(); // モーダルを閉じる
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.white,
                                        duration: const Duration(seconds: 2),
                                        content: Text(
                                          AppLocalizations.of(context)!
                                              .show_polygon_and_area(
                                                  areas[selectedIndex]
                                                      ['name']!),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
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
        ),
        actions: [
          (state.tmpTakeoff || state.tmpLand)
              ? AnimatedRotation(
                  turns: _iconRotation,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                      icon: const Icon(Icons.swap_vert),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _iconRotation += 0.5; // 180度回転
                        });
                        ref
                            .read(mapScreenProvider.notifier)
                            .swapDepartureAndDestination();
                      }))
              : const SizedBox(height: 0),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
              //ドラッグ操作やピンチ操作などを付与する
              onPanUpdate: (drawPolygonEnabled)
                  ? (details) => ref
                      .read(polygonDrawingProvider.notifier)
                      .onPanUpdate(details, ref)
                  : null, // ドラッグ操作で位置が変化したときにコール
              onPanEnd: (drawPolygonEnabled)
                  ? (details) => ref
                      .read(polygonDrawingProvider.notifier)
                      .onPanEnd(details, context, ref)
                  : null, // ドラッグ操作が終了したときにコール
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.circleCenter,
                  zoom: 9,
                ), // 初期位置
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal,
                circles: circles,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                markers: state.markers, // Riverpodの状態を参照
                onMapCreated: (controller) {
                  ref.read(mapScreenProvider.notifier).mapController =
                      controller;
                  ref.read(mapScreenProvider.notifier).getCurrentLocation();
                  ref
                      .read(polygonDrawingProvider.notifier)
                      .controller
                      .complete(controller);
                },
                polygons:
                    ref.watch(polygonSetProvider), // マップ上に座標で囲まれた領域を多角形で表すもの
                polylines: ref.watch(polylineSetProvider), // マップ上に線を描くためのもの
              )),
          Positioned(
              bottom: 160,
              right: 15,
              child: FloatingActionButton(
                  // polygon描画ボタン
                  heroTag: null,
                  shape: const CircleBorder(),
                  onPressed: () {
                    showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                drawPolygonEnabled
                                    ? AppLocalizations.of(context)!.normal_mode
                                    : AppLocalizations.of(context)!
                                        .polygon_drawing,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content: Text(drawPolygonEnabled
                                ? AppLocalizations.of(context)!
                                    .cancel_polygon_drawing
                                : AppLocalizations.of(context)!
                                    .polygon_drawing_description),
                            actions: [
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.ok),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ダイアログを閉じる
                                },
                              ),
                            ],
                          );
                        });
                    ref
                        .read(polygonDrawingProvider.notifier)
                        .toggleDrawing(ref);
                  },
                  child: Icon(
                    drawPolygonEnabled ? Icons.pause : Icons.draw,
                    size: 27.5,
                  ))),
          Positioned(
            // 地図に表示されるマーカーを切り替えるボタン
            bottom: 90,
            right: 15,
            child: FloatingActionButton(
              heroTag: null, // Heroアニメーションを無効にする
              shape: const CircleBorder(),
              onPressed: () async {
                ref.read(polygonSetProvider).clear();
                ref.read(polylineSetProvider).clear();
                state.tmpLand
                    ? {
                        ref.read(mapScreenProvider.notifier).toggleTmpLand(),
                        ref
                            .read(mapScreenProvider.notifier)
                            .clearSelectedDestination(),
                      }
                    : null;
                state.tmpTakeoff
                    ? {
                        ref.read(mapScreenProvider.notifier).toggleTmpTakeoff(),
                        ref
                            .read(mapScreenProvider.notifier)
                            .clearSelectedDeparture(),
                      }
                    : null;
                if (!state.showAllAirports) {
                  ref.read(circleProvider.notifier).state.clear();
                  // 全国の空港に切り替え
                  ref
                      .read(mapScreenProvider.notifier)
                      .switchToAllAirports(generateMarkers(context, ref));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 1),
                      content: Text(
                        AppLocalizations.of(context)!.show_airports,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  // 現在地周辺の空港に切り替え
                  final List<double> customLabels = [
                    50,
                    100,
                    200,
                    400,
                    800,
                    1000
                  ];
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.switch_map,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content: Consumer(builder: (context, ref, child) {
                              final sliderValue =
                                  ref.watch(sliderValueProvider);
                              final sliderIndex =
                                  customLabels.indexOf(sliderValue);
                              return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .designate_radius,
                                    ),
                                    const SizedBox(height: 10),
                                    Slider(
                                      value: sliderIndex.toDouble(),
                                      min: 0,
                                      max: customLabels.length - 1,
                                      divisions: customLabels.length - 1,
                                      label: customLabels[sliderIndex]
                                          .toInt()
                                          .toString(),
                                      onChanged: (double value) {
                                        ref
                                            .read(sliderValueProvider.notifier)
                                            .state = customLabels[value.round()];
                                      },
                                    )
                                  ]);
                            }),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  final sliderValue =
                                      ref.read(sliderValueProvider);
                                  final currentPosition =
                                      await Geolocator.getCurrentPosition();
                                  final circle = Circle(
                                    circleId:
                                        const CircleId('currentLocationCircle'),
                                    center: LatLng(currentPosition.latitude,
                                        currentPosition.longitude),
                                    radius: sliderValue * 1000, // メートル単位
                                    strokeWidth: 3,
                                    strokeColor: Colors.blue.withOpacity(0.8),
                                    fillColor: Colors.blue.withOpacity(0.2),
                                  );
                                  ref.read(circleProvider.notifier).state = {
                                    circle
                                  };
                                  await ref
                                      .read(mapScreenProvider.notifier)
                                      .fetchAirports(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          ref,
                                          sliderValue.toInt());
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop(); // モーダルを閉じる
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.white,
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                        // ignore: use_build_context_synchronously
                                        AppLocalizations.of(context)!
                                            .show_nearby_airports(
                                                sliderValue.toInt()),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(AppLocalizations.of(context)!.ok),
                              )
                            ]);
                      });
                }
              },
              child: const Icon(
                Icons.local_airport,
                size: 27.5,
              ),
            ),
          ),
          Positioned(
            // 現在地に移動するボタン
            bottom: 20,
            right: 15,
            child: FloatingActionButton(
              heroTag: null, // Heroアニメーションを無効にする
              shape: const CircleBorder(),
              onPressed: () {
                ref.read(mapScreenProvider.notifier).getCurrentLocation();
              },
              child: const Icon(
                Icons.my_location,
                size: 27.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: ウィンドウ埋めた後のロジック (flight apiなど調べる)
// TODO: 出発する空港と行き先を指定したら、適切な経路や値段を表示する。
// TODO: GoogleMapを長押しでもピンを指して、目的地設定できるようにする。
// TODO: リファクタリング
// gitの流れが参考になる(https://qiita.com/yukiyoshimura/items/7aa4a8f8db493ab97c2b)
