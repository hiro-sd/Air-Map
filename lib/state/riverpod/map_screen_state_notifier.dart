import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/functions/geo_data_scan.dart';
import 'package:ticket_app/functions/modal_sheet.dart';
import 'package:ticket_app/state/riverpod/polygon_drawing_notifier.dart';
import 'package:ticket_app/functions/airport_list.dart';
import 'package:ticket_app/ui/screen/search_flight_screen.dart';
import 'package:ticket_app/ui/screen/search_window_screen.dart';

final sliderValueProvider = StateProvider<double>((ref) => 50.0);
final circleProvider = StateProvider<Set<Circle>>((ref) => {});

// MapScreenの状態を管理するStateNotifier
class MapScreenStateNotifier extends StateNotifier<MapScreenState> {
  MapScreenStateNotifier()
      : super(MapScreenState(
            markers: {},
            departureMarkers: {},
            destinationMarkers: {},
            initialCenter: const CameraPosition(
                target: LatLng(35.6895, 139.6917), zoom: 9), // 初期位置（東京）
            showAllAirports: false,
            selectedDeparture: null,
            selectedDestination: null,
            tmpTakeoff: false,
            tmpLand: false));

  Position? currentPosition;
  GoogleMapController? mapController;
  bool isFirstLoad = true;
  String apiKey = Env.googleMapsApiKey;

  // 初回のみ現在地を取得
  Future<void> initializeMap() async {
    if (isFirstLoad) {
      await getCurrentLocation();
      isFirstLoad = false; // 初回ロード後はfalseにする
    }
  }

  // 検索画面を開き、結果を取得する関数
  Future<void> openSearchWindow(
      BuildContext context, WidgetRef ref, String tmp, bool whichTap) async {
    final placeDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => whichTap
            ? SearchWindow(
                hintText:
                    AppLocalizations.of(context)!.search_departing_airport)
            : SearchWindow(
                hintText: AppLocalizations.of(context)!.search_airport),
      ),
    );

    if (placeDetails != null && context.mounted) {
      final destination = LatLng(placeDetails['lat'], placeDetails['lng']);
      final placeName = placeDetails['name'];
      final placePhoto = placeDetails['photo_reference'];
      ref.read(polygonSetProvider).clear();
      ref.read(polylineSetProvider).clear();
      ref.read(mapScreenProvider.notifier).clearMarkers();
      ref.read(circleProvider.notifier).state.clear();

      // GoogleMapをその位置に移動させる
      moveCameraToPosition(
        context,
        destination,
        placeName, // マーカーに表示するタイトル
        tmp,
      );

      // マーカーをタップした時の処理(ModalBottomSheetを表示)
      showMarkerDetails(
        context,
        ref,
        placeName,
        placePhoto,
        tmp,
      );
    }
  }

  void toggleTmpTakeoff() {
    state = state.copyWith(tmpTakeoff: !state.tmpTakeoff);
  }

  void toggleTmpLand() {
    state = state.copyWith(tmpLand: !state.tmpLand);
  }

  void updateMarkers(Set<Marker> newMarkers) {
    state = state.copyWith(markers: newMarkers);
  }

  void updateInitialCenter(CameraPosition newCenter) {
    state = state.copyWith(initialCenter: newCenter);
  }

  // 出発地と目的地を入れ替える
  void swapDepartureAndDestination(WidgetRef ref) {
    final currentOriginCode = ref.read(originCodeProvider);
    final currentDestinationCode = ref.read(destinationCodeProvider);
    ref.read(originCodeProvider.notifier).state = currentDestinationCode;
    ref.read(destinationCodeProvider.notifier).state = currentOriginCode;
    state = state.copyWith(
      selectedDeparture: state.selectedDestination,
      selectedDestination: state.selectedDeparture,
      departureMarkers: state.destinationMarkers,
      destinationMarkers: state.departureMarkers,
      tmpTakeoff: state.tmpLand,
      tmpLand: state.tmpTakeoff,
    );
  }

  // 全国の空港マーカーに切り替える
  void switchToAllAirports(Set<Marker> allAirports) {
    state = state.copyWith(
      markers: allAirports,
      showAllAirports: true,
    );
  }

  void updateSelectedDestination(String? destination) {
    state = state.copyWith(selectedDestination: destination);
  }

  void updateSelectedDeparture(String? departure) {
    state = state.copyWith(selectedDeparture: departure);
  }

  void clearSelectedDestination() {
    state = state.copyWith(selectedDestination: null);
  }

  void clearSelectedDeparture() {
    state = state.copyWith(selectedDeparture: null);
  }

  // GoogleMapのカメラを指定された位置に移動させる関数
  void moveCameraToPosition(
      BuildContext context, LatLng position, String? markerTitle, String tmp) {
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
      tmp == 'tmpTakeoff'
          ? state.departureMarkers = {newMarker}
          : state.destinationMarkers = {newMarker};
      final showedMarkers =
          state.departureMarkers.union(state.destinationMarkers);
      state = state.copyWith(markers: showedMarkers); // Riverpodの状態を更新
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
        final newCameraPosition = CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 9,
        );
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void showMarkerDetails(BuildContext context, WidgetRef ref, dynamic placeName,
      List<String>? photoRefs, String tmp) {
    List<String> photoUrls = photoRefs
            ?.map((photoRef) =>
                'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey')
            .toList() ??
        [];
    showCustomBottomSheet(context, ref, tmp, placeName, photoUrls);
  }

  // 指定半径内の空港データの取得
  Future<void> fetchAirports(
      BuildContext context, WidgetRef ref, int searchRadius) async {
    if (currentPosition == null) return;
    double lat = currentPosition!.latitude;
    double lng = currentPosition!.longitude;

    Set<Marker> newMarkers = {};
    for (var airport in airportData) {
      double airpoortLat = airport['position'].latitude;
      double airpoortLng = airport['position'].longitude;
      double distance =
          Geolocator.distanceBetween(lat, lng, airpoortLat, airpoortLng);
      if (distance <= (searchRadius * 1000) /*検索範囲*/) {
        final title = airport['title'](context);
        final snippet = airport['snippet'](context);

        final Marker marker = Marker(
          markerId: MarkerId(airport['id']),
          position: airport['position'],
          infoWindow: InfoWindow(
            title: title,
            snippet: snippet,
          ),
          onTap: () =>
              onMarkerTapped(airport, ref, context), // TODO: マーカータップ時のエラー解消
        );
        newMarkers.add(marker);
      }
    }
    state = state.copyWith(markers: newMarkers, showAllAirports: false);
  }
}

// Provider定義
final mapScreenProvider =
    StateNotifierProvider<MapScreenStateNotifier, MapScreenState>(
  (ref) => MapScreenStateNotifier(),
);

class MapScreenState {
  final Set<Marker> markers;
  Set<Marker> departureMarkers;
  Set<Marker> destinationMarkers;
  final CameraPosition initialCenter;
  final bool showAllAirports;
  final String? selectedDeparture;
  final String? selectedDestination;
  final bool tmpTakeoff;
  final bool tmpLand;

  MapScreenState({
    required this.markers,
    required this.departureMarkers,
    required this.destinationMarkers,
    required this.initialCenter,
    required this.showAllAirports,
    required this.selectedDeparture,
    required this.selectedDestination,
    required this.tmpTakeoff,
    required this.tmpLand,
  });

  // 状態を部分的に更新するためのcopyWithメソッド
  MapScreenState copyWith({
    Set<Marker>? markers,
    CameraPosition? initialCenter,
    bool? showAllAirports,
    String? selectedDeparture,
    String? selectedDestination,
    Set<Marker>? departureMarkers,
    Set<Marker>? destinationMarkers,
    bool? tmpTakeoff,
    bool? tmpLand,
  }) {
    return MapScreenState(
      markers: markers ?? this.markers,
      departureMarkers: departureMarkers ?? this.departureMarkers,
      destinationMarkers: destinationMarkers ?? this.destinationMarkers,
      initialCenter: initialCenter ?? this.initialCenter,
      showAllAirports: showAllAirports ?? this.showAllAirports,
      selectedDeparture: selectedDeparture ?? this.selectedDeparture,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      tmpTakeoff: tmpTakeoff ?? this.tmpTakeoff,
      tmpLand: tmpLand ?? this.tmpLand,
    );
  }
}
