import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 日本国内の空港データ
final List<Map<String, dynamic>> airportData = [
  {
    'id': 'marker_1',
    'position': const LatLng(42.78042, 141.68610),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.new_chitose_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.new_chitose_airport_snippet,
    'IATA': 'CTS',
  },
  {
    'id': 'marker_2',
    'position': const LatLng(41.77610, 140.81569),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.hakodate_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.hakodate_airport_snippet,
    "IATA": 'HKD',
  },
  {
    'id': 'marker_3',
    'position': const LatLng(43.04509909852728, 144.19628336688587),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kushiro_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kushiro_airport_snippet,
    'IATA': 'KUH',
  },
  {
    'id': 'marker_4',
    'position': const LatLng(43.671548264542935, 142.44683010621156),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.asahikawa_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.asahikawa_airport_snippet,
    'IATA': 'AKJ',
  },
  {
    'id': 'marker_5',
    'position': const LatLng(43.881638359526875, 144.15856863103053),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.memanbetsu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.memanbetsu_airport_snippet,
    'IATA': 'MMB',
  },
  {
    'id': 'marker_6',
    'position': const LatLng(43.11759, 141.38029),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.okadama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.okadama_airport_snippet,
    'IATA': 'OKD',
  },
  {
    'id': 'marker_7',
    'position': const LatLng(45.40143, 141.79750),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.wakkanai_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.wakkanai_airport_snippet,
    'IATA': 'WKJ',
  },
  {
    'id': 'marker_8',
    'position': const LatLng(42.731235134537904, 143.2177599863364),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.obihiro_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.obihiro_airport_snippet,
    'IATA': 'OBO',
  },
  {
    'id': 'marker_9',
    'position': const LatLng(45.2439829789367, 141.1840988874117),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.rishiri_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.rishiri_airport_snippet,
    'IATA': 'RIS',
  },
  {
    'id': 'marker_10',
    'position': const LatLng(45.45369, 141.04174),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.rebun_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.rebun_airport_snippet,
    'IATA': 'RBJ',
  },
  {
    'id': 'marker_11',
    'position': const LatLng(44.30639700967616, 143.40684120556202),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.monbetsu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.monbetsu_airport_snippet,
    'IATA': 'MBE',
  },
  {
    'id': 'marker_12',
    'position': const LatLng(43.572853674412755, 144.95616246968882),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.nakashibetsu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.nakashibetsu_airport_snippet,
    'IATA': 'SHB',
  },
  {
    'id': 'marker_13',
    'position': const LatLng(42.07311, 139.43535),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.okushiri_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.okushiri_airport_snippet,
    'IATA': 'OIR',
  },
  {
    'id': 'marker_14',
    'position': const LatLng(40.73539, 140.69047),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.aomori_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.aomori_airport_snippet,
    'IATA': 'AOJ',
  },
  {
    'id': 'marker_15',
    'position': const LatLng(40.69645, 141.38776),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.misawa_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.misawa_airport_snippet,
    'IATA': 'MSJ',
  },
  {
    'id': 'marker_16',
    'position': const LatLng(39.42144, 141.13853),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.hanamaki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.hanamaki_airport_snippet,
    'IATA': 'HNA',
  },
  {
    'id': 'marker_17',
    'position': const LatLng(38.13990, 140.91713),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.sendai_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.sendai_airport_snippet,
    'IATA': 'SDJ',
  },
  {
    'id': 'marker_18',
    'position': const LatLng(40.19393, 140.37213),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.odate_noshiro_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.odate_noshiro_airport_snippet,
    'IATA': 'ONJ',
  },
  {
    'id': 'marker_19',
    'position': const LatLng(39.61446, 140.21772),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.akita_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.akita_airport_snippet,
    'IATA': 'AXT',
  },
  {
    'id': 'marker_20',
    'position': const LatLng(38.81583, 139.78768),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.shonai_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.shonai_airport_snippet,
    'IATA': 'SYO',
  },
  {
    'id': 'marker_21',
    'position': const LatLng(38.41223, 140.37035),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.yamagata_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.yamagata_airport_snippet,
    'IATA': 'GAJ',
  },
  {
    'id': 'marker_22',
    'position': const LatLng(37.22854, 140.42852),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.fukushima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.fukushima_airport_snippet,
    'IATA': 'FKS',
  },
  {
    'id': 'marker_23',
    'position': const LatLng(35.54847, 139.77797),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.haneda_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.haneda_airport_snippet,
    'IATA': 'HND',
  },
  {
    'id': 'marker_24',
    'position': const LatLng(34.78248, 139.36357),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.oshima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.oshima_airport_snippet,
    'IATA': 'OIM',
  },
  // {
  //   'id': 'marker_25',
  //   'position': const LatLng(34.37067, 139.26960),
  //   'title': (BuildContext context) =>
  //       AppLocalizations.of(context)!.niijima_airport,
  //   'snippet': (BuildContext context) =>
  //       AppLocalizations.of(context)!.niijima_airport_snippet,
  // },
  // {
  //   'id': 'marker_26',
  //   'position': const LatLng(34.19027, 139.13444),
  //   'title': (BuildContext context) =>
  //       AppLocalizations.of(context)!.kouzushima_airport,
  //   'snippet': (BuildContext context) =>
  //       AppLocalizations.of(context)!.kouzushima_airport_snippet,
  // },
  {
    'id': 'marker_27',
    'position': const LatLng(34.07293, 139.56008),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.miyakejima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.miyakejima_airport_snippet,
    "IATA": 'MYE',
  },
  {
    'id': 'marker_28',
    'position': const LatLng(33.11685, 139.78308),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.hachijojima_aiport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.hachijojima_airport_snippet,
    "IATA": 'HAC',
  },
  // {
  //   'id': 'marker_29',
  //   'position': const LatLng(35.67264, 139.52990),
  //   'title': (BuildContext context) =>
  //       AppLocalizations.of(context)!.chofu_airfield,
  //   'snippet': (BuildContext context) =>
  //       AppLocalizations.of(context)!.chofu_airfield_snippet,
  // },
  {
    'id': 'marker_30',
    'position': const LatLng(35.77135, 140.38573),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.narita_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.narita_airport_snippet,
    'IATA': 'NRT',
  },
  {
    'id': 'marker_31',
    'position': const LatLng(36.18219, 140.41643),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.ibaraki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.ibaraki_airport_snippet,
    'IATA': 'IBR',
  },
  {
    'id': 'marker_32',
    'position': const LatLng(34.85792, 136.80977),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.chubu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.chubu_airport_snippet,
    'IATA': 'NGO',
  },
  {
    'id': 'marker_33',
    'position': const LatLng(35.25359, 136.92460),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.nagoya_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.nagoya_airport_snippet,
    'IATA': 'NKM',
  },
  {
    'id': 'marker_34',
    'position': const LatLng(36.16466, 137.92643),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.matsumoto_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.matsumoto_airport_snippet,
    "IATA": 'MMJ',
  },
  {
    'id': 'marker_35',
    'position': const LatLng(37.95253, 139.11339),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.niigata_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.niigata_airport_snippet,
    'IATA': 'KIJ',
  },
  {
    'id': 'marker_36',
    'position': const LatLng(38.06229, 138.40870),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.sado_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.sado_airport_snippet,
    "IATA": 'SDS',
  },
  {
    'id': 'marker_37',
    'position': const LatLng(36.64837, 137.18761),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.toyama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.toyama_airport_snippet,
    'IATA': 'TOY',
  },
  {
    'id': 'marker_38',
    'position': const LatLng(37.29543, 136.95752),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.noto_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.noto_airport_snippet,
    'IATA': 'NTQ',
  },
  {
    'id': 'marker_39',
    'position': const LatLng(36.39317, 136.40610),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.komatsu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.komatsu_airport_snippet,
    'IATA': 'KMQ',
  },
  {
    'id': 'marker_40',
    'position': const LatLng(36.14009, 136.22204),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.fukui_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.fukui_airport_snippet,
    'IATA': 'FKJ',
  },
  {
    'id': 'marker_41',
    'position': const LatLng(34.79710, 138.18672),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.shizuoka_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.shizuoka_airport_snippet,
    'IATA': 'FSZ',
  },
  {
    'id': 'marker_42',
    'position': const LatLng(34.43204, 135.23703),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kansai_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kansai_airport_snippet,
    'IATA': 'KIX',
  },
  {
    'id': 'marker_43',
    'position': const LatLng(34.78617, 135.43809),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.itami_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.itami_airport_snippet,
    'IATA': 'ITM',
  },
  {
    'id': 'marker_44',
    'position': const LatLng(34.63724, 135.22812),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kobe_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kobe_airport_snippet,
    'IATA': 'UKB',
  },
  {
    'id': 'marker_45',
    'position': const LatLng(35.51633, 134.78939),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tajima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tajima_airport_snippet,
    'IATA': 'TJH',
  },
  {
    'id': 'marker_46',
    'position': const LatLng(33.66218, 135.36057),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.shirahama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.shirahama_airport_snippet,
    'IATA': 'SHM',
  },
  {
    'id': 'marker_47',
    'position': const LatLng(35.52659, 134.16801),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tottori_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tottori_airport_snippet,
    'IATA': 'TTJ',
  },
  {
    'id': 'marker_48',
    'position': const LatLng(35.49522, 133.23817),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.yonago_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.yonago_airport_snippet,
    'IATA': 'YGJ',
  },
  {
    'id': 'marker_49',
    'position': const LatLng(35.41364, 132.88875),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.izumo_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.izumo_airport_snippet,
    'IATA': 'IZO',
  },
  {
    'id': 'marker_50',
    'position': const LatLng(34.67822, 131.79675),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.iwami_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.iwami_airport_snippet,
    'IATA': 'IWJ',
  },
  {
    'id': 'marker_51',
    'position': const LatLng(36.17773, 133.32969),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.oki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.oki_airport_snippet,
    'IATA': 'OKI',
  },
  {
    'id': 'marker_52',
    'position': const LatLng(34.75819, 133.85584),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.okayama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.okayama_airport_snippet,
    'IATA': 'OKJ',
  },
  {
    'id': 'marker_53',
    'position': const LatLng(34.43729, 132.92070),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.hiroshima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.hiroshima_airport_snippet,
    'IATA': 'HIJ',
  },
  {
    'id': 'marker_54',
    'position': const LatLng(34.15887, 132.23475),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.iwakuni_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.iwakuni_airport_snippet,
    'IATA': 'IWK',
  },
  {
    'id': 'marker_55',
    'position': const LatLng(33.93132, 131.27853),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.ube_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.ube_airport_snippet,
    'IATA': 'UBJ',
  },
  {
    'id': 'marker_56',
    'position': const LatLng(34.13454, 134.61796),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tokushima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tokushima_airport_snippet,
    'IATA': 'TKS',
  },
  {
    'id': 'marker_57',
    'position': const LatLng(34.21486920230928, 134.01470943690953),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.takamatsu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.takamatsu_airport_snippet,
    'IATA': 'TAK',
  },
  {
    'id': 'marker_58',
    'position': const LatLng(33.82773, 132.70034),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.matsuyama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.matsuyama_airport_snippet,
    'IATA': 'MYJ',
  },
  {
    'id': 'marker_59',
    'position': const LatLng(33.54779, 133.67407),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kochi_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kochi_airport_snippet,
    'IATA': 'KCZ',
  },
  {
    'id': 'marker_60',
    'position': const LatLng(33.58497, 130.44910),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.fukuoka_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.fukuoka_airport_snippet,
    'IATA': 'FUK',
  },
  {
    'id': 'marker_61',
    'position': const LatLng(33.83899, 131.03334),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kitakyushu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kitakyushu_airport_snippet,
    'IATA': 'KKJ',
  },
  {
    'id': 'marker_62',
    'position': const LatLng(33.15093, 130.30179),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.saga_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.saga_airport_snippet,
    'IATA': 'HSG',
  },
  {
    'id': 'marker_63',
    'position': const LatLng(32.91601, 129.91375),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.nagasaki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.nagasaki_airport_snippet,
    'IATA': 'NGS',
  },
  {
    'id': 'marker_64',
    'position': const LatLng(33.75026, 129.78407),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.iki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.iki_airport_snippet,
    'IATA': 'IKI',
  },
  {
    'id': 'marker_65',
    'position': const LatLng(34.28591, 129.32607),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tsushima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tsushima_airport_snippet,
    'IATA': 'TSJ',
  },
  {
    'id': 'marker_66',
    'position': const LatLng(32.66802, 128.83432),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.fukue_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.fukue_airport_snippet,
    'IATA': 'FUJ',
  },
  {
    'id': 'marker_67',
    'position': const LatLng(32.83524, 130.85900),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kumamoto_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kumamoto_airport_snippet,
    'IATA': 'KMJ',
  },
  {
    'id': 'marker_68',
    'position': const LatLng(32.48258, 130.15929),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.amakusa_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.amakusa_airport_snippet,
    'IATA': 'AXJ',
  },
  {
    'id': 'marker_69',
    'position': const LatLng(33.47964, 131.73623),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.oita_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.oita_airport_snippet,
    "IATA": 'OIT',
  },
  {
    'id': 'marker_70',
    'position': const LatLng(31.8762045258875, 131.44840012968373),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.miyazaki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.miyazaki_airport_snippet,
    'IATA': 'KMI',
  },
  {
    'id': 'marker_71',
    'position': const LatLng(31.80069, 130.72023),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kagoshima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kagoshima_airport_snippet,
    'IATA': 'KOJ',
  },
  // {
  //   'id': 'marker_72',
  //   'position': const LatLng(30.78437, 130.27159),
  //   'title': (BuildContext context) =>
  //       AppLocalizations.of(context)!.satsuma_airport,
  //   'snippet': (BuildContext context) =>
  //       AppLocalizations.of(context)!.satsuma_airport_snippet,
  // },
  {
    'id': 'marker_73',
    'position': const LatLng(30.60928, 130.99153),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tanegashima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tanegashima_airport_snippet,
    'IATA': 'TNE',
  },
  {
    'id': 'marker_74',
    'position': const LatLng(30.38452, 130.66032),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.yakushima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.yakushima_airport_snippet,
    'IATA': 'KUM',
  },
  // {
  //   'id': 'marker_75',
  //   'position': const LatLng(29.60860, 129.70101),
  //   'title': (BuildContext context) =>
  //       AppLocalizations.of(context)!.suwanosejima_airport,
  //   'snippet': (BuildContext context) =>
  //       AppLocalizations.of(context)!.suwanosejima_airport_snippet,
  // },
  {
    'id': 'marker_76',
    'position': const LatLng(28.43066, 129.71131),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.amami_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.amami_airport_snippet,
    'IATA': 'ASJ',
  },
  {
    'id': 'marker_77',
    'position': const LatLng(28.31980, 129.92746),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kikai_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kikai_airport_snippet,
    "IATA": 'KKX',
  },
  {
    'id': 'marker_78',
    'position': const LatLng(27.83227, 128.88321),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tokunoshima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tokunoshima_airport_snippet,
    'IATA': 'TKN',
  },
  {
    'id': 'marker_79',
    'position': const LatLng(27.43317, 128.70476),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.okinoerabu_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.okinoerabu_airport_snippet,
    'IATA': 'OKE',
  },
  {
    'id': 'marker_80',
    'position': const LatLng(27.04309, 128.39995),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.yoron_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.yoron_airport_snippet,
    "IATA": 'RNJ',
  },
  {
    'id': 'marker_81',
    'position': const LatLng(26.20012, 127.64659),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.naha_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.naha_airport_snippet,
    'IATA': 'OKA',
  },
  {
    'id': 'marker_82',
    'position': const LatLng(26.36492, 126.71749),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kumejima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kumejima_airport_snippet,
    'IATA': 'UEO',
  },
  {
    'id': 'marker_83',
    'position': const LatLng(25.94448, 131.32441),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.kitadaito_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.kitadaito_airport_snippet,
    "IATA": 'KTD',
  },
  {
    'id': 'marker_84',
    'position': const LatLng(25.84603, 131.26547),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.minamidaito_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.minamidaito_airport_snippet,
    "IATA": 'MMD',
  },
  {
    'id': 'marker_85',
    'position': const LatLng(24.77929, 125.29763),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.miyako_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.miyako_airport_snippet,
    "IATA": 'MMY',
  },
  {
    'id': 'marker_86',
    'position': const LatLng(24.82717204931966, 125.14708543452318),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.shimojishima_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.shimojishima_airport_snippet,
    "IATA": 'SHI',
  },
  {
    'id': 'marker_87',
    'position': const LatLng(24.65409, 124.67739),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.tarama_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.tarama_airport_snippet,
    "IATA": 'TRA',
  },
  {
    'id': 'marker_88',
    'position': const LatLng(24.39599, 124.24578),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.ishigaki_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.ishigaki_airport_snippet,
    "IATA": 'ISG',
  },
  {
    'id': 'marker_89',
    'position': const LatLng(24.06028, 123.80456),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.hateruma_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.hateruma_airport_snippet,
    "IATA": 'HTR',
  },
  {
    'id': 'marker_90',
    'position': const LatLng(24.46521, 122.97988),
    'title': (BuildContext context) =>
        AppLocalizations.of(context)!.yonaguni_airport,
    'snippet': (BuildContext context) =>
        AppLocalizations.of(context)!.yonaguni_airport_snippet,
    "IATA": 'OGN',
  }
];
