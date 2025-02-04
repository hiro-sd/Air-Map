import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/env/env.dart';
import 'package:ticket_app/functions/modal_sheet.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/functions/airport_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 多角形を描画するためのStateProvider
final drawPolygonEnabledProvider = StateProvider<bool>((ref) => false);
final polygonSetProvider = StateProvider<Set<Polygon>>((ref) => {});
final polylineSetProvider =
    StateProvider<HashSet<Polyline>>((ref) => HashSet<Polyline>());

class PolygonDrawingNotifier extends StateNotifier<PolygonDrawingState> {
  PolygonDrawingNotifier()
      : super(PolygonDrawingState(
          polygonSet: {},
          polylineSet: HashSet<Polyline>(),
          latLngList: [],
          lastXCoordinate: null,
          lastYCoordinate: null,
        ));

  GoogleMapController? mapController;
  List<LatLng> latLngList = [];
  int? lastXCoordinate;
  int? lastYCoordinate;
  HashSet<Polyline> polylineSet = HashSet<Polyline>();

  // 触った部分の座標をもとに Polyline インスタンスを生成し、_polylineSet に追加する
  Future<void> onPanUpdate(DragUpdateDetails details, WidgetRef ref) async {
    final polygonSet = ref.read(polygonSetProvider.notifier);
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

      final polygonNotifier = ref.read(polygonDrawingProvider.notifier);
      final mapController = polygonNotifier.mapController;

      if (mapController == null) {
        print("Error: GoogleMapController is null.");
        return;
      }

      try {
        final LatLng latLng = await mapController.getLatLng(
          // GoogleMapにおける座標に変換
          ScreenCoordinate(x: xCoordinate, y: yCoordinate),
        );

        // 新しいポイントをリストに追加する
        latLngList = [...latLngList, latLng];

        final polylineSet = ref.read(polylineSetProvider.notifier).state;

        // ポリラインのセットを初期化
        polylineSet.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');
        // 新しいポリラインを追加
        polylineSet.add(
          Polyline(
            polylineId: const PolylineId('user_polyline'),
            points: latLngList,
            width: 3,
            color: Colors.blue.withOpacity(0.8),
          ),
        );

        // なぞっている間ポリラインが描画され続ける
        polygonSet.state = {...polygonSet.state};
      } catch (e) {
        print("Error in onPanUpdate: $e");
      }
    }
  }

  // なぞり終えた際に Polygon インスタンスを生成し、_polygonSet に追加する。
  Future<void> onPanEnd(
      DragEndDetails details, BuildContext context, WidgetRef ref) async {
    final polygonSet = ref.read(polygonSetProvider.notifier);
    // 最後にキャッシュされた座標をリセット
    lastXCoordinate = null;
    lastYCoordinate = null;

    // ポリゴンのセットを初期化
    polygonSet.state
        .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
    // 新しいポリゴンの追加
    polygonSet.state.add(
      Polygon(
        polygonId: const PolygonId('user_polygon'),
        points: latLngList,
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

  //「なぞる」の切り替えを行う関数
  void toggleDrawing(WidgetRef ref) {
    clearPolygons(ref);
    ref.read(circleProvider.notifier).state.clear();
    ref.read(drawPolygonEnabledProvider.notifier).state =
        !ref.read(drawPolygonEnabledProvider);
    ref.read(mapScreenProvider).tmpTakeoff
        ? ref.read(mapScreenProvider.notifier).toggleTmpTakeoff()
        : null;
    ref.read(mapScreenProvider).tmpLand
        ? ref.read(mapScreenProvider.notifier).toggleTmpLand()
        : null;
    ref.read(mapScreenProvider.notifier).clearMarkers();
  }

  // PolylineとPolygonとLatLngをクリアする関数
  void clearPolygons(WidgetRef ref) {
    final polygonSet = ref.read(polygonSetProvider.notifier);
    final polylineSet = ref.read(polylineSetProvider.notifier);
    polygonSet.state.clear();
    latLngList.clear();
    polylineSet.state.clear();
  }
}

class PolygonDrawingState {
  final Set<Polygon> polygonSet;
  final HashSet<Polyline> polylineSet;
  final List<LatLng> latLngList;
  final int? lastXCoordinate;
  final int? lastYCoordinate;

  PolygonDrawingState({
    required this.polygonSet,
    required this.polylineSet,
    required this.latLngList,
    required this.lastXCoordinate,
    required this.lastYCoordinate,
  });
}

final polygonDrawingProvider =
    StateNotifierProvider<PolygonDrawingNotifier, PolygonDrawingState>(
        (ref) => PolygonDrawingNotifier());

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
