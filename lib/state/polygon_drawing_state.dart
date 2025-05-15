import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';

part 'polygon_drawing_state.freezed.dart';

@freezed
class PolygonDrawingState with _$PolygonDrawingState {
  const factory PolygonDrawingState({
    required Set<Polygon> polygonSet,
    required HashSet<Polyline> polylineSet,
    required List<LatLng> latLngList,
    int? lastXCoordinate,
    int? lastYCoordinate,
  }) = _PolygonDrawingState;
}
