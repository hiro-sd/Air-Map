// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => '検索アプリ';

  @override
  String get title => '空港マップ';

  @override
  String get map => 'マップ';

  @override
  String get discover => '見つける';

  @override
  String get my_map => 'マイマップ';

  @override
  String get all_saved_places => 'すべて';

  @override
  String get fit_saved_places => '表示中の場所を地図に収める';

  @override
  String get my_map_filter_empty => 'この条件で保存した場所はまだありません。';

  @override
  String get airports => '空港';

  @override
  String get flights => '便検索';

  @override
  String get discover_hint => '地図を動かして、旅の種を見つけよう';

  @override
  String get nearby_places => 'この辺りの旅の種';

  @override
  String get recommended_places => 'あなたへの旅の種';

  @override
  String get today_discoveries => '今日の旅の種';

  @override
  String get show_recommendations => 'おすすめ';

  @override
  String get show_nearby_places => 'この辺り';

  @override
  String get recommendation_near_saved => '保存場所の近く';

  @override
  String get recommendation_shared_theme => '保存場所と同じテーマ';

  @override
  String get recommendation_surprise => '少し意外な場所も';

  @override
  String get recommendation_featured => '今日の発見';

  @override
  String get no_recommendations => '新しい候補はまだありません。';

  @override
  String get no_curated_places => 'この辺りの紹介スポットは準備中。長押しで自分の場所を追加できます。';

  @override
  String get curated_note => '最初の試作では一部の地域だけを紹介しています';

  @override
  String get unexpected_place => 'ちょっと意外';

  @override
  String get familiar_place => '定番';

  @override
  String get want_to_go => '行きたい';

  @override
  String get visited => '行った';

  @override
  String get favorite => 'お気に入り';

  @override
  String get personal_note => '自分だけのメモ';

  @override
  String get write_note => '感想やメモを書く';

  @override
  String get save_note => 'メモを保存';

  @override
  String get add_place => 'この場所を追加';

  @override
  String get place_name => '場所の名前';

  @override
  String get place_saved => 'マイマップに保存しました';

  @override
  String get my_map_empty => 'あなたの地図はこれから';

  @override
  String get my_map_empty_hint => '気になる場所を保存すると、ここに並びます。';

  @override
  String get explore_places => '場所を見つける';

  @override
  String get remove_place => 'この場所を削除';

  @override
  String get local_only_note => '保存内容はこの端末だけに記録されます';

  @override
  String get save_failed => '保存できませんでした。もう一度お試しください。';

  @override
  String get settings => '設定';

  @override
  String get contact_us => 'お問い合わせ';

  @override
  String get rate_this_app => 'アプリをレビュー';

  @override
  String get share_this_app => 'アプリを共有';

  @override
  String get terms_of_use => '利用規約';

  @override
  String get privacy_policy => 'プライバシーポリシー';

  @override
  String get switch_map => '表示変更';

  @override
  String get show_airports => '全国の空港を表示します。';

  @override
  String show_nearby_airports(Object sliderValue) {
    return '半径${sliderValue}km以内の空港を表示します。';
  }

  @override
  String get alert_message => '※ 正確なフライト情報は予約ボタンをタップし、必ず公式サイトで確認してください。';

  @override
  String get close => '閉じる';

  @override
  String get ok => 'OK';

  @override
  String get date => '搭乗日';

  @override
  String get number_of_passengers => '乗客人数';

  @override
  String get origin => '出発地';

  @override
  String get destination => '目的地';

  @override
  String get search_airport => '行き先の空港を検索またはピンで指定';

  @override
  String get set_destination => '目的地に設定しますか？';

  @override
  String get set_complete => '目的地が設定されました！';

  @override
  String get set_location => 'この場所をどちらに設定しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get selected_location => '選択された場所';

  @override
  String get no_photo => '表示する画像がありません。';

  @override
  String get no_airport => '指定されたエリア内に空港が存在しません。';

  @override
  String get no_flight => '現在のデータでは、この条件の便を確認できませんでした。';

  @override
  String get flight_search_failed => 'フライト情報を取得できませんでした。時間をおいて再試行してください。';

  @override
  String get retry => '再試行';

  @override
  String get location_unavailable => '現在地を取得できませんでした。位置情報の設定を確認してください。';

  @override
  String get failed_to_load_image => '画像のロードに失敗しました。';

  @override
  String get search_departing_airport => '出発する空港を検索またはピンで指定';

  @override
  String get set_departure => '出発地に設定しますか？';

  @override
  String get polygon_drawing => '描画モード';

  @override
  String get normal_mode => '通常モード';

  @override
  String get cancel_polygon_drawing => '描画モードを終了しました。';

  @override
  String get polygon_drawing_description => '地図をなぞると、エリア内と周辺の空港を探します。';

  @override
  String get map_destination_hint => '行きたい地点を長押し、または描画ボタンで地域を囲んでください';

  @override
  String get airport_candidates => '利用候補の空港';

  @override
  String get candidate_distance_note => '距離は直線の目安です。就航便や現地への移動時間はまだ反映していません。';

  @override
  String get airports_in_area => '選択範囲内';

  @override
  String get airports_near_area => '周辺の空港';

  @override
  String get straight_line_from_point => '選択地点からの直線距離';

  @override
  String get straight_line_from_area_center => '選択範囲の中心からの直線距離';

  @override
  String get route_status_unchecked => '就航情報: 未確認（空港選択後に便を検索）';

  @override
  String get no_airport_candidates => '近くに候補の空港が見つかりませんでした。';

  @override
  String get select_area => '地方を指定する';

  @override
  String get search_result => '検索結果';

  @override
  String airport_in_the_area(Object markersInsidePolygon) {
    return '指定されたエリア内に空港が$markersInsidePolygon件存在します。';
  }

  @override
  String get tap_marker => 'マーカーをタップすると出発地や目的地に設定できます。';

  @override
  String get designate_radius => '検索半径を指定してください。';

  @override
  String show_polygon_and_area(Object region) {
    return '$regionの空港を表示します。';
  }

  @override
  String get flight_screen_title => '最適なフライトを見つけましょう!';

  @override
  String get search => '検索';

  @override
  String get search_flight => 'フライト検索';

  @override
  String get fill_all_fields => '全ての欄を埋めてください。';

  @override
  String get same_airport => '出発地と目的地に同じ空港は指定できません。';

  @override
  String get past_date => '過去の日付は指定できません。';

  @override
  String get terminal => 'ターミナル';

  @override
  String get departure_time => '出発時刻';

  @override
  String get arrival_time => '到着時刻';

  @override
  String get passengers => '乗客数';

  @override
  String get price => '値段';

  @override
  String get booking => '予約';

  @override
  String get yen => '円';

  @override
  String get hokkaido => '北海道';

  @override
  String get tohoku => '東北地方';

  @override
  String get kanto => '関東地方';

  @override
  String get chubu => '中部地方';

  @override
  String get kinki => '近畿地方';

  @override
  String get chugoku => '中国地方';

  @override
  String get shikoku => '四国地方';

  @override
  String get kyushu => '九州地方';

  @override
  String get okinawa => '沖縄';

  @override
  String get new_chitose_airport => '新千歳空港';

  @override
  String get hakodate_airport => '函館空港';

  @override
  String get kushiro_airport => '釧路空港';

  @override
  String get asahikawa_airport => '旭川空港';

  @override
  String get memanbetsu_airport => '女満別空港';

  @override
  String get okadama_airport => '丘珠空港';

  @override
  String get wakkanai_airport => '稚内空港';

  @override
  String get obihiro_airport => '帯広空港';

  @override
  String get rishiri_airport => '利尻空港';

  @override
  String get rebun_airport => '礼文空港';

  @override
  String get monbetsu_airport => '紋別空港';

  @override
  String get nakashibetsu_airport => '中標津空港';

  @override
  String get okushiri_airport => '奥尻空港';

  @override
  String get aomori_airport => '青森空港';

  @override
  String get misawa_airport => '三沢空港';

  @override
  String get hanamaki_airport => '花巻空港';

  @override
  String get sendai_airport => '仙台空港';

  @override
  String get odate_noshiro_airport => '大館能代空港';

  @override
  String get akita_airport => '秋田空港';

  @override
  String get shonai_airport => '庄内空港';

  @override
  String get yamagata_airport => '山形空港';

  @override
  String get fukushima_airport => '福島空港';

  @override
  String get haneda_airport => '羽田空港';

  @override
  String get oshima_airport => '大島空港';

  @override
  String get niijima_airport => '新島空港';

  @override
  String get kouzushima_airport => '神津島空港';

  @override
  String get miyakejima_airport => '三宅島空港';

  @override
  String get hachijojima_aiport => '八丈島空港';

  @override
  String get chofu_airfield => '調布飛行場';

  @override
  String get narita_airport => '成田国際空港';

  @override
  String get ibaraki_airport => '茨城空港';

  @override
  String get chubu_airport => '中部国際空港 セントレア';

  @override
  String get nagoya_airport => '県営名古屋空港';

  @override
  String get matsumoto_airport => '松本空港';

  @override
  String get niigata_airport => '新潟空港';

  @override
  String get sado_airport => '佐渡空港';

  @override
  String get toyama_airport => '富山空港';

  @override
  String get noto_airport => '能登空港';

  @override
  String get komatsu_airport => '小松空港';

  @override
  String get fukui_airport => '福井空港';

  @override
  String get shizuoka_airport => '静岡空港';

  @override
  String get kansai_airport => '関西国際空港';

  @override
  String get itami_airport => '大阪国際空港 (伊丹空港)';

  @override
  String get kobe_airport => '神戸空港';

  @override
  String get tajima_airport => '但馬空港';

  @override
  String get shirahama_airport => '南紀白浜空港';

  @override
  String get tottori_airport => '鳥取空港';

  @override
  String get yonago_airport => '米子空港';

  @override
  String get izumo_airport => '出雲空港';

  @override
  String get iwami_airport => '石見空港';

  @override
  String get oki_airport => '隠岐空港';

  @override
  String get okayama_airport => '岡山空港';

  @override
  String get hiroshima_airport => '広島空港';

  @override
  String get iwakuni_airport => '岩国飛行場';

  @override
  String get ube_airport => '山口宇部空港';

  @override
  String get tokushima_airport => '徳島飛行場';

  @override
  String get takamatsu_airport => '高松空港';

  @override
  String get matsuyama_airport => '松山空港';

  @override
  String get kochi_airport => '高知空港';

  @override
  String get fukuoka_airport => '福岡空港';

  @override
  String get kitakyushu_airport => '北九州空港';

  @override
  String get saga_airport => '佐賀空港';

  @override
  String get nagasaki_airport => '長崎空港';

  @override
  String get iki_airport => '壱岐空港';

  @override
  String get tsushima_airport => '対馬空港';

  @override
  String get fukue_airport => '福江空港';

  @override
  String get kumamoto_airport => '熊本空港';

  @override
  String get amakusa_airport => '天草空港';

  @override
  String get oita_airport => '大分空港';

  @override
  String get miyazaki_airport => '宮崎空港';

  @override
  String get kagoshima_airport => '鹿児島空港';

  @override
  String get satsuma_airport => '薩摩硫黄島飛行場';

  @override
  String get tanegashima_airport => '種子島空港';

  @override
  String get yakushima_airport => '屋久島空港';

  @override
  String get suwanosejima_airport => '諏訪之瀬島飛行場';

  @override
  String get amami_airport => '奄美空港';

  @override
  String get kikai_airport => '喜界空港';

  @override
  String get tokunoshima_airport => '徳之島空港';

  @override
  String get okinoerabu_airport => '沖永良部空港';

  @override
  String get yoron_airport => '与論空港';

  @override
  String get naha_airport => '那覇空港';

  @override
  String get kumejima_airport => '久米島空港';

  @override
  String get kitadaito_airport => '北大東空港';

  @override
  String get minamidaito_airport => '南大東空港';

  @override
  String get miyako_airport => '宮古空港';

  @override
  String get shimojishima_airport => '下地島空港';

  @override
  String get tarama_airport => '多良間空港';

  @override
  String get ishigaki_airport => '新石垣空港';

  @override
  String get hateruma_airport => '波照間空港';

  @override
  String get yonaguni_airport => '与那国空港';

  @override
  String get new_chitose_airport_snippet => '北海道千歳市にある空港';

  @override
  String get hakodate_airport_snippet => '北海道函館市にある空港';

  @override
  String get kushiro_airport_snippet => '北海道釧路市にある空港';

  @override
  String get asahikawa_airport_snippet => '北海道旭川市にある空港';

  @override
  String get memanbetsu_airport_snippet => '北海道網走郡大空町にある空港';

  @override
  String get okadama_airport_snippet => '北海道札幌市にある空港';

  @override
  String get wakkanai_airport_snippet => '北海道稚内市にある空港';

  @override
  String get obihiro_airport_snippet => '北海道帯広市にある空港';

  @override
  String get rishiri_airport_snippet => '北海道利尻郡利尻富士町にある空港';

  @override
  String get rebun_airport_snippet => '北海道礼文郡礼文町にある空港';

  @override
  String get monbetsu_airport_snippet => '北海道紋別市にある空港';

  @override
  String get nakashibetsu_airport_snippet => '北海道標津郡中標津町にある空港';

  @override
  String get okushiri_airport_snippet => '北海道奥尻郡奥尻町にある空港';

  @override
  String get aomori_airport_snippet => '青森県青森市にある空港';

  @override
  String get misawa_airport_snippet => '青森県三沢市にある空港';

  @override
  String get hanamaki_airport_snippet => '岩手県花巻市にある空港';

  @override
  String get sendai_airport_snippet => '宮城県名取市にある空港';

  @override
  String get odate_noshiro_airport_snippet => '秋田県北秋田市にある空港';

  @override
  String get akita_airport_snippet => '秋田県秋田市にある空港';

  @override
  String get shonai_airport_snippet => '山形県酒田市にある空港';

  @override
  String get yamagata_airport_snippet => '山形県東根市にある空港';

  @override
  String get fukushima_airport_snippet => '福島県石川郡玉川村にある空港';

  @override
  String get haneda_airport_snippet => '東京都大田区にある空港';

  @override
  String get oshima_airport_snippet => '東京都大島町にある空港';

  @override
  String get niijima_airport_snippet => '東京都新島村にある空港';

  @override
  String get kouzushima_airport_snippet => '東京都神津島村にある空港';

  @override
  String get miyakejima_airport_snippet => '東京都三宅島三宅村にある空港';

  @override
  String get hachijojima_airport_snippet => '東京都八丈島八丈町にある空港';

  @override
  String get chofu_airfield_snippet => '東京都調布市にある飛行場';

  @override
  String get narita_airport_snippet => '千葉県成田市にある空港';

  @override
  String get ibaraki_airport_snippet => '茨城県小美玉市にある空港';

  @override
  String get chubu_airport_snippet => '愛知県常滑市にある空港';

  @override
  String get nagoya_airport_snippet => '愛知県西春日井郡豊山町にある空港';

  @override
  String get matsumoto_airport_snippet => '長野県松本市にある空港';

  @override
  String get niigata_airport_snippet => '新潟県新潟市にある空港';

  @override
  String get sado_airport_snippet => '新潟県佐渡市にある空港';

  @override
  String get toyama_airport_snippet => '富山県富山市にある空港';

  @override
  String get noto_airport_snippet => '石川県輪島市にある空港';

  @override
  String get komatsu_airport_snippet => '石川県小松市にある空港';

  @override
  String get fukui_airport_snippet => '福井県坂井市にある空港';

  @override
  String get shizuoka_airport_snippet => '静岡県牧之原市にある空港';

  @override
  String get kansai_airport_snippet => '大阪府泉佐野市にある空港';

  @override
  String get itami_airport_snippet => '大阪府豊中市にある空港';

  @override
  String get kobe_airport_snippet => '兵庫県神戸市にある空港';

  @override
  String get tajima_airport_snippet => '兵庫県豊岡市にある飛行場';

  @override
  String get shirahama_airport_snippet => '和歌山県西牟婁郡白浜町にある空港';

  @override
  String get tottori_airport_snippet => '鳥取県鳥取市にある空港';

  @override
  String get yonago_airport_snippet => '鳥取県境港市にある空港';

  @override
  String get izumo_airport_snippet => '島根県出雲市にある空港';

  @override
  String get iwami_airport_snippet => '島根県益田市にある空港';

  @override
  String get oki_airport_snippet => '島根県隠岐郡隠岐の島町にある空港';

  @override
  String get okayama_airport_snippet => '岡山県岡山市にある空港';

  @override
  String get hiroshima_airport_snippet => '広島県三原市にある空港';

  @override
  String get iwakuni_airport_snippet => '山口県岩国市にある飛行場';

  @override
  String get ube_airport_snippet => '山口県宇部市にある空港';

  @override
  String get tokushima_airport_snippet => '徳島県板野郡松茂町にある飛行場';

  @override
  String get takamatsu_airport_snippet => '香川県高松市にある空港';

  @override
  String get matsuyama_airport_snippet => '愛媛県松山市にある空港';

  @override
  String get kochi_airport_snippet => '高知県南国市にある空港';

  @override
  String get fukuoka_airport_snippet => '福岡県福岡市にある空港';

  @override
  String get kitakyushu_airport_snippet => '福岡県北九州市にある空港';

  @override
  String get saga_airport_snippet => '佐賀県佐賀市にある空港';

  @override
  String get nagasaki_airport_snippet => '長崎県大村市にある空港';

  @override
  String get iki_airport_snippet => '長崎県壱岐市にある空港';

  @override
  String get tsushima_airport_snippet => '長崎県対馬市にある空港';

  @override
  String get fukue_airport_snippet => '長崎県五島市にある空港';

  @override
  String get kumamoto_airport_snippet => '熊本県上益城郡益城町にある空港';

  @override
  String get amakusa_airport_snippet => '熊本県天草市にある空港';

  @override
  String get oita_airport_snippet => '大分県国東市にある空港';

  @override
  String get miyazaki_airport_snippet => '宮崎県宮崎市にある空港';

  @override
  String get kagoshima_airport_snippet => '鹿児島県霧島市にある空港';

  @override
  String get satsuma_airport_snippet => '鹿児島県鹿児島郡三島村にある飛行場';

  @override
  String get tanegashima_airport_snippet => '鹿児島県熊毛郡中種子町にある空港';

  @override
  String get yakushima_airport_snippet => '鹿児島県熊毛郡屋久島町にある空港';

  @override
  String get suwanosejima_airport_snippet => '鹿児島県鹿児島郡十島村にある飛行場';

  @override
  String get amami_airport_snippet => '鹿児島県奄美市にある空港';

  @override
  String get kikai_airport_snippet => '鹿児島県大島郡喜界町にある空港';

  @override
  String get tokunoshima_airport_snippet => '鹿児島県大島郡天城町にある空港';

  @override
  String get okinoerabu_airport_snippet => '鹿児島県大島郡和泊町にある空港';

  @override
  String get yoron_airport_snippet => '鹿児島県大島郡与論町にある空港';

  @override
  String get naha_airport_snippet => '沖縄県那覇市にある空港';

  @override
  String get kumejima_airport_snippet => '沖縄県島尻郡久米島町にある空港';

  @override
  String get kitadaito_airport_snippet => '沖縄県島尻郡北大東村にある空港';

  @override
  String get minamidaito_airport_snippet => '沖縄県島尻郡南大東村にある空港';

  @override
  String get miyako_airport_snippet => '沖縄県宮古島市にある空港';

  @override
  String get shimojishima_airport_snippet => '沖縄県宮古島市にある空港';

  @override
  String get tarama_airport_snippet => '沖縄県宮古郡多良間村にある空港';

  @override
  String get ishigaki_airport_snippet => '沖縄県石垣市にある空港';

  @override
  String get hateruma_airport_snippet => '沖縄県八重山郡竹富町にある空港';

  @override
  String get yonaguni_airport_snippet => '沖縄県八重山郡与那国町にある空港';
}
