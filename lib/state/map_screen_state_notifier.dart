import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:ticket_app/functions/generate_markers.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';

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
            selectedDestination: null));

  Position? currentPosition;
  GoogleMapController? mapController;
  bool isFirstLoad = true;
  String apiKey = Env.googleMapsApiKey;

  // 初回のみ現在地を取得
  Future<void> initializeMap() async {
    if (!isFirstLoad) return;
    isFirstLoad = false; // 初回ロード後はfalseにする
    await getCurrentLocation();
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
    );
  }

  // 空港マーカーを切り替える
  void switchAirports(Set<Marker> airportList, bool showAllAirports) {
    state = state.copyWith(
      markers: airportList,
      showAllAirports: showAllAirports,
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
      debugPrint("Error getting location: $e");
    }
  }

  // 指定半径内の空港データの取得
  void fetchAirports(BuildContext context, WidgetRef ref, int searchRadius) {
    if (currentPosition == null) return;

    double lat = currentPosition!.latitude;
    double lng = currentPosition!.longitude;

    switchAirports(
        generateMarkers(airportData.where((airport) {
          double distance = Geolocator.distanceBetween(lat, lng,
              airport['position'].latitude, airport['position'].longitude);
          return distance <= (searchRadius * 1000);
        }).toList()),
        false);
  }
}

// Provider定義
final mapScreenProvider =
    StateNotifierProvider<MapScreenStateNotifier, MapScreenState>(
  (ref) => MapScreenStateNotifier(),
);

class MapScreenState {
  final Set<Marker> markers;
  final Set<Marker> departureMarkers;
  final Set<Marker> destinationMarkers;
  final CameraPosition initialCenter;
  final bool showAllAirports;
  final String? selectedDeparture;
  final String? selectedDestination;

  MapScreenState({
    required this.markers,
    required this.departureMarkers,
    required this.destinationMarkers,
    required this.initialCenter,
    required this.showAllAirports,
    required this.selectedDeparture,
    required this.selectedDestination,
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
  }) =>
      MapScreenState(
        markers: markers ?? this.markers,
        departureMarkers: departureMarkers ?? this.departureMarkers,
        destinationMarkers: destinationMarkers ?? this.destinationMarkers,
        initialCenter: initialCenter ?? this.initialCenter,
        showAllAirports: showAllAirports ?? this.showAllAirports,
        selectedDeparture: selectedDeparture ?? this.selectedDeparture,
        selectedDestination: selectedDestination ?? this.selectedDestination,
      );
}
