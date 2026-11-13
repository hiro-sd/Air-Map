// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Search App';

  @override
  String get title => 'Airport Map';

  @override
  String get map => 'Map';

  @override
  String get discover => 'Explore';

  @override
  String get my_map => 'My Map';

  @override
  String get all_saved_places => 'All';

  @override
  String get fit_saved_places => 'Fit visible places on the map';

  @override
  String get my_map_filter_empty => 'No saved places match this filter yet.';

  @override
  String get airports => 'Airports';

  @override
  String get flights => 'Flights';

  @override
  String get discover_hint => 'Move the map to find your next little adventure';

  @override
  String get nearby_places => 'Ideas around here';

  @override
  String get recommended_places => 'Ideas for you';

  @override
  String get today_discoveries => 'Today\'s discoveries';

  @override
  String get show_recommendations => 'For you';

  @override
  String get show_nearby_places => 'Nearby';

  @override
  String get recommendation_near_saved => 'Near a saved place';

  @override
  String get recommendation_favorite_theme => 'A theme from your favorites';

  @override
  String get recommendation_want_theme => 'A theme you want to explore';

  @override
  String get recommendation_shared_theme =>
      'A theme from a place you\'ve visited';

  @override
  String get recommendation_surprise => 'A little surprise';

  @override
  String get recommendation_featured => 'Today\'s find';

  @override
  String get no_recommendations => 'No new places to suggest yet.';

  @override
  String get no_curated_places =>
      'No featured places here yet. Long-press to add your own place.';

  @override
  String get curated_note =>
      'This early preview features a few selected regions';

  @override
  String get unexpected_place => 'A little surprise';

  @override
  String get familiar_place => 'A favorite';

  @override
  String get want_to_go => 'Want to go';

  @override
  String get visited => 'Visited';

  @override
  String get favorite => 'Favorite';

  @override
  String get place_source => 'Place information';

  @override
  String get source_checked_on => 'Checked on';

  @override
  String get source_open_failed => 'Could not open the place information page.';

  @override
  String get personal_note => 'Private note';

  @override
  String get write_note => 'Write a memory or note';

  @override
  String get save_note => 'Save note';

  @override
  String get add_place => 'Add this place';

  @override
  String get place_name => 'Place name';

  @override
  String get place_saved => 'Saved to My Map';

  @override
  String get my_map_empty => 'Your map starts here';

  @override
  String get my_map_empty_hint =>
      'Save a place you like and it will appear here.';

  @override
  String get explore_places => 'Explore places';

  @override
  String get remove_place => 'Remove this place';

  @override
  String get local_only_note =>
      'Places do not sync automatically. Export a backup in Settings.';

  @override
  String get save_failed => 'Could not save. Please try again.';

  @override
  String get settings => 'Settings';

  @override
  String get backup_section_title => 'My Map backup';

  @override
  String get backup_description =>
      'Save your places, statuses, favorites, and notes to a file.';

  @override
  String get backup_export_action => 'Export My Map';

  @override
  String get backup_export_hint => 'Save a JSON file to Files or another app';

  @override
  String get backup_import_action => 'Import backup';

  @override
  String get backup_import_hint => 'Add places from a saved JSON file';

  @override
  String get backup_import_title => 'Add these places to My Map?';

  @override
  String backup_import_summary(int newCount, int duplicateCount) {
    return 'Add $newCount places. Keep $duplicateCount existing places unchanged.';
  }

  @override
  String backup_import_replace_summary(int count) {
    return 'Import $count places and restore matching places from the backup.';
  }

  @override
  String get backup_replace_existing => 'Restore existing places too';

  @override
  String get backup_replace_warning =>
      'Statuses, favorites, and notes for matching places will be replaced.';

  @override
  String backup_import_success(int count) {
    return 'Imported $count places.';
  }

  @override
  String get backup_invalid_file =>
      'This backup cannot be imported. Check its format and contents.';

  @override
  String get backup_export_failed =>
      'Could not export your map. Please try again.';

  @override
  String get backup_import_failed =>
      'Could not import your map. Please try again.';

  @override
  String get contact_us => 'Contact us';

  @override
  String get rate_this_app => 'Review this app';

  @override
  String get share_this_app => 'Share this app';

  @override
  String get terms_of_use => 'Terms of use';

  @override
  String get privacy_policy => 'Privacy policy';

  @override
  String get switch_map => 'This map will be upgraded.';

  @override
  String get show_airports => 'Airports in Japan are shown on the map.';

  @override
  String show_nearby_airports(Object sliderValue) {
    return 'Airports within a ${sliderValue}km radius are shown on the map.';
  }

  @override
  String get alert_message =>
      'Flight information may not be accurate. Be sure to check the official website via the booking button.';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get date => 'Date';

  @override
  String get number_of_passengers => 'Number of passengers';

  @override
  String get origin => 'Origin';

  @override
  String get destination => 'Destination';

  @override
  String get search_airport => 'Search for the airport you want to go.';

  @override
  String get set_destination =>
      'Would you like to set this location as your destination?';

  @override
  String get set_complete => 'Your destination has been set!';

  @override
  String get set_location =>
      'Which one would you like to set this location as?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get selected_location => 'Selected location';

  @override
  String get no_photo => 'No photo available.';

  @override
  String get no_airport => 'No airports exist within the specified area.';

  @override
  String get no_flight =>
      'No flights could be confirmed for this search with the current data.';

  @override
  String get flight_search_failed =>
      'Flight information could not be loaded. Please try again later.';

  @override
  String get retry => 'Retry';

  @override
  String get location_unavailable =>
      'Could not get your location. Check location settings.';

  @override
  String get failed_to_load_image => 'Image failed to load';

  @override
  String get search_departing_airport => 'Search for the airport of departure.';

  @override
  String get set_departure =>
      'Would you like to set this location as your departure place?';

  @override
  String get polygon_drawing => 'Drawing Mode';

  @override
  String get normal_mode => 'Normal Mode';

  @override
  String get cancel_polygon_drawing => 'Exited drawing mode.';

  @override
  String get polygon_drawing_description =>
      'Draw an area to find airports inside and nearby.';

  @override
  String get map_destination_hint =>
      'Long-press a destination or draw an area on the map';

  @override
  String get airport_candidates => 'Candidate airports';

  @override
  String get candidate_distance_note =>
      'Distances are straight-line estimates. Flights and local travel times are not included yet.';

  @override
  String get airports_in_area => 'Inside the selected area';

  @override
  String get airports_near_area => 'Nearby airports';

  @override
  String get straight_line_from_point =>
      'Straight-line distance from selected point';

  @override
  String get straight_line_from_area_center =>
      'Straight-line distance from area center';

  @override
  String get route_status_unchecked =>
      'Flight routes: Not checked (search after selecting)';

  @override
  String get no_airport_candidates => 'No nearby candidate airports found.';

  @override
  String get select_area => 'Specify region.';

  @override
  String get search_result => 'Search Result';

  @override
  String airport_in_the_area(Object markersInsidePolygon) {
    return 'There are $markersInsidePolygon airports within the specified area.';
  }

  @override
  String get tap_marker =>
      'Tap a marker to set it as a departure or destination.';

  @override
  String get designate_radius => 'Specify the search radius.';

  @override
  String show_polygon_and_area(Object region) {
    return 'Airports in $region are showed.';
  }

  @override
  String get flight_screen_title => 'Find the best flights for your trip!';

  @override
  String get search => 'Search';

  @override
  String get search_flight => 'SEARCH FLIGHT';

  @override
  String get fill_all_fields => 'Please fill in the all fields.';

  @override
  String get same_airport => 'Choose different departure and arrival airports.';

  @override
  String get past_date => 'Choose today or a future date.';

  @override
  String get terminal => 'Terminal';

  @override
  String get departure_time => 'Departure time';

  @override
  String get arrival_time => 'Arrival time';

  @override
  String get passengers => 'Number of Passengers';

  @override
  String get price => 'Airfare';

  @override
  String get booking => 'Book Flight';

  @override
  String get yen => 'Yen';

  @override
  String get hokkaido => 'Hokkaido';

  @override
  String get tohoku => 'Tohoku region';

  @override
  String get kanto => 'Kanto region';

  @override
  String get chubu => 'Chubu region';

  @override
  String get kinki => 'Kinki region';

  @override
  String get chugoku => 'Chugoku region';

  @override
  String get shikoku => 'Shikoku region';

  @override
  String get kyushu => 'Kyushu region';

  @override
  String get okinawa => 'Okinawa';

  @override
  String get new_chitose_airport => 'New Chitose Airport';

  @override
  String get hakodate_airport => 'Hakodate Airport';

  @override
  String get kushiro_airport => 'Kushiro Airport';

  @override
  String get asahikawa_airport => 'Asahikawa Airport';

  @override
  String get memanbetsu_airport => 'Memanbetsu Airport';

  @override
  String get okadama_airport => 'Okadama Airport';

  @override
  String get wakkanai_airport => 'Wakkanai Airport';

  @override
  String get obihiro_airport => 'Obihiro Airport';

  @override
  String get rishiri_airport => 'Rishiri Airport';

  @override
  String get rebun_airport => 'Rebun Airport';

  @override
  String get monbetsu_airport => 'Monbetsu Airport';

  @override
  String get nakashibetsu_airport => 'Nakashibetsu Airport';

  @override
  String get okushiri_airport => 'Okushiri Airport';

  @override
  String get aomori_airport => 'Aomori Airport';

  @override
  String get misawa_airport => 'Misawa Airport';

  @override
  String get hanamaki_airport => 'Hanamaki Airport';

  @override
  String get sendai_airport => 'Sendai Airport';

  @override
  String get odate_noshiro_airport => 'Odate-Noshiro Airport';

  @override
  String get akita_airport => 'Akita Airport';

  @override
  String get shonai_airport => 'Shonai Airport';

  @override
  String get yamagata_airport => 'Yamagata Airport';

  @override
  String get fukushima_airport => 'Fukushima Airport';

  @override
  String get haneda_airport => 'Haneda Airport';

  @override
  String get oshima_airport => 'Oshima Airport';

  @override
  String get niijima_airport => 'Niijima Airport';

  @override
  String get kouzushima_airport => 'Kouzushima Airport';

  @override
  String get miyakejima_airport => 'Miyakejima Airport';

  @override
  String get hachijojima_aiport => 'Hachijojima Airport';

  @override
  String get chofu_airfield => 'Chofu Airfield';

  @override
  String get narita_airport => 'Narita International Airport';

  @override
  String get ibaraki_airport => 'Ibaraki Airport';

  @override
  String get chubu_airport => 'Chubu Centrair International Airport';

  @override
  String get nagoya_airport => 'Nagoya Airport';

  @override
  String get matsumoto_airport => 'Matsumoto Airport';

  @override
  String get niigata_airport => 'Niigata Airport';

  @override
  String get sado_airport => 'Sado Airport';

  @override
  String get toyama_airport => 'Toyama Airport';

  @override
  String get noto_airport => 'Noto Airport';

  @override
  String get komatsu_airport => 'Komatsu Airport';

  @override
  String get fukui_airport => 'Fukui Airport';

  @override
  String get shizuoka_airport => 'Shizuoka Airport';

  @override
  String get kansai_airport => 'Kansai International Airport';

  @override
  String get itami_airport => 'Osaka International Airport (Itami Airport)';

  @override
  String get kobe_airport => 'Kobe Airport';

  @override
  String get tajima_airport => 'Tajima Airport';

  @override
  String get shirahama_airport => 'Nanki-Shirahama Airport';

  @override
  String get tottori_airport => 'Tottori Airport';

  @override
  String get yonago_airport => 'Yonago Airport';

  @override
  String get izumo_airport => 'Izumo Airport';

  @override
  String get iwami_airport => 'Iwami Airport';

  @override
  String get oki_airport => 'Oki Airport';

  @override
  String get okayama_airport => 'Okayama Airport';

  @override
  String get hiroshima_airport => 'Hiroshima Airport';

  @override
  String get iwakuni_airport => 'Iwakuni Airport';

  @override
  String get ube_airport => 'Yamaguchi Ube Airport';

  @override
  String get tokushima_airport => 'Tokushima Airport';

  @override
  String get takamatsu_airport => 'Takamatsu Airport';

  @override
  String get matsuyama_airport => 'Matsuyama Airport';

  @override
  String get kochi_airport => 'Kochi Airport';

  @override
  String get fukuoka_airport => 'Fukuoka Airport';

  @override
  String get kitakyushu_airport => 'Kitakyushu Airport';

  @override
  String get saga_airport => 'Saga Airport';

  @override
  String get nagasaki_airport => 'Nagasaki Airport';

  @override
  String get iki_airport => 'Iki Airport';

  @override
  String get tsushima_airport => 'Tsushima Airport';

  @override
  String get fukue_airport => 'Fukue Airport';

  @override
  String get kumamoto_airport => 'Kumamoto Airport';

  @override
  String get amakusa_airport => 'Amakusa Airport';

  @override
  String get oita_airport => 'Oita Airport';

  @override
  String get miyazaki_airport => 'Miyazaki Airport';

  @override
  String get kagoshima_airport => 'Kagoshima Airport';

  @override
  String get satsuma_airport => 'Satsuma-Iojima Airport';

  @override
  String get tanegashima_airport => 'Tanegashima Airport';

  @override
  String get yakushima_airport => 'Yakushima Airport';

  @override
  String get suwanosejima_airport => 'Suwanosejima Airfield';

  @override
  String get amami_airport => 'Amami Airport';

  @override
  String get kikai_airport => 'Kikai Airport';

  @override
  String get tokunoshima_airport => 'Tokunoshima Airport';

  @override
  String get okinoerabu_airport => 'Okinoerabu Airport';

  @override
  String get yoron_airport => 'Yoron Airport';

  @override
  String get naha_airport => 'Naha International Airport';

  @override
  String get kumejima_airport => 'Kumejima Airport';

  @override
  String get kitadaito_airport => 'Kitadaito Airport';

  @override
  String get minamidaito_airport => 'Minamidaito Airport';

  @override
  String get miyako_airport => 'Miyako Airport';

  @override
  String get shimojishima_airport => 'Shimojishima Airport';

  @override
  String get tarama_airport => 'Tarama Airport';

  @override
  String get ishigaki_airport => 'New Ishigaki Airport';

  @override
  String get hateruma_airport => 'Hateruma Airport';

  @override
  String get yonaguni_airport => 'Yonaguni Airport';

  @override
  String get new_chitose_airport_snippet =>
      'An airport located in Chitose, Hokkaido';

  @override
  String get hakodate_airport_snippet =>
      'An airport located in Hakodate, Hokkaido';

  @override
  String get kushiro_airport_snippet =>
      'An airport located in Kushiro, Hokkaido';

  @override
  String get asahikawa_airport_snippet =>
      'An airport located in Asahikawa, Hokkaido';

  @override
  String get memanbetsu_airport_snippet =>
      'An airport located in Ozora, Abashiri, Hokkaido';

  @override
  String get okadama_airport_snippet =>
      'An airport located in Sapporo, Hokkaido';

  @override
  String get wakkanai_airport_snippet =>
      'An airport located in Wakkanai, Hokkaido';

  @override
  String get obihiro_airport_snippet =>
      'An airport located in Obihiro, Hokkaido';

  @override
  String get rishiri_airport_snippet =>
      'An airport located in Rishirifuji, Rishiri, Hokkaido';

  @override
  String get rebun_airport_snippet => 'An airport located in Rebun, Hokkaido';

  @override
  String get monbetsu_airport_snippet =>
      'An airport located in Monbetsu, Hokkaido';

  @override
  String get nakashibetsu_airport_snippet =>
      'An airport located in Nakashibetsu, Hokkaido';

  @override
  String get okushiri_airport_snippet =>
      'An airport located in Okushiri, Hokkaido';

  @override
  String get aomori_airport_snippet =>
      'An airport located in Aomori, Aomori Prefecture';

  @override
  String get misawa_airport_snippet =>
      'An airport located in Misawa, Aomori Prefecture';

  @override
  String get hanamaki_airport_snippet =>
      'An airport located in Hanamaki, Iwate Prefecture';

  @override
  String get sendai_airport_snippet =>
      'An airport located in Natori, Miyagi Prefecture';

  @override
  String get odate_noshiro_airport_snippet =>
      'An airport located in Kitaakita, Akita Prefecture';

  @override
  String get akita_airport_snippet =>
      'An airport located in Akita, Akita Prefecture';

  @override
  String get shonai_airport_snippet =>
      'An airport located in Sakata, Yamagata Prefecture';

  @override
  String get yamagata_airport_snippet =>
      'An airport located in Higashine, Yamagata Prefecture';

  @override
  String get fukushima_airport_snippet =>
      'An airport located in Tamakawa, Fukushima Prefecture';

  @override
  String get haneda_airport_snippet => 'An airport located in Ota, Tokyo';

  @override
  String get oshima_airport_snippet => 'An airport located in Oshima, Tokyo';

  @override
  String get niijima_airport_snippet => 'An airport located in Niijima, Tokyo';

  @override
  String get kouzushima_airport_snippet =>
      'An airport located in Kouzushima, Tokyo';

  @override
  String get miyakejima_airport_snippet =>
      'An airport located in Miyakejima, Tokyo';

  @override
  String get hachijojima_airport_snippet =>
      'An airport located in Hachijojima, Tokyo';

  @override
  String get chofu_airfield_snippet => 'An airfield located in Chofu, Tokyo';

  @override
  String get narita_airport_snippet =>
      'An airport located in Narita, Chiba Prefecture';

  @override
  String get ibaraki_airport_snippet =>
      'An airport located in Omitama, Ibaraki Prefecture';

  @override
  String get chubu_airport_snippet =>
      'An airport located in Tokoname, Aichi Prefecture';

  @override
  String get nagoya_airport_snippet =>
      'An airport located in Toyoyama, Aichi Prefecture';

  @override
  String get matsumoto_airport_snippet =>
      'An airport located in Matsumoto, Nagano Prefecture';

  @override
  String get niigata_airport_snippet =>
      'An airport located in Niigata, Niigata Prefecture';

  @override
  String get sado_airport_snippet =>
      'An airport located in Sado, Niigata Prefecture';

  @override
  String get toyama_airport_snippet =>
      'An airport located in Toyama, Toyama Prefecture';

  @override
  String get noto_airport_snippet =>
      'An airport located in Wajima, Ishikawa Prefecture';

  @override
  String get komatsu_airport_snippet =>
      'An airport located in Komatsu, Ishikawa Prefecture';

  @override
  String get fukui_airport_snippet =>
      'An airport located in Sakai, Fukui Prefecture';

  @override
  String get shizuoka_airport_snippet =>
      'An airport located in Makinohara, Shizuoka Prefecture';

  @override
  String get kansai_airport_snippet =>
      'An airport located in Izumisano, Osaka Prefecture';

  @override
  String get itami_airport_snippet =>
      'An airport located in Toyonaka, Osaka Prefecture';

  @override
  String get kobe_airport_snippet =>
      'An airport located in Kobe, Hyogo Prefecture';

  @override
  String get tajima_airport_snippet =>
      'An airfield located in Toyooka, Hyogo Prefecture';

  @override
  String get shirahama_airport_snippet =>
      'An airport located in Shirahama, Wakayama Prefecture';

  @override
  String get tottori_airport_snippet =>
      'An airport located in Tottori, Tottori Prefecture';

  @override
  String get yonago_airport_snippet =>
      'An airport located in Sakaiminato, Tottori Prefecture';

  @override
  String get izumo_airport_snippet =>
      'An airport located in Izumo, Shimane Prefecture';

  @override
  String get iwami_airport_snippet =>
      'An airport located in Masuda, Shimane Prefecture';

  @override
  String get oki_airport_snippet =>
      'An airport located in Okinoshima, Shimane Prefecture';

  @override
  String get okayama_airport_snippet =>
      'An airport located in Okayama, Okayama Prefecture';

  @override
  String get hiroshima_airport_snippet =>
      'An airport located in Mihara, Hiroshima Prefecture';

  @override
  String get iwakuni_airport_snippet =>
      'An airfield located in Iwakuni, Yamaguchi Prefecture';

  @override
  String get ube_airport_snippet =>
      'An airport located in Ube, Yamaguchi Prefecture';

  @override
  String get tokushima_airport_snippet =>
      'An airfield located in Matsushige, Tokushima Prefecture';

  @override
  String get takamatsu_airport_snippet =>
      'An airport located in Takamatsu, Kagawa Prefecture';

  @override
  String get matsuyama_airport_snippet =>
      'An airport located in Matsuyama, Ehime Prefecture';

  @override
  String get kochi_airport_snippet =>
      'An airport located in Kochi, Kochi Prefecture';

  @override
  String get fukuoka_airport_snippet =>
      'An airport located in Fukuoka, Fukuoka Prefecture';

  @override
  String get kitakyushu_airport_snippet =>
      'An airport located in Kitakyushu, Fukuoka Prefecture';

  @override
  String get saga_airport_snippet =>
      'An airport located in Saga, Saga Prefecture';

  @override
  String get nagasaki_airport_snippet =>
      'An airport located in Omura, Nagasaki Prefecture';

  @override
  String get iki_airport_snippet =>
      'An airport located in Iki, Nagasaki Prefecture';

  @override
  String get tsushima_airport_snippet =>
      'An Airport localed in Tsushima, Nagasaki Prefecture';

  @override
  String get fukue_airport_snippet =>
      'An airport localed in Goto, Nagasaki Prefecture';

  @override
  String get kumamoto_airport_snippet =>
      'An airport located in Mashiki, Kumamoto Prefecture';

  @override
  String get amakusa_airport_snippet =>
      'An airport located in Amakusa, Kumamoto Prefecture';

  @override
  String get oita_airport_snippet =>
      'An airport located in Kunisaki, Oita Prefecture';

  @override
  String get miyazaki_airport_snippet =>
      'An airport localed in Miyazaki, Miyazaki Prefecture';

  @override
  String get kagoshima_airport_snippet =>
      'An airport located in Kirishima, Kagoshima Prefecture';

  @override
  String get satsuma_airport_snippet =>
      'An airport localed in Mishima, Kagoshima Prefecture';

  @override
  String get tanegashima_airport_snippet =>
      'An airport located in Nakatane, Kagoshima Prefecture';

  @override
  String get yakushima_airport_snippet =>
      'An airport located in Yakushima, Kagoshima Prefecture';

  @override
  String get suwanosejima_airport_snippet =>
      'An airport located in Toshima, Kagoshima Prefecture';

  @override
  String get amami_airport_snippet =>
      'An airport located in Amami, Kagoshima Prefecture';

  @override
  String get kikai_airport_snippet =>
      'An airport located in Kikai, Kagoshima Prefecture';

  @override
  String get tokunoshima_airport_snippet =>
      'An airport located in Amagi, Kagoshima Prefecture';

  @override
  String get okinoerabu_airport_snippet =>
      'An airport located in Wadomari, Kagoshima Prefecture';

  @override
  String get yoron_airport_snippet =>
      'An airport located in Yoron, Kagoshima Prefecture';

  @override
  String get naha_airport_snippet =>
      'An airport located in Naha, Okinawa Prefecture';

  @override
  String get kumejima_airport_snippet =>
      'An airport located in Kumejima, Okinawa Prefecture';

  @override
  String get kitadaito_airport_snippet =>
      'An airport located in Kitadaito, Okinawa Prefecture';

  @override
  String get minamidaito_airport_snippet =>
      'An airport located in Minamidaito, Okinawa Prefecture';

  @override
  String get miyako_airport_snippet =>
      'An airport located in Miyakojima, Okinawa Prefecture';

  @override
  String get shimojishima_airport_snippet =>
      'An airport located in Miyakojima, Okinawa Prefecture';

  @override
  String get tarama_airport_snippet =>
      'An airport located in Tarama, Okinawa Prefecture';

  @override
  String get ishigaki_airport_snippet =>
      'An airport located in Ishigaki, Okinawa Prefecture';

  @override
  String get hateruma_airport_snippet =>
      'An airport located in Taketomi, Okinawa Prefecture';

  @override
  String get yonaguni_airport_snippet =>
      'An airport located in Yonaguni, Okinawa Prefecture';
}
