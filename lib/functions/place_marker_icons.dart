import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/travel_place.dart';

Future<Map<PlaceTheme, BitmapDescriptor>> createPlaceMarkerIcons() async {
  final result = <PlaceTheme, BitmapDescriptor>{};
  for (final theme in PlaceTheme.values) {
    final (color, icon) = switch (theme) {
      PlaceTheme.nature => (const Color(0xFF79A889), Icons.park_rounded),
      PlaceTheme.culture => (
          const Color(0xFFE7A877),
          Icons.account_balance_rounded
        ),
      PlaceTheme.town => (
          const Color(0xFF8F9BD8),
          Icons.holiday_village_rounded
        ),
      PlaceTheme.art => (const Color(0xFFD48DAF), Icons.palette_rounded),
    };
    result[theme] = await _drawMarker(color, icon);
  }
  return result;
}

Future<BitmapDescriptor> _drawMarker(Color color, IconData icon) async {
  const width = 120.0;
  const height = 144.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const center = Offset(width / 2, 57);

  final tail = Path()
    ..moveTo(37, 87)
    ..lineTo(60, 133)
    ..lineTo(83, 87)
    ..close();
  canvas.drawShadow(tail, Colors.black54, 5, true);
  canvas.drawPath(tail, Paint()..color = Colors.white);
  canvas.drawCircle(center, 54, Paint()..color = Colors.white);
  canvas.drawCircle(center, 46, Paint()..color = color);

  final painter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontSize: 52,
        color: Colors.white,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2));

  final picture = recorder.endRecording();
  final image = await picture.toImage(width.toInt(), height.toInt());
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  if (data == null) throw StateError('Could not create a place marker');
  return BitmapDescriptor.bytes(data.buffer.asUint8List(),
      width: 52, height: 62);
}
