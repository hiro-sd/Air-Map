import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:ticket_app/functions/generate_markers.dart';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:ticket_app/functions/get_markers_inside_polygon.dart';
import 'package:ticket_app/state/map_state_controller.dart';
import 'polygon_drawing_state.dart';

part 'polygon_drawing_state_controller.g.dart';

// // 多角形を描画するためのStateProvider
final drawPolygonEnabledProvider = StateProvider<bool>((ref) => false);
final polygonSetProvider = StateProvider<Set<Polygon>>((ref) => {});
final polylineSetProvider =
    StateProvider<HashSet<Polyline>>((ref) => HashSet<Polyline>());

@Riverpod(keepAlive: true)
class PolygonDrawingStateController extends _$PolygonDrawingStateController {
  @override
  PolygonDrawingState build() {
    return PolygonDrawingState(
      polygonSet: {},
      polylineSet: HashSet<Polyline>(),
      latLngList: [],
      lastXCoordinate: null,
      lastYCoordinate: null,
    );
  }

  GoogleMapController? mapController;
  List<LatLng> latLngList = [];
  int? lastXCoordinate;
  int? lastYCoordinate;
  HashSet<Polyline> polylineSet = HashSet<Polyline>();

  // 触った部分の座標をもとに Polyline インスタンスを生成し、_polylineSet に追加する
  Future<void> onPanUpdate(DragUpdateDetails details, WidgetRef ref) async {
    double? x, y;

    // Androidの場合、描画距離が明らかに短い
    // 恐らくGoogleMapsのバグ
    if (Platform.isAndroid) {
      x = details.localPosition.dx * 3;
      y = details.localPosition.dy * 3;
    } else if (Platform.isIOS) {
      x = details.localPosition.dx;
      y = details.localPosition.dy;
    }

    if (x != null && y != null) {
      int xCoordinate = x.round();
      int yCoordinate = y.round();

      // 2本指描画を防止するため
      if (lastXCoordinate != null && lastYCoordinate != null) {
        var distance = math.sqrt(math.pow(xCoordinate - lastXCoordinate!, 2) +
            math.pow(yCoordinate - lastYCoordinate!, 2));
        // 点と点の距離が大きいかどうかをチェック
        if (distance > 80.0) return;
      }

      // 座標をキャッシュする
      lastXCoordinate = xCoordinate;
      lastYCoordinate = yCoordinate;

      final mapController = this.mapController;

      if (mapController == null) {
        debugPrint("Error: GoogleMapController is null.");
        return;
      }

      try {
        final LatLng latLng = await mapController.getLatLng(
          // GoogleMapにおける座標に変換
          ScreenCoordinate(x: xCoordinate, y: yCoordinate),
        );

        // // 新しいポイントをリストに追加する
        latLngList = [...latLngList, latLng];

        final polylineSet = HashSet<Polyline>.of(ref.read(polylineSetProvider));
        // ポリラインのセットを初期化
        polylineSet.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');

        // 新しいポリラインを追加
        polylineSet.add(
          Polyline(
            polylineId: const PolylineId('user_polyline'),
            points: latLngList,
            width: 3,
            color: Colors.blue.withValues(alpha: 0.2),
          ),
        );

        // なぞっている間ポリラインが描画され続ける
        ref.read(polylineSetProvider.notifier).state = polylineSet;
      } catch (e) {
        debugPrint("Error in onPanUpdate: $e");
      }
    }
  }

  // なぞり終えた際に Polygon インスタンスを生成し、_polygonSet に追加する
  void onPanEnd(DragEndDetails details, BuildContext context, WidgetRef ref) {
    final polygonSet = ref.read(polygonSetProvider.notifier);
    // 最後にキャッシュされた座標をリセット
    lastXCoordinate = null;
    lastYCoordinate = null;
    if (latLngList.length < 3) return;

    // ポリゴンのセットを初期化
    polygonSet.state = {
      ...polygonSet.state
          .where((polygon) => polygon.polygonId.value != 'user_polygon'),
      Polygon(
        polygonId: const PolygonId('user_polygon'),
        points: latLngList,
        strokeWidth: 3,
        strokeColor: Colors.blue.withValues(alpha: 0.2),
        fillColor: Colors.blue.withValues(alpha: 0.8),
      ),
    };

    // ユーザーが描画したポリゴンのポイントを取得
    final polygonPoints = latLngList;

    // 空港データの中からポリゴン内部のマーカーを取得
    final markersInsidePolygon = // マーカーのリストを保持
        getMarkersInsidePolygon(polygonPoints, airportData);

    if (markersInsidePolygon.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.search_result,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Text(AppLocalizations.of(context)!.no_airport),
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.search_result,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Text(AppLocalizations.of(context)!.airport_in_the_area(
                      markersInsidePolygon.length.toString()) +
                  AppLocalizations.of(context)!.tap_marker),
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
    }

    // マーカーをGoogleMap上に反映
    ref
        .read(mapStateControllerProvider.notifier)
        .updateMarkers(generateMarkers(markersInsidePolygon));

    // 描画状態を終了
    ref.read(drawPolygonEnabledProvider.notifier).state =
        !ref.read(drawPolygonEnabledProvider);
  }

  //「なぞる」の切り替えを行う関数
  void toggleDrawing(WidgetRef ref) {
    clearPolygons(ref);
    ref.read(circleProvider.notifier).state = {};
    ref.read(drawPolygonEnabledProvider.notifier).state =
        !ref.read(drawPolygonEnabledProvider);
    ref.read(mapStateControllerProvider.notifier).clearMarkers();
  }

  // PolylineとPolygonとLatLngをクリアする関数
  void clearPolygons(WidgetRef ref) {
    final polygonSet = ref.read(polygonSetProvider.notifier);
    final polylineSet = ref.read(polylineSetProvider.notifier);
    polygonSet.state = {};
    latLngList.clear();
    polylineSet.state = HashSet<Polyline>();
    lastXCoordinate = null;
    lastYCoordinate = null;
  }
}
