// ポリゴン内のマーカーを取得する関数
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
