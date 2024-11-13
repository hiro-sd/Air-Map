import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/airport_list.dart';
import 'dart:convert';
import 'package:ticket_app/search_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// MapScreenの状態を管理するStateNotifier
class MapScreenStateNotifier extends StateNotifier<Set<Marker>> {
  MapScreenStateNotifier() : super({});

  Position? currentPosition;
  GoogleMapController? mapController;

// GoogleMapのカメラを指定された位置に移動させる関数
  void moveCameraToPosition(LatLng position,
      {String? markerTitle, double zoom = 15}) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ));

      // その位置にマーカーを追加
      final newMarker = Marker(
        markerId: MarkerId(position.toString()), // 一意のIDを位置情報で生成
        position: position,
        infoWindow: InfoWindow(
          title: markerTitle ?? '選択された場所', // マーカーのタイトル
        ),
      );

      // 現在のマーカーセットに追加
      state = {newMarker}; // Riverpodの状態を更新
    }
  }

  // 現在の空港リストに切り替える
  void switchToAirports(Set<Marker> newAirports) {
    state = newAirports;
  }

  // マーカーをクリアする
  void clearMarkers() {
    state = {};
  }

  // 現在地の取得
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効か確認
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //print('位置情報サービスが無効です。');
      return;
    }

    // 位置情報のパーミッションを確認
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //print('位置情報のパーミッションが拒否されました。');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //print('位置情報のパーミッションが永久に拒否されています。');
      return;
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition();
      if (currentPosition != null && mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentPosition!.latitude, currentPosition!.longitude),
              zoom: 9,
            ),
          ),
        );
      }
    } catch (e) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(35.6895, 139.6917),
            zoom: 10,
          ),
        ),
      );
    }
  }

  // 半径50km以内の空港データの取得
  Future<void> fetchAirports() async {
    if (currentPosition == null) return;

    double lat = currentPosition!.latitude;
    double lng = currentPosition!.longitude;
    double radius = 500000; // 検索範囲(最大半径50km)
    String apiKey = 'AIzaSyDQ35E-oPP-Nkitj5vzXor6bSXQd82qmpU';
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=airport&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        Set<Marker> newMarkers = {};
        for (var result in results) {
          final Marker marker = Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(result['geometry']['location']['lat'],
                result['geometry']['location']['lng']),
            infoWindow: InfoWindow(
              title: result['name'],
              snippet: result['vicinity'],
            ),
          );
          newMarkers.add(marker);
        }
        state = newMarkers;
      } else {
        //print('Failed to load airports: ${response.statusCode}');
      }
    } catch (e) {
      //print('Failed to fetch airports: $e');
    }
  }
}

// Provider定義
final mapScreenProvider =
    StateNotifierProvider<MapScreenStateNotifier, Set<Marker>>(
  (ref) => MapScreenStateNotifier(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'air_ticket_app',
      home: MapScreen(),
    );
  }
}

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markers = ref.watch(mapScreenProvider);

    Future<void> openSearchWindow() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchWindow(),
        ),
      );

      if (result != null) {
        final lat = result['lat'];
        final lng = result['lng'];
        final placeName = result['name'];

        // GoogleMapをその位置に移動させる
        ref.read(mapScreenProvider.notifier).moveCameraToPosition(
              LatLng(lat, lng),
              markerTitle: placeName, // マーカーに表示するタイトル
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text(
          AppLocalizations.of(context)!.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(35.6895, 139.6917),
              zoom: 10,
            ), // 初期位置
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: markers, // Riverpodの状態を参照
            onMapCreated: (GoogleMapController controller) {
              ref.read(mapScreenProvider.notifier).mapController = controller;
              ref.read(mapScreenProvider.notifier).getCurrentLocation();
            },
          ),
          Center(
            child: Container(
              width: 300, // 見た目の円の大きさを調整
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.blue.withOpacity(0.8), width: 3),
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ),
          Center(
              child: Column(children: [
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
                  openSearchWindow();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.search_airport,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 100, 100, 100),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
              ),
            ),
          ])),
          Positioned(
            bottom: 30,
            right: 15,
            child: FloatingActionButton(
              heroTag: null, // Heroアニメーションを無効にする
              shape: const CircleBorder(),
              onPressed: () {
                ref.read(mapScreenProvider.notifier).getCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.my_location,
                size: 27.5,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 15,
            child: FloatingActionButton(
              heroTag: null, // Heroアニメーションを無効にする
              shape: const CircleBorder(),
              onPressed: () {
                if (markers != airports) {
                  ref
                      .read(mapScreenProvider.notifier)
                      .switchToAirports(airports); // 全国の空港に切り替え
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.switch_map,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          content:
                              Text(AppLocalizations.of(context)!.show_airports),
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.close),
                              onPressed: () {
                                Navigator.of(context).pop(); // ダイアログを閉じる
                              },
                            ),
                          ],
                        );
                      });
                } else {
                  ref
                      .read(mapScreenProvider.notifier)
                      .clearMarkers(); // マーカーをクリア
                  if (ref.read(mapScreenProvider.notifier).currentPosition !=
                      null) {
                    ref
                        .read(mapScreenProvider.notifier)
                        .fetchAirports(); // 現在地周辺の空港に戻す
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.switch_map,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content: Text(AppLocalizations.of(context)!
                                .show_nearby_airports),
                            actions: [
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context)!.close),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ダイアログを閉じる
                                },
                              ),
                            ],
                          );
                        });
                  }
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.local_airport,
                size: 27.5,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: ピンからも指定できるようにする。 (将来的には行き先も縁の内部で？？)
// TODO: 出発する空港をピンor円の内部の空港で指定する。
// TODO: 出発する空港と行き先を指定したら、適切な経路や値段を表示する。
// TODO: リファクタリング
// TODO: devブランチで作業し、終わったらmainブランチにマージする。
// gitの流れが参考になる(https://qiita.com/yukiyoshimura/items/7aa4a8f8db493ab97c2b)
