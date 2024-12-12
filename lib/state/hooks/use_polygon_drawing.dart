import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/foundation/modal_sheet.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/ui/screen/airport_list_screen.dart';

// 多角形を描画するHooks
final drawPolygonEnabledProvider = StateProvider<bool>((ref) => false);
final clearDrawingProvider = StateProvider<bool>((ref) => false);
final polygonSetProvider = StateProvider<Set<Polygon>>((ref) => {});

class PolygonDrawingController {
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(DragEndDetails) onPanEnd;
  final VoidCallback toggleDrawing;
  final VoidCallback clearPolygons;
  final dynamic polylineSet;

  PolygonDrawingController({
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.toggleDrawing,
    required this.clearPolygons,
    required this.polylineSet,
  });
}

PolygonDrawingController usePolygonDrawing(
  WidgetRef ref,
  Completer<GoogleMapController> controller,
  BuildContext context,
) {
  final polygonSet = ref.read(polygonSetProvider.notifier);
  final polylineSet = useState<HashSet<Polyline>>(HashSet<Polyline>());
  final latLngList = useState<List<LatLng>>([]);
  final lastXCoordinate = useState<int?>(null);
  final lastYCoordinate = useState<int?>(null);

  // PolylineとPolygonとLatLngをクリアする関数
  void clearPolygons() {
    polygonSet.state.clear();
    latLngList.value.clear();
    polylineSet.value.clear();
  }

  //「なぞる」の切り替えを行う関数
  void toggleDrawing() {
    clearPolygons();
    ref.read(mapScreenProvider.notifier).clearMarkers();
    ref.read(drawPolygonEnabledProvider.notifier).state =
        !ref.read(drawPolygonEnabledProvider);
  }

  // 触った部分の座標をもとに Polyline インスタンスを生成し、_polylineSet に追加する
  Future<void> onPanUpdate(DragUpdateDetails details) async {
    // 常に新しいポリゴンを描画する
    if (ref.read(clearDrawingProvider)) {
      ref.read(clearDrawingProvider.notifier).state = false;
      clearPolygons();
    }

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
      if (lastXCoordinate.value != null && lastYCoordinate.value != null) {
        var distance = math.sqrt(
            math.pow(xCoordinate - lastXCoordinate.value!, 2) +
                math.pow(yCoordinate - lastYCoordinate.value!, 2));
        // 点と点の距離が大きいかどうかをチェック
        if (distance > 80.0) return;
      }

      // 座標をキャッシュする
      lastXCoordinate.value = xCoordinate;
      lastYCoordinate.value = yCoordinate;

      final GoogleMapController mapController = await controller.future;
      final LatLng latLng = await mapController.getLatLng(
        // GoogleMapにおける座標に変換
        ScreenCoordinate(x: xCoordinate, y: yCoordinate),
      );

      // 新しいポイントをリストに追加する
      latLngList.value = [...latLngList.value, latLng];

      // ポリラインのセットを初期化
      polylineSet.value.removeWhere(
          (polyline) => polyline.polylineId.value == 'user_polyline');
      // 新しいポリラインを追加
      polylineSet.value.add(
        Polyline(
          polylineId: const PolylineId('user_polyline'),
          points: latLngList.value,
          width: 3,
          color: Colors.blue.withOpacity(0.8),
        ),
      );

      // なぞっている間ポリラインが描画され続ける
      polygonSet.state = {...polygonSet.state};
    }
  }

  // なぞり終えた際に Polygon インスタンスを生成し、_polygonSet に追加する。
  Future<void> onPanEnd(DragEndDetails details) async {
    // 最後にキャッシュされた座標をリセット
    lastXCoordinate.value = null;
    lastYCoordinate.value = null;

    // ポリゴンのセットを初期化
    polygonSet.state
        .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
    // 新しいポリゴンの追加
    polygonSet.state.add(
      Polygon(
        polygonId: const PolygonId('user_polygon'),
        points: latLngList.value,
        strokeWidth: 3,
        strokeColor: Colors.blue.withOpacity(0.8),
        fillColor: Colors.blue.withOpacity(0.2),
      ),
    );

    // ユーザーが描画したポリゴンのポイントを取得
    final polygonPoints = ref.read(polygonSetProvider).first.points;

    // 空港データ
    final airportMarkers = airportData;

    // 空港データの中からポリゴン内部のマーカーを取得
    final markersInsidePolygon = // マーカーのリストを保持
        getMarkersInsidePolygon(polygonPoints, airportMarkers);

    // マーカーをGoogleMap上に反映
    final newMarkers = markersInsidePolygon.map((marker) {
      return Marker(
          markerId: MarkerId(marker['id']),
          position: marker['position'],
          infoWindow: InfoWindow(
            title: marker['title'](context),
            snippet: marker['snippet'](context),
          ),
          onTap: () async {
            String apiKey = Env.key;
            final String title = marker['title'](context);

            // Place IDの取得
            final placeSearchUrl =
                'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$title&inputtype=textquery&fields=place_id&key=$apiKey';

            final placeSearchResponse =
                await http.get(Uri.parse(placeSearchUrl));
            final placeSearchData = jsonDecode(placeSearchResponse.body);

            if (placeSearchData['status'] != 'OK') {
              return;
            }

            final placeId = placeSearchData['candidates'][0]['place_id'];

            // Photo Referencesの取得
            final detailsUrl =
                'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';

            final detailsResponse = await http.get(Uri.parse(detailsUrl));
            final detailsData = jsonDecode(detailsResponse.body);

            if (detailsData['status'] != 'OK') {
              return;
            }

            final photos = detailsData['result']['photos'] as List<dynamic>?;

            // Photo URLsを生成
            final List<String> photoUrls = photos?.map((photo) {
                  final photoRef = photo['photo_reference'];
                  return 'https://maps.googleapis.com/maps/api/place/photo?maxheight=400&maxwidth=400&photoreference=$photoRef&key=$apiKey';
                }).toList() ??
                [];
            // ignore: use_build_context_synchronously
            showCustomBottomSheet(context, ref, null, title, photoUrls);
          });
    }).toSet();

    // StateNotifierを使用してマーカーを更新
    ref.read(mapScreenProvider.notifier).updateMarkers(newMarkers);

    // 描画状態を終了
    ref.read(drawPolygonEnabledProvider.notifier).state =
        !ref.read(drawPolygonEnabledProvider);
  }

  return PolygonDrawingController(
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    toggleDrawing: toggleDrawing,
    clearPolygons: clearPolygons,
    polylineSet: polylineSet.value,
  );
}

// ポリゴン内のマーカーを取得する関数
List<Map<String, dynamic>> getMarkersInsidePolygon(
    List<LatLng> polygonPoints, List<Map<String, dynamic>> markers) {
  // ray-casting algorithmを使用して点が多角形の内部にあるかどうかを判定
  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length; j++) {
      LatLng vertex1 = polygon[j];
      LatLng vertex2 = polygon[(j + 1) % polygon.length];

      // Check if the point lies on a horizontal line between vertex1 and vertex2
      if (((vertex1.latitude > point.latitude) !=
              (vertex2.latitude > point.latitude)) &&
          (point.longitude <
              (vertex2.longitude - vertex1.longitude) *
                      (point.latitude - vertex1.latitude) /
                      (vertex2.latitude - vertex1.latitude) +
                  vertex1.longitude)) {
        intersectCount++;
      }
    }
    // intersectionが奇数回の場合、点は多角形の内部にある
    return intersectCount % 2 == 1;
  }

  // 多角形の内部にあるかどうかを元にマーカーをフィルタリングする
  return markers
      .where((marker) => isPointInPolygon(marker['position'], polygonPoints))
      .toList();
}
// TODO: マーカーの内部判定のロジックを理解する
