import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/functions/generate_markers.dart';
import 'package:ticket_app/state/map_state_controller.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_app/state/polygon_drawing_state_controller.dart';

// mapを表示するScreen
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapStateControllerProvider);
    final drawPolygonEnabled = ref.watch(drawPolygonEnabledProvider);
    final circles = ref.watch(circleProvider);
    Timer? debounce;

    void onCameraMove(CameraPosition position) {
      if (!mounted) return; // 画面が破棄されていたら処理しない
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 200), () {
        // 200msごとに1回だけ実行
        if (mounted) {
          ref
              .read(mapStateControllerProvider.notifier)
              .updateInitialCenter(position);
        }
      });
    }

    void showPolygonDrawingDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              drawPolygonEnabled
                  ? AppLocalizations.of(context)!.normal_mode
                  : AppLocalizations.of(context)!.polygon_drawing,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(drawPolygonEnabled
                ? AppLocalizations.of(context)!.cancel_polygon_drawing
                : AppLocalizations.of(context)!.polygon_drawing_description),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            //ドラッグ操作やピンチ操作などを付与する
            onPanUpdate: (drawPolygonEnabled)
                ? (details) => ref
                    .read(polygonDrawingStateControllerProvider.notifier)
                    .onPanUpdate(details, ref)
                : null, // ドラッグ操作で位置が変化したときにコール
            onPanEnd: (drawPolygonEnabled)
                ? (details) => ref
                    .read(polygonDrawingStateControllerProvider.notifier)
                    .onPanEnd(details, context, ref)
                : null,
            //ドラッグ操作やピンチ操作などを付与する
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: state.initialCenter.target,
                zoom: state.initialCenter.zoom,
              ), // 初期位置
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.normal,
              circles: circles,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: state.markers,
              onCameraMove: (position) {
                onCameraMove(position);
              },
              onMapCreated: (controller) {
                ref.read(mapStateControllerProvider.notifier).mapController =
                    controller;
                ref.read(mapStateControllerProvider.notifier).initializeMap();
                ref
                    .read(polygonDrawingStateControllerProvider.notifier)
                    .mapController = controller; // コントローラを保存
              },
              polygons:
                  ref.watch(polygonSetProvider), // マップ上に座標で囲まれた領域を多角形で表すもの
              polylines: ref.watch(polylineSetProvider), // マップ上に線を描くためのもの
            ), // ドラッグ操作が終了したときにコール
          ),
          Positioned(
              bottom: 160,
              right: 15,
              child: FloatingActionButton(
                  // polygon描画ボタン
                  heroTag: null,
                  shape: const CircleBorder(),
                  onPressed: () {
                    showPolygonDrawingDialog(context);
                    ref
                        .read(polygonDrawingStateControllerProvider.notifier)
                        .toggleDrawing(ref);
                  },
                  child: Icon(
                    drawPolygonEnabled ? Icons.pause : Icons.draw,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27.5,
                  ))),
          Positioned(
            // 地図に表示されるマーカーを切り替えるボタン
            bottom: 90,
            right: 15,
            child: FloatingActionButton(
              heroTag: null, // Heroアニメーションを無効にする
              shape: const CircleBorder(),
              onPressed: () {
                ref.read(polygonSetProvider).clear();
                ref.read(polylineSetProvider).clear();
                if (!state.showAllAirports) {
                  // 全国の空港に切り替え
                  ref.read(circleProvider.notifier).state.clear();
                  ref
                      .read(mapStateControllerProvider.notifier)
                      .switchAirports(generateMarkers(airportData), true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        AppLocalizations.of(context)!.show_airports,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                                  ref.read(circleProvider.notifier).state = {
                                    Circle(
                                      circleId: const CircleId(
                                          'currentLocationCircle'),
                                      center: LatLng(currentPosition.latitude,
                                          currentPosition.longitude),
                                      radius: sliderValue * 1000, // メートル単位
                                      strokeWidth: 3,
                                      strokeColor: Colors.blue
                                          .withValues(alpha: (255 * 0.2)),
                                      fillColor: Colors.blue
                                          .withValues(alpha: (255 * 0.8)),
                                    )
                                  };
                                  ref
                                      .read(mapStateControllerProvider.notifier)
                                      .fetchAirports(
                                          context, ref, sliderValue.toInt());
                                  Navigator.of(context).pop(); // モーダルを閉じる
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .show_nearby_airports(
                                                sliderValue.toInt()),
                                        style: const TextStyle(
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
              child: Icon(
                Icons.pin_drop,
                color: Theme.of(context).colorScheme.primary,
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
                ref
                    .read(mapStateControllerProvider.notifier)
                    .getCurrentLocation();
              },
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).colorScheme.primary,
                size: 27.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// gitの流れが参考になる(https://qiita.com/yukiyoshimura/items/7aa4a8f8db493ab97c2b)
