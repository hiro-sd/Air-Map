import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PlaceTheme { nature, culture, town, art }

class TravelPlace {
  const TravelPlace({
    required this.id,
    required this.position,
    required this.nameJa,
    required this.nameEn,
    required this.teaserJa,
    required this.teaserEn,
    required this.descriptionJa,
    required this.descriptionEn,
    required this.theme,
    required this.isUnexpected,
  });

  final String id;
  final LatLng position;
  final String nameJa;
  final String nameEn;
  final String teaserJa;
  final String teaserEn;
  final String descriptionJa;
  final String descriptionEn;
  final PlaceTheme theme;
  final bool isUnexpected;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ja' ? nameJa : nameEn;

  String teaser(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ja'
          ? teaserJa
          : teaserEn;

  String description(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ja'
          ? descriptionJa
          : descriptionEn;
}
