import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PlaceTheme { nature, culture, town, art }

class TravelRegion {
  const TravelRegion({
    required this.id,
    required this.countryCode,
    required this.nameJa,
    required this.nameEn,
  });

  final String id;
  final String countryCode;
  final String nameJa;
  final String nameEn;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ja' ? nameJa : nameEn;
}

class TravelPlace {
  const TravelPlace({
    required this.id,
    required this.region,
    required this.position,
    required this.nameJa,
    required this.nameEn,
    required this.teaserJa,
    required this.teaserEn,
    required this.descriptionJa,
    required this.descriptionEn,
    required this.theme,
    required this.isUnexpected,
    required this.sourceName,
    required this.sourceUrl,
    required this.reviewedOn,
  });

  final String id;
  final TravelRegion region;
  final LatLng position;
  final String nameJa;
  final String nameEn;
  final String teaserJa;
  final String teaserEn;
  final String descriptionJa;
  final String descriptionEn;
  final PlaceTheme theme;
  final bool isUnexpected;
  final String sourceName;
  final String sourceUrl;
  final String reviewedOn;

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
