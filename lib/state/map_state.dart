import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    required Set<Marker> markers,
    required Set<Marker> departureMarkers,
    required Set<Marker> destinationMarkers,
    required CameraPosition initialCenter,
    required bool showAllAirports,
    String? selectedDeparture,
    String? selectedDestination,
  }) = _MapState;
}
