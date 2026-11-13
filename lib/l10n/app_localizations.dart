import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Search App'**
  String get app_title;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Airport Map'**
  String get title;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get discover;

  /// No description provided for @my_map.
  ///
  /// In en, this message translates to:
  /// **'My Map'**
  String get my_map;

  /// No description provided for @all_saved_places.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all_saved_places;

  /// No description provided for @fit_saved_places.
  ///
  /// In en, this message translates to:
  /// **'Fit visible places on the map'**
  String get fit_saved_places;

  /// No description provided for @my_map_filter_empty.
  ///
  /// In en, this message translates to:
  /// **'No saved places match this filter yet.'**
  String get my_map_filter_empty;

  /// No description provided for @airports.
  ///
  /// In en, this message translates to:
  /// **'Airports'**
  String get airports;

  /// No description provided for @flights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get flights;

  /// No description provided for @discover_hint.
  ///
  /// In en, this message translates to:
  /// **'Move the map to find your next little adventure'**
  String get discover_hint;

  /// No description provided for @nearby_places.
  ///
  /// In en, this message translates to:
  /// **'Ideas around here'**
  String get nearby_places;

  /// No description provided for @recommended_places.
  ///
  /// In en, this message translates to:
  /// **'Ideas for you'**
  String get recommended_places;

  /// No description provided for @today_discoveries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s discoveries'**
  String get today_discoveries;

  /// No description provided for @show_recommendations.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get show_recommendations;

  /// No description provided for @show_nearby_places.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get show_nearby_places;

  /// No description provided for @recommendation_near_saved.
  ///
  /// In en, this message translates to:
  /// **'Near a saved place'**
  String get recommendation_near_saved;

  /// No description provided for @recommendation_shared_theme.
  ///
  /// In en, this message translates to:
  /// **'A theme you like'**
  String get recommendation_shared_theme;

  /// No description provided for @recommendation_surprise.
  ///
  /// In en, this message translates to:
  /// **'A little surprise'**
  String get recommendation_surprise;

  /// No description provided for @recommendation_featured.
  ///
  /// In en, this message translates to:
  /// **'Today\'s find'**
  String get recommendation_featured;

  /// No description provided for @no_recommendations.
  ///
  /// In en, this message translates to:
  /// **'No new places to suggest yet.'**
  String get no_recommendations;

  /// No description provided for @no_curated_places.
  ///
  /// In en, this message translates to:
  /// **'No featured places here yet. Long-press to add your own place.'**
  String get no_curated_places;

  /// No description provided for @curated_note.
  ///
  /// In en, this message translates to:
  /// **'This early preview features a few selected regions'**
  String get curated_note;

  /// No description provided for @unexpected_place.
  ///
  /// In en, this message translates to:
  /// **'A little surprise'**
  String get unexpected_place;

  /// No description provided for @familiar_place.
  ///
  /// In en, this message translates to:
  /// **'A favorite'**
  String get familiar_place;

  /// No description provided for @want_to_go.
  ///
  /// In en, this message translates to:
  /// **'Want to go'**
  String get want_to_go;

  /// No description provided for @visited.
  ///
  /// In en, this message translates to:
  /// **'Visited'**
  String get visited;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @place_source.
  ///
  /// In en, this message translates to:
  /// **'Place information'**
  String get place_source;

  /// No description provided for @source_checked_on.
  ///
  /// In en, this message translates to:
  /// **'Checked on'**
  String get source_checked_on;

  /// No description provided for @source_open_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the place information page.'**
  String get source_open_failed;

  /// No description provided for @personal_note.
  ///
  /// In en, this message translates to:
  /// **'Private note'**
  String get personal_note;

  /// No description provided for @write_note.
  ///
  /// In en, this message translates to:
  /// **'Write a memory or note'**
  String get write_note;

  /// No description provided for @save_note.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get save_note;

  /// No description provided for @add_place.
  ///
  /// In en, this message translates to:
  /// **'Add this place'**
  String get add_place;

  /// No description provided for @place_name.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get place_name;

  /// No description provided for @place_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved to My Map'**
  String get place_saved;

  /// No description provided for @my_map_empty.
  ///
  /// In en, this message translates to:
  /// **'Your map starts here'**
  String get my_map_empty;

  /// No description provided for @my_map_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Save a place you like and it will appear here.'**
  String get my_map_empty_hint;

  /// No description provided for @explore_places.
  ///
  /// In en, this message translates to:
  /// **'Explore places'**
  String get explore_places;

  /// No description provided for @remove_place.
  ///
  /// In en, this message translates to:
  /// **'Remove this place'**
  String get remove_place;

  /// No description provided for @local_only_note.
  ///
  /// In en, this message translates to:
  /// **'Your places stay on this device'**
  String get local_only_note;

  /// No description provided for @save_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get save_failed;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @rate_this_app.
  ///
  /// In en, this message translates to:
  /// **'Review this app'**
  String get rate_this_app;

  /// No description provided for @share_this_app.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get share_this_app;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get terms_of_use;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @switch_map.
  ///
  /// In en, this message translates to:
  /// **'This map will be upgraded.'**
  String get switch_map;

  /// No description provided for @show_airports.
  ///
  /// In en, this message translates to:
  /// **'Airports in Japan are shown on the map.'**
  String get show_airports;

  /// No description provided for @show_nearby_airports.
  ///
  /// In en, this message translates to:
  /// **'Airports within a {sliderValue}km radius are shown on the map.'**
  String show_nearby_airports(Object sliderValue);

  /// No description provided for @alert_message.
  ///
  /// In en, this message translates to:
  /// **'Flight information may not be accurate. Be sure to check the official website via the booking button.'**
  String get alert_message;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @number_of_passengers.
  ///
  /// In en, this message translates to:
  /// **'Number of passengers'**
  String get number_of_passengers;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @search_airport.
  ///
  /// In en, this message translates to:
  /// **'Search for the airport you want to go.'**
  String get search_airport;

  /// No description provided for @set_destination.
  ///
  /// In en, this message translates to:
  /// **'Would you like to set this location as your destination?'**
  String get set_destination;

  /// No description provided for @set_complete.
  ///
  /// In en, this message translates to:
  /// **'Your destination has been set!'**
  String get set_complete;

  /// No description provided for @set_location.
  ///
  /// In en, this message translates to:
  /// **'Which one would you like to set this location as?'**
  String get set_location;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selected_location.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selected_location;

  /// No description provided for @no_photo.
  ///
  /// In en, this message translates to:
  /// **'No photo available.'**
  String get no_photo;

  /// No description provided for @no_airport.
  ///
  /// In en, this message translates to:
  /// **'No airports exist within the specified area.'**
  String get no_airport;

  /// No description provided for @no_flight.
  ///
  /// In en, this message translates to:
  /// **'No flights could be confirmed for this search with the current data.'**
  String get no_flight;

  /// No description provided for @flight_search_failed.
  ///
  /// In en, this message translates to:
  /// **'Flight information could not be loaded. Please try again later.'**
  String get flight_search_failed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @location_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location. Check location settings.'**
  String get location_unavailable;

  /// No description provided for @failed_to_load_image.
  ///
  /// In en, this message translates to:
  /// **'Image failed to load'**
  String get failed_to_load_image;

  /// No description provided for @search_departing_airport.
  ///
  /// In en, this message translates to:
  /// **'Search for the airport of departure.'**
  String get search_departing_airport;

  /// No description provided for @set_departure.
  ///
  /// In en, this message translates to:
  /// **'Would you like to set this location as your departure place?'**
  String get set_departure;

  /// No description provided for @polygon_drawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing Mode'**
  String get polygon_drawing;

  /// No description provided for @normal_mode.
  ///
  /// In en, this message translates to:
  /// **'Normal Mode'**
  String get normal_mode;

  /// No description provided for @cancel_polygon_drawing.
  ///
  /// In en, this message translates to:
  /// **'Exited drawing mode.'**
  String get cancel_polygon_drawing;

  /// No description provided for @polygon_drawing_description.
  ///
  /// In en, this message translates to:
  /// **'Draw an area to find airports inside and nearby.'**
  String get polygon_drawing_description;

  /// No description provided for @map_destination_hint.
  ///
  /// In en, this message translates to:
  /// **'Long-press a destination or draw an area on the map'**
  String get map_destination_hint;

  /// No description provided for @airport_candidates.
  ///
  /// In en, this message translates to:
  /// **'Candidate airports'**
  String get airport_candidates;

  /// No description provided for @candidate_distance_note.
  ///
  /// In en, this message translates to:
  /// **'Distances are straight-line estimates. Flights and local travel times are not included yet.'**
  String get candidate_distance_note;

  /// No description provided for @airports_in_area.
  ///
  /// In en, this message translates to:
  /// **'Inside the selected area'**
  String get airports_in_area;

  /// No description provided for @airports_near_area.
  ///
  /// In en, this message translates to:
  /// **'Nearby airports'**
  String get airports_near_area;

  /// No description provided for @straight_line_from_point.
  ///
  /// In en, this message translates to:
  /// **'Straight-line distance from selected point'**
  String get straight_line_from_point;

  /// No description provided for @straight_line_from_area_center.
  ///
  /// In en, this message translates to:
  /// **'Straight-line distance from area center'**
  String get straight_line_from_area_center;

  /// No description provided for @route_status_unchecked.
  ///
  /// In en, this message translates to:
  /// **'Flight routes: Not checked (search after selecting)'**
  String get route_status_unchecked;

  /// No description provided for @no_airport_candidates.
  ///
  /// In en, this message translates to:
  /// **'No nearby candidate airports found.'**
  String get no_airport_candidates;

  /// No description provided for @select_area.
  ///
  /// In en, this message translates to:
  /// **'Specify region.'**
  String get select_area;

  /// No description provided for @search_result.
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get search_result;

  /// No description provided for @airport_in_the_area.
  ///
  /// In en, this message translates to:
  /// **'There are {markersInsidePolygon} airports within the specified area.'**
  String airport_in_the_area(Object markersInsidePolygon);

  /// No description provided for @tap_marker.
  ///
  /// In en, this message translates to:
  /// **'Tap a marker to set it as a departure or destination.'**
  String get tap_marker;

  /// No description provided for @designate_radius.
  ///
  /// In en, this message translates to:
  /// **'Specify the search radius.'**
  String get designate_radius;

  /// No description provided for @show_polygon_and_area.
  ///
  /// In en, this message translates to:
  /// **'Airports in {region} are showed.'**
  String show_polygon_and_area(Object region);

  /// No description provided for @flight_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Find the best flights for your trip!'**
  String get flight_screen_title;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_flight.
  ///
  /// In en, this message translates to:
  /// **'SEARCH FLIGHT'**
  String get search_flight;

  /// No description provided for @fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the all fields.'**
  String get fill_all_fields;

  /// No description provided for @same_airport.
  ///
  /// In en, this message translates to:
  /// **'Choose different departure and arrival airports.'**
  String get same_airport;

  /// No description provided for @past_date.
  ///
  /// In en, this message translates to:
  /// **'Choose today or a future date.'**
  String get past_date;

  /// No description provided for @terminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminal;

  /// No description provided for @departure_time.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get departure_time;

  /// No description provided for @arrival_time.
  ///
  /// In en, this message translates to:
  /// **'Arrival time'**
  String get arrival_time;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Number of Passengers'**
  String get passengers;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Airfare'**
  String get price;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Book Flight'**
  String get booking;

  /// No description provided for @yen.
  ///
  /// In en, this message translates to:
  /// **'Yen'**
  String get yen;

  /// No description provided for @hokkaido.
  ///
  /// In en, this message translates to:
  /// **'Hokkaido'**
  String get hokkaido;

  /// No description provided for @tohoku.
  ///
  /// In en, this message translates to:
  /// **'Tohoku region'**
  String get tohoku;

  /// No description provided for @kanto.
  ///
  /// In en, this message translates to:
  /// **'Kanto region'**
  String get kanto;

  /// No description provided for @chubu.
  ///
  /// In en, this message translates to:
  /// **'Chubu region'**
  String get chubu;

  /// No description provided for @kinki.
  ///
  /// In en, this message translates to:
  /// **'Kinki region'**
  String get kinki;

  /// No description provided for @chugoku.
  ///
  /// In en, this message translates to:
  /// **'Chugoku region'**
  String get chugoku;

  /// No description provided for @shikoku.
  ///
  /// In en, this message translates to:
  /// **'Shikoku region'**
  String get shikoku;

  /// No description provided for @kyushu.
  ///
  /// In en, this message translates to:
  /// **'Kyushu region'**
  String get kyushu;

  /// No description provided for @okinawa.
  ///
  /// In en, this message translates to:
  /// **'Okinawa'**
  String get okinawa;

  /// No description provided for @new_chitose_airport.
  ///
  /// In en, this message translates to:
  /// **'New Chitose Airport'**
  String get new_chitose_airport;

  /// No description provided for @hakodate_airport.
  ///
  /// In en, this message translates to:
  /// **'Hakodate Airport'**
  String get hakodate_airport;

  /// No description provided for @kushiro_airport.
  ///
  /// In en, this message translates to:
  /// **'Kushiro Airport'**
  String get kushiro_airport;

  /// No description provided for @asahikawa_airport.
  ///
  /// In en, this message translates to:
  /// **'Asahikawa Airport'**
  String get asahikawa_airport;

  /// No description provided for @memanbetsu_airport.
  ///
  /// In en, this message translates to:
  /// **'Memanbetsu Airport'**
  String get memanbetsu_airport;

  /// No description provided for @okadama_airport.
  ///
  /// In en, this message translates to:
  /// **'Okadama Airport'**
  String get okadama_airport;

  /// No description provided for @wakkanai_airport.
  ///
  /// In en, this message translates to:
  /// **'Wakkanai Airport'**
  String get wakkanai_airport;

  /// No description provided for @obihiro_airport.
  ///
  /// In en, this message translates to:
  /// **'Obihiro Airport'**
  String get obihiro_airport;

  /// No description provided for @rishiri_airport.
  ///
  /// In en, this message translates to:
  /// **'Rishiri Airport'**
  String get rishiri_airport;

  /// No description provided for @rebun_airport.
  ///
  /// In en, this message translates to:
  /// **'Rebun Airport'**
  String get rebun_airport;

  /// No description provided for @monbetsu_airport.
  ///
  /// In en, this message translates to:
  /// **'Monbetsu Airport'**
  String get monbetsu_airport;

  /// No description provided for @nakashibetsu_airport.
  ///
  /// In en, this message translates to:
  /// **'Nakashibetsu Airport'**
  String get nakashibetsu_airport;

  /// No description provided for @okushiri_airport.
  ///
  /// In en, this message translates to:
  /// **'Okushiri Airport'**
  String get okushiri_airport;

  /// No description provided for @aomori_airport.
  ///
  /// In en, this message translates to:
  /// **'Aomori Airport'**
  String get aomori_airport;

  /// No description provided for @misawa_airport.
  ///
  /// In en, this message translates to:
  /// **'Misawa Airport'**
  String get misawa_airport;

  /// No description provided for @hanamaki_airport.
  ///
  /// In en, this message translates to:
  /// **'Hanamaki Airport'**
  String get hanamaki_airport;

  /// No description provided for @sendai_airport.
  ///
  /// In en, this message translates to:
  /// **'Sendai Airport'**
  String get sendai_airport;

  /// No description provided for @odate_noshiro_airport.
  ///
  /// In en, this message translates to:
  /// **'Odate-Noshiro Airport'**
  String get odate_noshiro_airport;

  /// No description provided for @akita_airport.
  ///
  /// In en, this message translates to:
  /// **'Akita Airport'**
  String get akita_airport;

  /// No description provided for @shonai_airport.
  ///
  /// In en, this message translates to:
  /// **'Shonai Airport'**
  String get shonai_airport;

  /// No description provided for @yamagata_airport.
  ///
  /// In en, this message translates to:
  /// **'Yamagata Airport'**
  String get yamagata_airport;

  /// No description provided for @fukushima_airport.
  ///
  /// In en, this message translates to:
  /// **'Fukushima Airport'**
  String get fukushima_airport;

  /// No description provided for @haneda_airport.
  ///
  /// In en, this message translates to:
  /// **'Haneda Airport'**
  String get haneda_airport;

  /// No description provided for @oshima_airport.
  ///
  /// In en, this message translates to:
  /// **'Oshima Airport'**
  String get oshima_airport;

  /// No description provided for @niijima_airport.
  ///
  /// In en, this message translates to:
  /// **'Niijima Airport'**
  String get niijima_airport;

  /// No description provided for @kouzushima_airport.
  ///
  /// In en, this message translates to:
  /// **'Kouzushima Airport'**
  String get kouzushima_airport;

  /// No description provided for @miyakejima_airport.
  ///
  /// In en, this message translates to:
  /// **'Miyakejima Airport'**
  String get miyakejima_airport;

  /// No description provided for @hachijojima_aiport.
  ///
  /// In en, this message translates to:
  /// **'Hachijojima Airport'**
  String get hachijojima_aiport;

  /// No description provided for @chofu_airfield.
  ///
  /// In en, this message translates to:
  /// **'Chofu Airfield'**
  String get chofu_airfield;

  /// No description provided for @narita_airport.
  ///
  /// In en, this message translates to:
  /// **'Narita International Airport'**
  String get narita_airport;

  /// No description provided for @ibaraki_airport.
  ///
  /// In en, this message translates to:
  /// **'Ibaraki Airport'**
  String get ibaraki_airport;

  /// No description provided for @chubu_airport.
  ///
  /// In en, this message translates to:
  /// **'Chubu Centrair International Airport'**
  String get chubu_airport;

  /// No description provided for @nagoya_airport.
  ///
  /// In en, this message translates to:
  /// **'Nagoya Airport'**
  String get nagoya_airport;

  /// No description provided for @matsumoto_airport.
  ///
  /// In en, this message translates to:
  /// **'Matsumoto Airport'**
  String get matsumoto_airport;

  /// No description provided for @niigata_airport.
  ///
  /// In en, this message translates to:
  /// **'Niigata Airport'**
  String get niigata_airport;

  /// No description provided for @sado_airport.
  ///
  /// In en, this message translates to:
  /// **'Sado Airport'**
  String get sado_airport;

  /// No description provided for @toyama_airport.
  ///
  /// In en, this message translates to:
  /// **'Toyama Airport'**
  String get toyama_airport;

  /// No description provided for @noto_airport.
  ///
  /// In en, this message translates to:
  /// **'Noto Airport'**
  String get noto_airport;

  /// No description provided for @komatsu_airport.
  ///
  /// In en, this message translates to:
  /// **'Komatsu Airport'**
  String get komatsu_airport;

  /// No description provided for @fukui_airport.
  ///
  /// In en, this message translates to:
  /// **'Fukui Airport'**
  String get fukui_airport;

  /// No description provided for @shizuoka_airport.
  ///
  /// In en, this message translates to:
  /// **'Shizuoka Airport'**
  String get shizuoka_airport;

  /// No description provided for @kansai_airport.
  ///
  /// In en, this message translates to:
  /// **'Kansai International Airport'**
  String get kansai_airport;

  /// No description provided for @itami_airport.
  ///
  /// In en, this message translates to:
  /// **'Osaka International Airport (Itami Airport)'**
  String get itami_airport;

  /// No description provided for @kobe_airport.
  ///
  /// In en, this message translates to:
  /// **'Kobe Airport'**
  String get kobe_airport;

  /// No description provided for @tajima_airport.
  ///
  /// In en, this message translates to:
  /// **'Tajima Airport'**
  String get tajima_airport;

  /// No description provided for @shirahama_airport.
  ///
  /// In en, this message translates to:
  /// **'Nanki-Shirahama Airport'**
  String get shirahama_airport;

  /// No description provided for @tottori_airport.
  ///
  /// In en, this message translates to:
  /// **'Tottori Airport'**
  String get tottori_airport;

  /// No description provided for @yonago_airport.
  ///
  /// In en, this message translates to:
  /// **'Yonago Airport'**
  String get yonago_airport;

  /// No description provided for @izumo_airport.
  ///
  /// In en, this message translates to:
  /// **'Izumo Airport'**
  String get izumo_airport;

  /// No description provided for @iwami_airport.
  ///
  /// In en, this message translates to:
  /// **'Iwami Airport'**
  String get iwami_airport;

  /// No description provided for @oki_airport.
  ///
  /// In en, this message translates to:
  /// **'Oki Airport'**
  String get oki_airport;

  /// No description provided for @okayama_airport.
  ///
  /// In en, this message translates to:
  /// **'Okayama Airport'**
  String get okayama_airport;

  /// No description provided for @hiroshima_airport.
  ///
  /// In en, this message translates to:
  /// **'Hiroshima Airport'**
  String get hiroshima_airport;

  /// No description provided for @iwakuni_airport.
  ///
  /// In en, this message translates to:
  /// **'Iwakuni Airport'**
  String get iwakuni_airport;

  /// No description provided for @ube_airport.
  ///
  /// In en, this message translates to:
  /// **'Yamaguchi Ube Airport'**
  String get ube_airport;

  /// No description provided for @tokushima_airport.
  ///
  /// In en, this message translates to:
  /// **'Tokushima Airport'**
  String get tokushima_airport;

  /// No description provided for @takamatsu_airport.
  ///
  /// In en, this message translates to:
  /// **'Takamatsu Airport'**
  String get takamatsu_airport;

  /// No description provided for @matsuyama_airport.
  ///
  /// In en, this message translates to:
  /// **'Matsuyama Airport'**
  String get matsuyama_airport;

  /// No description provided for @kochi_airport.
  ///
  /// In en, this message translates to:
  /// **'Kochi Airport'**
  String get kochi_airport;

  /// No description provided for @fukuoka_airport.
  ///
  /// In en, this message translates to:
  /// **'Fukuoka Airport'**
  String get fukuoka_airport;

  /// No description provided for @kitakyushu_airport.
  ///
  /// In en, this message translates to:
  /// **'Kitakyushu Airport'**
  String get kitakyushu_airport;

  /// No description provided for @saga_airport.
  ///
  /// In en, this message translates to:
  /// **'Saga Airport'**
  String get saga_airport;

  /// No description provided for @nagasaki_airport.
  ///
  /// In en, this message translates to:
  /// **'Nagasaki Airport'**
  String get nagasaki_airport;

  /// No description provided for @iki_airport.
  ///
  /// In en, this message translates to:
  /// **'Iki Airport'**
  String get iki_airport;

  /// No description provided for @tsushima_airport.
  ///
  /// In en, this message translates to:
  /// **'Tsushima Airport'**
  String get tsushima_airport;

  /// No description provided for @fukue_airport.
  ///
  /// In en, this message translates to:
  /// **'Fukue Airport'**
  String get fukue_airport;

  /// No description provided for @kumamoto_airport.
  ///
  /// In en, this message translates to:
  /// **'Kumamoto Airport'**
  String get kumamoto_airport;

  /// No description provided for @amakusa_airport.
  ///
  /// In en, this message translates to:
  /// **'Amakusa Airport'**
  String get amakusa_airport;

  /// No description provided for @oita_airport.
  ///
  /// In en, this message translates to:
  /// **'Oita Airport'**
  String get oita_airport;

  /// No description provided for @miyazaki_airport.
  ///
  /// In en, this message translates to:
  /// **'Miyazaki Airport'**
  String get miyazaki_airport;

  /// No description provided for @kagoshima_airport.
  ///
  /// In en, this message translates to:
  /// **'Kagoshima Airport'**
  String get kagoshima_airport;

  /// No description provided for @satsuma_airport.
  ///
  /// In en, this message translates to:
  /// **'Satsuma-Iojima Airport'**
  String get satsuma_airport;

  /// No description provided for @tanegashima_airport.
  ///
  /// In en, this message translates to:
  /// **'Tanegashima Airport'**
  String get tanegashima_airport;

  /// No description provided for @yakushima_airport.
  ///
  /// In en, this message translates to:
  /// **'Yakushima Airport'**
  String get yakushima_airport;

  /// No description provided for @suwanosejima_airport.
  ///
  /// In en, this message translates to:
  /// **'Suwanosejima Airfield'**
  String get suwanosejima_airport;

  /// No description provided for @amami_airport.
  ///
  /// In en, this message translates to:
  /// **'Amami Airport'**
  String get amami_airport;

  /// No description provided for @kikai_airport.
  ///
  /// In en, this message translates to:
  /// **'Kikai Airport'**
  String get kikai_airport;

  /// No description provided for @tokunoshima_airport.
  ///
  /// In en, this message translates to:
  /// **'Tokunoshima Airport'**
  String get tokunoshima_airport;

  /// No description provided for @okinoerabu_airport.
  ///
  /// In en, this message translates to:
  /// **'Okinoerabu Airport'**
  String get okinoerabu_airport;

  /// No description provided for @yoron_airport.
  ///
  /// In en, this message translates to:
  /// **'Yoron Airport'**
  String get yoron_airport;

  /// No description provided for @naha_airport.
  ///
  /// In en, this message translates to:
  /// **'Naha International Airport'**
  String get naha_airport;

  /// No description provided for @kumejima_airport.
  ///
  /// In en, this message translates to:
  /// **'Kumejima Airport'**
  String get kumejima_airport;

  /// No description provided for @kitadaito_airport.
  ///
  /// In en, this message translates to:
  /// **'Kitadaito Airport'**
  String get kitadaito_airport;

  /// No description provided for @minamidaito_airport.
  ///
  /// In en, this message translates to:
  /// **'Minamidaito Airport'**
  String get minamidaito_airport;

  /// No description provided for @miyako_airport.
  ///
  /// In en, this message translates to:
  /// **'Miyako Airport'**
  String get miyako_airport;

  /// No description provided for @shimojishima_airport.
  ///
  /// In en, this message translates to:
  /// **'Shimojishima Airport'**
  String get shimojishima_airport;

  /// No description provided for @tarama_airport.
  ///
  /// In en, this message translates to:
  /// **'Tarama Airport'**
  String get tarama_airport;

  /// No description provided for @ishigaki_airport.
  ///
  /// In en, this message translates to:
  /// **'New Ishigaki Airport'**
  String get ishigaki_airport;

  /// No description provided for @hateruma_airport.
  ///
  /// In en, this message translates to:
  /// **'Hateruma Airport'**
  String get hateruma_airport;

  /// No description provided for @yonaguni_airport.
  ///
  /// In en, this message translates to:
  /// **'Yonaguni Airport'**
  String get yonaguni_airport;

  /// No description provided for @new_chitose_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Chitose, Hokkaido'**
  String get new_chitose_airport_snippet;

  /// No description provided for @hakodate_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Hakodate, Hokkaido'**
  String get hakodate_airport_snippet;

  /// No description provided for @kushiro_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kushiro, Hokkaido'**
  String get kushiro_airport_snippet;

  /// No description provided for @asahikawa_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Asahikawa, Hokkaido'**
  String get asahikawa_airport_snippet;

  /// No description provided for @memanbetsu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Ozora, Abashiri, Hokkaido'**
  String get memanbetsu_airport_snippet;

  /// No description provided for @okadama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Sapporo, Hokkaido'**
  String get okadama_airport_snippet;

  /// No description provided for @wakkanai_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Wakkanai, Hokkaido'**
  String get wakkanai_airport_snippet;

  /// No description provided for @obihiro_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Obihiro, Hokkaido'**
  String get obihiro_airport_snippet;

  /// No description provided for @rishiri_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Rishirifuji, Rishiri, Hokkaido'**
  String get rishiri_airport_snippet;

  /// No description provided for @rebun_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Rebun, Hokkaido'**
  String get rebun_airport_snippet;

  /// No description provided for @monbetsu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Monbetsu, Hokkaido'**
  String get monbetsu_airport_snippet;

  /// No description provided for @nakashibetsu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Nakashibetsu, Hokkaido'**
  String get nakashibetsu_airport_snippet;

  /// No description provided for @okushiri_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Okushiri, Hokkaido'**
  String get okushiri_airport_snippet;

  /// No description provided for @aomori_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Aomori, Aomori Prefecture'**
  String get aomori_airport_snippet;

  /// No description provided for @misawa_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Misawa, Aomori Prefecture'**
  String get misawa_airport_snippet;

  /// No description provided for @hanamaki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Hanamaki, Iwate Prefecture'**
  String get hanamaki_airport_snippet;

  /// No description provided for @sendai_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Natori, Miyagi Prefecture'**
  String get sendai_airport_snippet;

  /// No description provided for @odate_noshiro_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kitaakita, Akita Prefecture'**
  String get odate_noshiro_airport_snippet;

  /// No description provided for @akita_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Akita, Akita Prefecture'**
  String get akita_airport_snippet;

  /// No description provided for @shonai_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Sakata, Yamagata Prefecture'**
  String get shonai_airport_snippet;

  /// No description provided for @yamagata_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Higashine, Yamagata Prefecture'**
  String get yamagata_airport_snippet;

  /// No description provided for @fukushima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Tamakawa, Fukushima Prefecture'**
  String get fukushima_airport_snippet;

  /// No description provided for @haneda_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Ota, Tokyo'**
  String get haneda_airport_snippet;

  /// No description provided for @oshima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Oshima, Tokyo'**
  String get oshima_airport_snippet;

  /// No description provided for @niijima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Niijima, Tokyo'**
  String get niijima_airport_snippet;

  /// No description provided for @kouzushima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kouzushima, Tokyo'**
  String get kouzushima_airport_snippet;

  /// No description provided for @miyakejima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Miyakejima, Tokyo'**
  String get miyakejima_airport_snippet;

  /// No description provided for @hachijojima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Hachijojima, Tokyo'**
  String get hachijojima_airport_snippet;

  /// No description provided for @chofu_airfield_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airfield located in Chofu, Tokyo'**
  String get chofu_airfield_snippet;

  /// No description provided for @narita_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Narita, Chiba Prefecture'**
  String get narita_airport_snippet;

  /// No description provided for @ibaraki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Omitama, Ibaraki Prefecture'**
  String get ibaraki_airport_snippet;

  /// No description provided for @chubu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Tokoname, Aichi Prefecture'**
  String get chubu_airport_snippet;

  /// No description provided for @nagoya_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Toyoyama, Aichi Prefecture'**
  String get nagoya_airport_snippet;

  /// No description provided for @matsumoto_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Matsumoto, Nagano Prefecture'**
  String get matsumoto_airport_snippet;

  /// No description provided for @niigata_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Niigata, Niigata Prefecture'**
  String get niigata_airport_snippet;

  /// No description provided for @sado_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Sado, Niigata Prefecture'**
  String get sado_airport_snippet;

  /// No description provided for @toyama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Toyama, Toyama Prefecture'**
  String get toyama_airport_snippet;

  /// No description provided for @noto_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Wajima, Ishikawa Prefecture'**
  String get noto_airport_snippet;

  /// No description provided for @komatsu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Komatsu, Ishikawa Prefecture'**
  String get komatsu_airport_snippet;

  /// No description provided for @fukui_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Sakai, Fukui Prefecture'**
  String get fukui_airport_snippet;

  /// No description provided for @shizuoka_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Makinohara, Shizuoka Prefecture'**
  String get shizuoka_airport_snippet;

  /// No description provided for @kansai_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Izumisano, Osaka Prefecture'**
  String get kansai_airport_snippet;

  /// No description provided for @itami_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Toyonaka, Osaka Prefecture'**
  String get itami_airport_snippet;

  /// No description provided for @kobe_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kobe, Hyogo Prefecture'**
  String get kobe_airport_snippet;

  /// No description provided for @tajima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airfield located in Toyooka, Hyogo Prefecture'**
  String get tajima_airport_snippet;

  /// No description provided for @shirahama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Shirahama, Wakayama Prefecture'**
  String get shirahama_airport_snippet;

  /// No description provided for @tottori_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Tottori, Tottori Prefecture'**
  String get tottori_airport_snippet;

  /// No description provided for @yonago_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Sakaiminato, Tottori Prefecture'**
  String get yonago_airport_snippet;

  /// No description provided for @izumo_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Izumo, Shimane Prefecture'**
  String get izumo_airport_snippet;

  /// No description provided for @iwami_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Masuda, Shimane Prefecture'**
  String get iwami_airport_snippet;

  /// No description provided for @oki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Okinoshima, Shimane Prefecture'**
  String get oki_airport_snippet;

  /// No description provided for @okayama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Okayama, Okayama Prefecture'**
  String get okayama_airport_snippet;

  /// No description provided for @hiroshima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Mihara, Hiroshima Prefecture'**
  String get hiroshima_airport_snippet;

  /// No description provided for @iwakuni_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airfield located in Iwakuni, Yamaguchi Prefecture'**
  String get iwakuni_airport_snippet;

  /// No description provided for @ube_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Ube, Yamaguchi Prefecture'**
  String get ube_airport_snippet;

  /// No description provided for @tokushima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airfield located in Matsushige, Tokushima Prefecture'**
  String get tokushima_airport_snippet;

  /// No description provided for @takamatsu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Takamatsu, Kagawa Prefecture'**
  String get takamatsu_airport_snippet;

  /// No description provided for @matsuyama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Matsuyama, Ehime Prefecture'**
  String get matsuyama_airport_snippet;

  /// No description provided for @kochi_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kochi, Kochi Prefecture'**
  String get kochi_airport_snippet;

  /// No description provided for @fukuoka_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Fukuoka, Fukuoka Prefecture'**
  String get fukuoka_airport_snippet;

  /// No description provided for @kitakyushu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kitakyushu, Fukuoka Prefecture'**
  String get kitakyushu_airport_snippet;

  /// No description provided for @saga_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Saga, Saga Prefecture'**
  String get saga_airport_snippet;

  /// No description provided for @nagasaki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Omura, Nagasaki Prefecture'**
  String get nagasaki_airport_snippet;

  /// No description provided for @iki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Iki, Nagasaki Prefecture'**
  String get iki_airport_snippet;

  /// No description provided for @tsushima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An Airport localed in Tsushima, Nagasaki Prefecture'**
  String get tsushima_airport_snippet;

  /// No description provided for @fukue_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport localed in Goto, Nagasaki Prefecture'**
  String get fukue_airport_snippet;

  /// No description provided for @kumamoto_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Mashiki, Kumamoto Prefecture'**
  String get kumamoto_airport_snippet;

  /// No description provided for @amakusa_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Amakusa, Kumamoto Prefecture'**
  String get amakusa_airport_snippet;

  /// No description provided for @oita_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kunisaki, Oita Prefecture'**
  String get oita_airport_snippet;

  /// No description provided for @miyazaki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport localed in Miyazaki, Miyazaki Prefecture'**
  String get miyazaki_airport_snippet;

  /// No description provided for @kagoshima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kirishima, Kagoshima Prefecture'**
  String get kagoshima_airport_snippet;

  /// No description provided for @satsuma_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport localed in Mishima, Kagoshima Prefecture'**
  String get satsuma_airport_snippet;

  /// No description provided for @tanegashima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Nakatane, Kagoshima Prefecture'**
  String get tanegashima_airport_snippet;

  /// No description provided for @yakushima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Yakushima, Kagoshima Prefecture'**
  String get yakushima_airport_snippet;

  /// No description provided for @suwanosejima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Toshima, Kagoshima Prefecture'**
  String get suwanosejima_airport_snippet;

  /// No description provided for @amami_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Amami, Kagoshima Prefecture'**
  String get amami_airport_snippet;

  /// No description provided for @kikai_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kikai, Kagoshima Prefecture'**
  String get kikai_airport_snippet;

  /// No description provided for @tokunoshima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Amagi, Kagoshima Prefecture'**
  String get tokunoshima_airport_snippet;

  /// No description provided for @okinoerabu_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Wadomari, Kagoshima Prefecture'**
  String get okinoerabu_airport_snippet;

  /// No description provided for @yoron_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Yoron, Kagoshima Prefecture'**
  String get yoron_airport_snippet;

  /// No description provided for @naha_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Naha, Okinawa Prefecture'**
  String get naha_airport_snippet;

  /// No description provided for @kumejima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kumejima, Okinawa Prefecture'**
  String get kumejima_airport_snippet;

  /// No description provided for @kitadaito_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Kitadaito, Okinawa Prefecture'**
  String get kitadaito_airport_snippet;

  /// No description provided for @minamidaito_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Minamidaito, Okinawa Prefecture'**
  String get minamidaito_airport_snippet;

  /// No description provided for @miyako_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Miyakojima, Okinawa Prefecture'**
  String get miyako_airport_snippet;

  /// No description provided for @shimojishima_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Miyakojima, Okinawa Prefecture'**
  String get shimojishima_airport_snippet;

  /// No description provided for @tarama_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Tarama, Okinawa Prefecture'**
  String get tarama_airport_snippet;

  /// No description provided for @ishigaki_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Ishigaki, Okinawa Prefecture'**
  String get ishigaki_airport_snippet;

  /// No description provided for @hateruma_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Taketomi, Okinawa Prefecture'**
  String get hateruma_airport_snippet;

  /// No description provided for @yonaguni_airport_snippet.
  ///
  /// In en, this message translates to:
  /// **'An airport located in Yonaguni, Okinawa Prefecture'**
  String get yonaguni_airport_snippet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
