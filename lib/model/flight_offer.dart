import 'package:flutter/foundation.dart';

@immutable
class FlightOffer {
  final String id;
  final String duration;
  final String departureTerminal;
  final String arrivalTerminal;
  final String carrier;
  final String flightNumber;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;

  const FlightOffer({
    required this.id,
    required this.duration,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.carrier,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory FlightOffer.fromJson(Map<String, dynamic> json) {
    final itineraries = json['itineraries'] as List;
    if (itineraries.isEmpty) {
      throw const FormatException('No itineraries found');
    }

    final segments = itineraries[0]['segments'] as List;
    if (segments.isEmpty) {
      throw const FormatException('No segments found');
    }

    String formatDuration(String duration) {
      final match = RegExp(r'PT(\d+H)?(\d+M)?').firstMatch(duration);
      if (match == null) return '';

      final hours = match.group(1)?.replaceAll('H', 'h') ?? '';
      final minutes = match.group(2)?.replaceAll('M', 'm') ?? '';
      return '$hours$minutes';
    }

    final firstFlight = segments[0];
    return FlightOffer(
      id: json['id'] ?? 'Unknown',
      duration: formatDuration(itineraries[0]['duration']),
      departureTerminal: firstFlight['departure']['terminal'] ?? '-',
      arrivalTerminal: firstFlight['arrival']['terminal'] ?? '-',
      carrier: firstFlight['carrierCode'] ?? '',
      flightNumber: firstFlight['number'] ?? '',
      departureTime: DateTime.parse(firstFlight['departure']['at']),
      arrivalTime: DateTime.parse(firstFlight['arrival']['at']),
      price: double.parse(json['price']['total']),
    );
  }
}
