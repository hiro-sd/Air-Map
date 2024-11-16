import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Set<Marker> generateMarkers(BuildContext context) {
  final airportData = [
    {
      'id': 'marker_1',
      'position': const LatLng(42.78042, 141.68610),
      'title': AppLocalizations.of(context)!.new_chitose_airport,
      'snippet': '北海道千歳市、苫小牧市にある空港',
    },
    {
      'id': 'marker_2',
      'position': const LatLng(41.77610, 140.81569),
      'title': AppLocalizations.of(context)!.hakodate_airport,
      'snippet': '北海道函館市にある空港',
    },
    {
      'id': 'marker_3',
      'position': const LatLng(43.04593, 144.19604),
      'title': AppLocalizations.of(context)!.kushiro_airport,
      'snippet': '北海道釧路市にある空港',
    },
    {
      'id': 'marker_4',
      'position': const LatLng(43.67397, 142.44662),
      'title': AppLocalizations.of(context)!.asahikawa_airport,
      'snippet': '北海道旭川市にある空港',
    },
    {
      'id': 'marker_5',
      'position': const LatLng(43.88415, 144.15902),
      'title': AppLocalizations.of(context)!.memanbetsu_airport,
      'snippet': '北海道網走郡大空町にある空港',
    },
    {
      'id': 'marker_6',
      'position': const LatLng(43.11759, 141.38029),
      'title': AppLocalizations.of(context)!.okadama_airport,
      'snippet': '北海道札幌市にある空港',
    },
    {
      'id': 'marker_7',
      'position': const LatLng(45.40143, 141.79750),
      'title': AppLocalizations.of(context)!.wakkanai_airport,
      'snippet': '北海道稚内市にある空港',
    },
    {
      'id': 'marker_8',
      'position': const LatLng(42.72958, 143.22172),
      'title': AppLocalizations.of(context)!.obihiro_airport,
      'snippet': '北海道帯広市にある空港',
    },
    {
      'id': 'marker_9',
      'position': const LatLng(45.24600, 141.18043),
      'title': AppLocalizations.of(context)!.rishiri_airport,
      'snippet': '北海道利尻郡利尻富士町にある空港',
    },
    {
      'id': 'marker_10',
      'position': const LatLng(45.45369, 141.04174),
      'title': AppLocalizations.of(context)!.rebun_airport,
      'snippet': '北海道礼文郡礼文町にある空港',
    },
    {
      'id': 'marker_11',
      'position': const LatLng(44.30765, 143.40370),
      'title': AppLocalizations.of(context)!.monbetsu_airport,
      'snippet': '北海道紋別市にある空港',
    },
    {
      'id': 'marker_12',
      'position': const LatLng(43.57638, 144.93922),
      'title': AppLocalizations.of(context)!.nakashibetsu_airport,
      'snippet': '北海道標津郡中標津町にある空港',
    },
    {
      'id': 'marker_13',
      'position': const LatLng(42.07311, 139.43535),
      'title': AppLocalizations.of(context)!.okushiri_airport,
      'snippet': '北海道奥尻郡奥尻町にある空港',
    },
    {
      'id': 'marker_14',
      'position': const LatLng(40.73539, 140.69047),
      'title': AppLocalizations.of(context)!.aomori_airport,
      'snippet': '青森県青森市にある空港',
    },
    {
      'id': 'marker_15',
      'position': const LatLng(40.69645, 141.38776),
      'title': AppLocalizations.of(context)!.misawa_airport,
      'snippet': '青森県三沢市にある空港',
    },
    {
      'id': 'marker_16',
      'position': const LatLng(39.42144, 141.13853),
      'title': AppLocalizations.of(context)!.hanamaki_airport,
      'snippet': '岩手県花巻市にある空港',
    },
    {
      'id': 'marker_17',
      'position': const LatLng(38.13990, 140.91713),
      'title': AppLocalizations.of(context)!.sendai_airport,
      'snippet': '宮城県名取市にある空港',
    },
    {
      'id': 'marker_18',
      'position': const LatLng(40.19393, 140.37213),
      'title': AppLocalizations.of(context)!.odate_noshiro_airport,
      'snippet': '秋田県北秋田市にある空港',
    },
    {
      'id': 'marker_19',
      'position': const LatLng(39.61446, 140.21772),
      'title': AppLocalizations.of(context)!.akita_airport,
      'snippet': '秋田県秋田市にある空港',
    },
    {
      'id': 'marker_20',
      'position': const LatLng(38.81583, 139.78768),
      'title': AppLocalizations.of(context)!.shonai_airport,
      'snippet': '山形県酒田市にある空港',
    },
    {
      'id': 'marker_21',
      'position': const LatLng(38.41223, 140.37035),
      'title': AppLocalizations.of(context)!.yamagata_airport,
      'snippet': '山形県東根市にある空港',
    },
    {
      'id': 'marker_22',
      'position': const LatLng(37.22854, 140.42852),
      'title': AppLocalizations.of(context)!.fukushima_airport,
      'snippet': '福島県玉川村にある空港',
    },
    {
      'id': 'marker_23',
      'position': const LatLng(35.54847, 139.77797),
      'title': AppLocalizations.of(context)!.haneda_airport,
      'snippet': '東京都大田区にある空港',
    },
    {
      'id': 'marker_24',
      'position': const LatLng(34.78248, 139.36357),
      'title': AppLocalizations.of(context)!.oshima_airport,
      'snippet': '東京都大島町にある空港',
    },
    {
      'id': 'marker_25',
      'position': const LatLng(34.37067, 139.26960),
      'title': AppLocalizations.of(context)!.niijima_airport,
      'snippet': '東京都新島村にある空港',
    },
    {
      'id': 'marker_26',
      'position': const LatLng(34.19027, 139.13444),
      'title': AppLocalizations.of(context)!.kouzushima_airport,
      'snippet': '東京都神津島村にある空港',
    },
    {
      'id': 'marker_27',
      'position': const LatLng(34.07293, 139.56008),
      'title': AppLocalizations.of(context)!.miyakejima_airport,
      'snippet': '東京都三宅村にある空港',
    },
    {
      'id': 'marker_28',
      'position': const LatLng(33.11685, 139.78308),
      'title': AppLocalizations.of(context)!.hachijojima_aiport,
      'snippet': '東京都八丈町にある空港',
    },
    {
      'id': 'marker_29',
      'position': const LatLng(35.67264, 139.52990),
      'title': AppLocalizations.of(context)!.chofu_airfield,
      'snippet': '東京都調布市にある飛行場',
    },
    {
      'id': 'marker_30',
      'position': const LatLng(35.77135, 140.38573),
      'title': AppLocalizations.of(context)!.narita_airport,
      'snippet': '千葉県成田市にある空港',
    },
    {
      'id': 'marker_31',
      'position': const LatLng(36.18219, 140.41643),
      'title': AppLocalizations.of(context)!.ibaraki_airport,
      'snippet': '茨城県小美玉市にある空港',
    },
    {
      'id': 'marker_32',
      'position': const LatLng(34.85792, 136.80977),
      'title': AppLocalizations.of(context)!.chubu_airport,
      'snippet': '愛知県常滑市にある空港',
    },
    {
      'id': 'marker_33',
      'position': const LatLng(35.25359, 136.92460),
      'title': AppLocalizations.of(context)!.nagoya_airport,
      'snippet': '愛知県豊山町にある空港',
    },
    {
      'id': 'marker_34',
      'position': const LatLng(36.16466, 137.92643),
      'title': AppLocalizations.of(context)!.matsumoto_airport,
      'snippet': '長野県松本市にある空港',
    },
    {
      'id': 'marker_35',
      'position': const LatLng(37.95253, 139.11339),
      'title': AppLocalizations.of(context)!.niigata_airport,
      'snippet': '新潟県新潟市にある空港',
    },
    {
      'id': 'marker_36',
      'position': const LatLng(38.06229, 138.40870),
      'title': AppLocalizations.of(context)!.sado_airport,
      'snippet': '新潟県佐渡市にある空港',
    },
    {
      'id': 'marker_37',
      'position': const LatLng(36.64837, 137.18761),
      'title': AppLocalizations.of(context)!.toyama_airport,
      'snippet': '富山県富山市にある空港',
    },
    {
      'id': 'marker_38',
      'position': const LatLng(37.29543, 136.95752),
      'title': AppLocalizations.of(context)!.noto_airport,
      'snippet': '石川県輪島市にある空港',
    },
    {
      'id': 'marker_39',
      'position': const LatLng(36.39317, 136.40610),
      'title': AppLocalizations.of(context)!.komatsu_airport,
      'snippet': '石川県小松市にある空港',
    },
    {
      'id': 'marker_40',
      'position': const LatLng(36.14009, 136.22204),
      'title': AppLocalizations.of(context)!.fukui_airport,
      'snippet': '福井県坂井市にある空港',
    },
    {
      'id': 'marker_41',
      'position': const LatLng(34.79710, 138.18672),
      'title': AppLocalizations.of(context)!.shizuoka_airport,
      'snippet': '静岡県牧之原市、島田市にある空港',
    },
    {
      'id': 'marker_42',
      'position': const LatLng(34.43204, 135.23703),
      'title': AppLocalizations.of(context)!.kansai_airport,
      'snippet': '大阪府泉佐野市にある空港',
    },
    {
      'id': 'marker_43',
      'position': const LatLng(34.78617, 135.43809),
      'title': AppLocalizations.of(context)!.itami_airport,
      'snippet': '兵庫県伊丹市にある空港',
    },
    {
      'id': 'marker_44',
      'position': const LatLng(34.63724, 135.22812),
      'title': AppLocalizations.of(context)!.kobe_airport,
      'snippet': '兵庫県神戸市にある空港',
    },
    {
      'id': 'marker_45',
      'position': const LatLng(35.51633, 134.78939),
      'title': AppLocalizations.of(context)!.tajima_airport,
      'snippet': '兵庫県豊岡市にある飛行場',
    },
    {
      'id': 'marker_46',
      'position': const LatLng(33.66218, 135.36057),
      'title': AppLocalizations.of(context)!.shirahama_airport,
      'snippet': '和歌山県西牟婁郡白浜町にある空港',
    },
    {
      'id': 'marker_47',
      'position': const LatLng(35.52659, 134.16801),
      'title': AppLocalizations.of(context)!.tottori_airport,
      'snippet': '鳥取県鳥取市にある空港',
    },
    {
      'id': 'marker_48',
      'position': const LatLng(35.49522, 133.23817),
      'title': AppLocalizations.of(context)!.yonago_airport,
      'snippet': '鳥取県境港市にある空港',
    },
    {
      'id': 'marker_49',
      'position': const LatLng(35.41364, 132.88875),
      'title': AppLocalizations.of(context)!.izumo_airport,
      'snippet': '島根県出雲市にある空港',
    },
    {
      'id': 'marker_50',
      'position': const LatLng(34.67822, 131.79675),
      'title': AppLocalizations.of(context)!.iwami_airport,
      'snippet': '島根県益田市にある空港',
    },
    {
      'id': 'marker_51',
      'position': const LatLng(36.17773, 133.32969),
      'title': AppLocalizations.of(context)!.oki_airport,
      'snippet': '島根県隠岐郡隠岐の島町にある空港',
    },
    {
      'id': 'marker_52',
      'position': const LatLng(34.75819, 133.85584),
      'title': AppLocalizations.of(context)!.okayama_airport,
      'snippet': '岡山県岡山市にある空港',
    },
    {
      'id': 'marker_53',
      'position': const LatLng(34.43729, 132.92070),
      'title': AppLocalizations.of(context)!.hiroshima_airport,
      'snippet': '広島県三原市にある空港',
    },
    {
      'id': 'marker_54',
      'position': const LatLng(34.15887, 132.23475),
      'title': AppLocalizations.of(context)!.iwakuni_airport,
      'snippet': '山口県岩国市にある飛行場',
    },
    {
      'id': 'marker_55',
      'position': const LatLng(33.93132, 131.27853),
      'title': AppLocalizations.of(context)!.ube_airport,
      'snippet': '山口県宇部市にある空港',
    },
    {
      'id': 'marker_56',
      'position': const LatLng(34.13454, 134.61796),
      'title': AppLocalizations.of(context)!.tokushima_airport,
      'snippet': '徳島県板野郡松茂町にある飛行場',
    },
    {
      'id': 'marker_57',
      'position': const LatLng(34.21873, 134.01876),
      'title': AppLocalizations.of(context)!.takamatsu_airport,
      'snippet': '香川県高松市にある空港',
    },
    {
      'id': 'marker_58',
      'position': const LatLng(33.82773, 132.70034),
      'title': AppLocalizations.of(context)!.matsuyama_airport,
      'snippet': '愛媛県松山市にある空港',
    },
    {
      'id': 'marker_59',
      'position': const LatLng(33.54779, 133.67407),
      'title': AppLocalizations.of(context)!.kochi_airport,
      'snippet': '高知県南国市にある空港',
    },
    {
      'id': 'marker_60',
      'position': const LatLng(33.58497, 130.44910),
      'title': AppLocalizations.of(context)!.fukuoka_airport,
      'snippet': '福岡県福岡市にある空港',
    },
    {
      'id': 'marker_61',
      'position': const LatLng(33.83899, 131.03334),
      'title': AppLocalizations.of(context)!.kitakyushu_airport,
      'snippet': '福岡県北九州市にある空港',
    },
    {
      'id': 'marker_62',
      'position': const LatLng(33.15093, 130.30179),
      'title': AppLocalizations.of(context)!.saga_airport,
      'snippet': '佐賀県佐賀市にある空港',
    },
    {
      'id': 'marker_63',
      'position': const LatLng(32.91601, 129.91375),
      'title': AppLocalizations.of(context)!.nagasaki_airport,
      'snippet': '長崎県大村市にある空港',
    },
    {
      'id': 'marker_64',
      'position': const LatLng(33.75026, 129.78407),
      'title': AppLocalizations.of(context)!.iki_airport,
      'snippet': '長崎県壱岐市にある空港',
    },
    {
      'id': 'marker_65',
      'position': const LatLng(34.28591, 129.32607),
      'title': AppLocalizations.of(context)!.tsushima_airport,
      'snippet': '長崎県対馬市にある空港',
    },
    {
      'id': 'marker_66',
      'position': const LatLng(32.66802, 128.83432),
      'title': AppLocalizations.of(context)!.fukue_airport,
      'snippet': '長崎県五島市にある空港',
    },
    {
      'id': 'marker_67',
      'position': const LatLng(32.83524, 130.85900),
      'title': AppLocalizations.of(context)!.kumamoto_airport,
      'snippet': '熊本県上益城郡益城町にある空港',
    },
    {
      'id': 'marker_68',
      'position': const LatLng(32.48258, 130.15929),
      'title': AppLocalizations.of(context)!.amakusa_airport,
      'snippet': '熊本県天草市にある空港',
    },
    {
      'id': 'marker_69',
      'position': const LatLng(33.47964, 131.73623),
      'title': AppLocalizations.of(context)!.oita_airport,
      'snippet': '大分県国東市にある空港',
    },
    {
      'id': 'marker_70',
      'position': const LatLng(31.87274, 131.44141),
      'title': AppLocalizations.of(context)!.miyazaki_airport,
      'snippet': '宮崎県宮崎市にある空港',
    },
    {
      'id': 'marker_71',
      'position': const LatLng(31.80069, 130.72023),
      'title': AppLocalizations.of(context)!.kagoshima_airport,
      'snippet': '鹿児島県霧島市にある空港',
    },
    {
      'id': 'marker_72',
      'position': const LatLng(30.78437, 130.27159),
      'title': AppLocalizations.of(context)!.satsuma_airport,
      'snippet': '鹿児島県鹿児島郡三島村にある飛行場',
    },
    {
      'id': 'marker_73',
      'position': const LatLng(30.60928, 130.99153),
      'title': AppLocalizations.of(context)!.tanegashima_airport,
      'snippet': '鹿児島県熊毛郡中種子町にある空港',
    },
    {
      'id': 'marker_74',
      'position': const LatLng(30.38452, 130.66032),
      'title': AppLocalizations.of(context)!.yakushima_airport,
      'snippet': '鹿児島県熊毛郡屋久島町にある空港',
    },
    {
      'id': 'marker_75',
      'position': const LatLng(29.60860, 129.70101),
      'title': AppLocalizations.of(context)!.suwanosejima_airport,
      'snippet': '鹿児島県鹿児島郡十島村にある飛行場',
    },
    {
      'id': 'marker_76',
      'position': const LatLng(28.43066, 129.71131),
      'title': AppLocalizations.of(context)!.amami_airport,
      'snippet': '鹿児島県奄美市にある空港',
    },
    {
      'id': 'marker_77',
      'position': const LatLng(28.31980, 129.92746),
      'title': AppLocalizations.of(context)!.kikai_airport,
      'snippet': '鹿児島県大島郡喜界町にある空港',
    },
    {
      'id': 'marker_78',
      'position': const LatLng(27.83227, 128.88321),
      'title': AppLocalizations.of(context)!.tokunoshima_airport,
      'snippet': '鹿児島県大島郡天城町にある空港',
    },
    {
      'id': 'marker_79',
      'position': const LatLng(27.43317, 128.70476),
      'title': AppLocalizations.of(context)!.okinoerabu_airport,
      'snippet': '鹿児島県大島郡和泊町にある空港',
    },
    {
      'id': 'marker_80',
      'position': const LatLng(27.04309, 128.39995),
      'title': AppLocalizations.of(context)!.yoron_airport,
      'snippet': '鹿児島県大島郡与論町にある空港',
    },
    {
      'id': 'marker_81',
      'position': const LatLng(26.20012, 127.64659),
      'title': AppLocalizations.of(context)!.naha_airport,
      'snippet': '沖縄県那覇市にある空港',
    },
    {
      'id': 'marker_82',
      'position': const LatLng(26.36492, 126.71749),
      'title': AppLocalizations.of(context)!.kumejima_airport,
      'snippet': '沖縄県島尻郡久米島町にある空港',
    },
    {
      'id': 'marker_83',
      'position': const LatLng(25.94448, 131.32441),
      'title': AppLocalizations.of(context)!.kitadaito_airport,
      'snippet': '沖縄県島尻郡北大東村にある空港',
    },
    {
      'id': 'marker_84',
      'position': const LatLng(25.84603, 131.26547),
      'title': AppLocalizations.of(context)!.minamidaito_airport,
      'snippet': '沖縄県島尻郡南大東村にある空港',
    },
    {
      'id': 'marker_85',
      'position': const LatLng(24.77929, 125.29763),
      'title': AppLocalizations.of(context)!.miyako_airport,
      'snippet': '沖縄県宮古島市にある空港',
    },
    {
      'id': 'marker_86',
      'position': const LatLng(24.82925, 125.14948),
      'title': AppLocalizations.of(context)!.shimojishima_airport,
      'snippet': '沖縄県宮古島市にある空港',
    },
    {
      'id': 'marker_87',
      'position': const LatLng(24.65409, 124.67739),
      'title': AppLocalizations.of(context)!.tarama_airport,
      'snippet': '沖縄県宮古郡多良間村にある空港',
    },
    {
      'id': 'marker_88',
      'position': const LatLng(24.39599, 124.24578),
      'title': AppLocalizations.of(context)!.ishigaki_airport,
      'snippet': '沖縄県石垣市にある空港',
    },
    {
      'id': 'marker_89',
      'position': const LatLng(24.06028, 123.80456),
      'title': AppLocalizations.of(context)!.hateruma_airport,
      'snippet': '沖縄県八重山郡竹富町にある空港',
    },
    {
      'id': 'marker_90',
      'position': const LatLng(24.46521, 122.97988),
      'title': AppLocalizations.of(context)!.yonaguni_airport,
      'snippet': '沖縄県八重山郡与那国町にある空港',
    }
  ];

  return airportData.map((airport) {
    return Marker(
        markerId: MarkerId(airport['id'] as String),
        position: airport['position'] as LatLng,
        infoWindow: InfoWindow(
          title: airport['title'] as String,
          snippet: airport['snippet'] as String,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            barrierColor: Colors.black.withOpacity(0.2),
            builder: (context) {
              return FractionallySizedBox(
                  heightFactor: 0.48,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.set_destination,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          airport['title'] as String,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 230),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // BottomSheetを閉じる
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // BottomSheetを閉じる
                                // ここで目的地を確定し、他の処理を実行可能
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .set_complete)),
                                );
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.confirm),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          );
        });
  }).toSet();
}
// TODO: マーカーの文字列l10n化
// TODO: リファクタリング