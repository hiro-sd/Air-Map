import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/travel_place.dart';

enum VisitStatus { none, wantToGo, visited }

class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.title,
    required this.position,
    this.status = VisitStatus.none,
    this.isFavorite = false,
    this.note = '',
    this.isCustom = false,
  });

  final String id;
  final String title;
  final LatLng position;
  final VisitStatus status;
  final bool isFavorite;
  final String note;
  final bool isCustom;

  factory SavedPlace.fromCurated(TravelPlace place) => SavedPlace(
        id: place.id,
        title: place.nameJa,
        position: place.position,
      );

  SavedPlace copyWith({
    VisitStatus? status,
    bool? isFavorite,
    String? note,
  }) =>
      SavedPlace(
        id: id,
        title: title,
        position: position,
        status: status ?? this.status,
        isFavorite: isFavorite ?? this.isFavorite,
        note: note ?? this.note,
        isCustom: isCustom,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'status': status.name,
        'isFavorite': isFavorite,
        'note': note,
        'isCustom': isCustom,
      };

  factory SavedPlace.fromJson(Map<dynamic, dynamic> json) {
    final rawStatus = json['status'];
    return SavedPlace(
      id: json['id'] as String,
      title: json['title'] as String,
      position: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      status: VisitStatus.values.firstWhere(
        (value) => value.name == rawStatus,
        orElse: () => VisitStatus.none,
      ),
      isFavorite: json['isFavorite'] == true,
      note: json['note'] as String? ?? '',
      isCustom: json['isCustom'] == true,
    );
  }
}
