import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/env/env.dart';

// MapScreenの状態を管理するStateNotifier
class MapScreenStateNotifier extends StateNotifier<MapScreenState> {
  MapScreenStateNotifier()
      : super(MapScreenState(
          markers: {},
          circleCenter: const LatLng(35.6895, 139.6917), // 初期位置（東京）
          showAllAirports: false,
          selectedDestination: null,
          tmp: false,
        ));

  Position? currentPosition;
  GoogleMapController? mapController;
  String apiKey = Env.key;

  void toggleTmp() {
    state = state.copyWith(tmp: !state.tmp);
  }

  void updateMarkers(Set<Marker> newMarkers) {
    state = state.copyWith(markers: newMarkers);
  }

  void updateCircleCenter(LatLng newCenter) {
    state = state.copyWith(circleCenter: newCenter);
  }

// 全国の空港マーカーに切り替える
  void switchToAllAirports(Set<Marker> allAirports) {
    state = state.copyWith(
      markers: allAirports,
      showAllAirports: true,
    );
  }

  Future<void> switchToNearbyAirports(BuildContext context) async {
    await fetchAirports(context);
    state = state.copyWith(showAllAirports: false);
  }

  void updateSelectedDestination(String? destination) {
    state = state.copyWith(selectedDestination: destination);
  }

  // GoogleMapのカメラを指定された位置に移動させる関数
  void moveCameraToPosition(
      BuildContext context, LatLng position, String? markerTitle) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ));

      // その位置にマーカーを追加
      final newMarker = Marker(
        markerId: MarkerId(position.toString()), // 一意のIDを位置情報で生成
        position: position,
        infoWindow: InfoWindow(
          title: markerTitle ??
              AppLocalizations.of(context)!.selected_location, // マーカーのタイトル
        ),
      );

      // 現在のマーカーセットに追加
      state = state.copyWith(markers: {newMarker}); // Riverpodの状態を更新
    }
  }

  // マーカーをクリアする
  void clearMarkers() {
    state = state.copyWith(markers: {});
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
          CameraPosition(
            target: state.circleCenter,
            zoom: 9,
          ),
        ),
      );
    }
  }

  void showMarkerDetails(
      BuildContext context, dynamic placeName, List<String>? photoRefs) {
    List<String> photoUrls = photoRefs
            ?.map((photoRef) =>
                'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey')
            .toList() ??
        [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.set_destination,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  placeName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (photoUrls.isNotEmpty)
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      itemCount: photoUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          photoUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Text(AppLocalizations.of(context)!
                                .failed_to_load_image);
                          },
                        );
                      },
                    ),
                  )
                else
                  Text(AppLocalizations.of(context)!.no_photo), // 写真がない場合の表示
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // BottomSheetを閉じる
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateSelectedDestination(placeName);
                        !state.tmp ? toggleTmp() : null;
                        Navigator.pop(context); // BottomSheetを閉じる
                      },
                      child: Text(AppLocalizations.of(context)!.confirm),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 半径50km以内の空港データの取得
  Future<void> fetchAirports(BuildContext context) async {
    if (currentPosition == null) return;

    double lat = currentPosition!.latitude;
    double lng = currentPosition!.longitude;
    double radius = 500000; // 検索範囲(最大半径50km)
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
            onTap: () async {
              //nearbySearchではphoto_referenceが1つしか取得できないため、placeDetailsで写真を取得
              final placeId = result['place_id'];
              final detailsUrl =
                  'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';
              final detailsResponse = await http.get(Uri.parse(detailsUrl));
              final detailsData = jsonDecode(detailsResponse.body);
              if (detailsData['status'] != 'OK') {
                return;
              }
              final photos = detailsData['result']['photos'] as List<dynamic>?;
              final List<String> photoRefs = (photos)
                      ?.map((photo) => photo['photo_reference'] as String)
                      .toList() ??
                  [];

              showMarkerDetails(
                // ignore: use_build_context_synchronously
                context,
                result['name'],
                photoRefs,
              );
            },
          );
          newMarkers.add(marker);
        }
        state = state.copyWith(markers: newMarkers);
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
    StateNotifierProvider<MapScreenStateNotifier, MapScreenState>(
  (ref) => MapScreenStateNotifier(),
);

class MapScreenState {
  final Set<Marker> markers;
  final LatLng circleCenter;
  final bool showAllAirports;
  final String? selectedDestination;
  final bool tmp;

  MapScreenState({
    required this.markers,
    required this.circleCenter,
    required this.showAllAirports,
    this.selectedDestination,
    required this.tmp,
  });

  // 状態を部分的に更新するためのcopyWithメソッド
  MapScreenState copyWith({
    Set<Marker>? markers,
    LatLng? circleCenter,
    bool? showAllAirports,
    String? selectedDestination,
    bool? tmp,
  }) {
    return MapScreenState(
      markers: markers ?? this.markers,
      circleCenter: circleCenter ?? this.circleCenter,
      showAllAirports: showAllAirports ?? this.showAllAirports,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      tmp: tmp ?? this.tmp,
    );
  }
}
