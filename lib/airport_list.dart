import 'package:google_maps_flutter/google_maps_flutter.dart';

// 北海道の空港
const LatLng airport1 = LatLng(42.78042, 141.68610); //新千歳空港
const LatLng airport2 = LatLng(41.77610, 140.81569); //函館空港
const LatLng airport3 = LatLng(43.04593, 144.19604); //釧路空港
const LatLng airport4 = LatLng(43.67397, 142.44662); //旭川空港
const LatLng airport5 = LatLng(43.88415, 144.15902); //女満別空港
const LatLng airport6 = LatLng(43.11759, 141.38029); //丘珠空港
const LatLng airport7 = LatLng(45.40143, 141.79750); //稚内空港
const LatLng airport8 = LatLng(42.72958, 143.22172); //帯広空港
const LatLng airport9 = LatLng(45.24600, 141.18043); //利尻空港
const LatLng airport10 = LatLng(45.45369, 141.04174); //礼文空港
const LatLng airport11 = LatLng(44.30765, 143.40370); //紋別空港
const LatLng airport12 = LatLng(43.57638, 144.93922); //中標津空港
const LatLng airport13 = LatLng(42.07311, 139.43535); //奥尻空港

//　東北の空港
const LatLng airport14 = LatLng(40.73539, 140.69047); //青森空港
const LatLng airport15 = LatLng(40.69645, 141.38776); //三沢空港
const LatLng airport16 = LatLng(39.42144, 141.13853); //花巻空港
const LatLng airport17 = LatLng(38.13990, 140.91713); //仙台空港
const LatLng airport18 = LatLng(40.19393, 140.37213); //大館能代空港
const LatLng airport19 = LatLng(39.61446, 140.21772); //秋田空港
const LatLng airport20 = LatLng(38.81583, 139.78768); //庄内空港
const LatLng airport21 = LatLng(38.41223, 140.37035); //山形空港
const LatLng airport22 = LatLng(37.22854, 140.42852); //福島空港

// 関東の空港
const LatLng airport23 = LatLng(35.54847, 139.77797); //羽田空港
const LatLng airport24 = LatLng(34.78248, 139.36357); //大島空港
const LatLng airport25 = LatLng(34.37067, 139.26960); //新島空港
const LatLng airport26 = LatLng(34.19027, 139.13444); //神津島空港
const LatLng airport27 = LatLng(34.07293, 139.56008); //三宅島空港
const LatLng airport28 = LatLng(33.11685, 139.78308); //八丈島空港
const LatLng airport29 = LatLng(35.67264, 139.52990); //調布飛行場
const LatLng airport30 = LatLng(35.77135, 140.38573); //成田国際空港
const LatLng airport31 = LatLng(36.18219, 140.41643); //茨城空港

// 中部の空港
const LatLng airport32 = LatLng(34.85792, 136.80977); //中部国際空港
const LatLng airport33 = LatLng(35.25359, 136.92460); //県営名古屋空港
const LatLng airport34 = LatLng(36.16466, 137.92643); //松本空港
const LatLng airport35 = LatLng(37.95253, 139.11339); //新潟空港
const LatLng airport36 = LatLng(38.06229, 138.40870); //佐渡空港
const LatLng airport37 = LatLng(36.64837, 137.18761); //富山空港
const LatLng airport38 = LatLng(37.29543, 136.95752); //能登空港
const LatLng airport39 = LatLng(36.39317, 136.40610); //小松空港
const LatLng airport40 = LatLng(36.14009, 136.22204); //福井空港
const LatLng airport41 = LatLng(34.79710, 138.18672); //静岡空港

// 近畿の空港
const LatLng airport42 = LatLng(34.43204, 135.23703); //関西国際空港
const LatLng airport43 = LatLng(34.78617, 135.43809); //伊丹空港
const LatLng airport44 = LatLng(34.63724, 135.22812); //神戸空港
const LatLng airport45 = LatLng(35.51633, 134.78939); //但馬飛行場
const LatLng airport46 = LatLng(33.66218, 135.36057); //南紀白浜空港

// 中国の空港
const LatLng airport47 = LatLng(35.52659, 134.16801); //鳥取空港
const LatLng airport48 = LatLng(35.49522, 133.23817); //米子空港
const LatLng airport49 = LatLng(35.41364, 132.88875); //出雲空港
const LatLng airport50 = LatLng(34.67822, 131.79675); //石見空港
const LatLng airport51 = LatLng(36.17773, 133.32969); //隠岐空港
const LatLng airport52 = LatLng(34.75819, 133.85584); //岡山空港
const LatLng airport53 = LatLng(34.43729, 132.92070); //広島空港
const LatLng airport54 = LatLng(34.15887, 132.23475); //岩国飛行場
const LatLng airport55 = LatLng(33.93132, 131.27853); //山口宇部空港

// 四国の空港
const LatLng airport56 = LatLng(34.13454, 134.61796); //徳島飛行場
const LatLng airport57 = LatLng(34.21873, 134.01876); //高松空港
const LatLng airport58 = LatLng(33.82773, 132.70034); //松山空港
const LatLng airport59 = LatLng(33.54779, 133.67407); //高知空港

// 九州の空港
const LatLng airport60 = LatLng(33.58497, 130.44910); //福岡空港
const LatLng airport61 = LatLng(33.83899, 131.03334); //北九州空港
const LatLng airport62 = LatLng(33.15093, 130.30179); //佐賀空港
const LatLng airport63 = LatLng(32.91601, 129.91375); //長崎空港
const LatLng airport64 = LatLng(33.75026, 129.78407); //壱岐空港
const LatLng airport65 = LatLng(34.28591, 129.32607); //対馬空港
const LatLng airport66 = LatLng(32.66802, 128.83432); //福江空港
const LatLng airport67 = LatLng(32.83524, 130.85900); //熊本空港
const LatLng airport68 = LatLng(32.48258, 130.15929); //天草空港
const LatLng airport69 = LatLng(33.47964, 131.73623); //大分空港
const LatLng airport70 = LatLng(31.87274, 131.44141); //宮崎空港
const LatLng airport71 = LatLng(31.80069, 130.72023); //鹿児島空港
const LatLng airport72 = LatLng(30.78437, 130.27159); //薩摩硫黄島飛行場
const LatLng airport73 = LatLng(30.60928, 130.99153); //種子島空港
const LatLng airport74 = LatLng(30.38452, 130.66032); //屋久島空港
const LatLng airport75 = LatLng(29.60860, 129.70101); //諏訪之瀬島飛行場
const LatLng airport76 = LatLng(28.43066, 129.71131); //奄美空港
const LatLng airport77 = LatLng(28.31980, 129.92746); //喜界空港
const LatLng airport78 = LatLng(27.83227, 128.88321); //徳之島空港
const LatLng airport79 = LatLng(27.43317, 128.70476); //沖永良部空港
const LatLng airport80 = LatLng(27.04309, 128.39995); //与論空港

// 沖縄の空港
const LatLng airport81 = LatLng(26.20012, 127.64659); //那覇空港
const LatLng airport82 = LatLng(26.36492, 126.71749); //久米島空港
const LatLng airport83 = LatLng(25.94448, 131.32441); //北大東空港
const LatLng airport84 = LatLng(25.84603, 131.26547); //南大東空港
const LatLng airport85 = LatLng(24.77929, 125.29763); //宮古空港
const LatLng airport86 = LatLng(24.82925, 125.14948); //下地島空港
const LatLng airport87 = LatLng(24.65409, 124.67739); //多良間空港
const LatLng airport88 = LatLng(24.39599, 124.24578); //新石垣空港
const LatLng airport89 = LatLng(24.06028, 123.80456); //波照間空港
const LatLng airport90 = LatLng(24.46521, 122.97988); //与那国空港

// TODO: リファクタリング

final airports = {
  const Marker(
    markerId: MarkerId('marker_1'),
    position: airport1,
    infoWindow: InfoWindow(
      title: '新千歳空港を行き先に設定しますか？',
      snippet: '北海道千歳市,苫小牧市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_2'),
    position: airport2,
    infoWindow: InfoWindow(
      title: '函館空港を行き先に設定しますか？',
      snippet: '北海道函館市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_3'),
    position: airport3,
    infoWindow: InfoWindow(
      title: '釧路空港',
      snippet: '北海道釧路市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_4'),
    position: airport4,
    infoWindow: InfoWindow(
      title: '旭川空港',
      snippet: '北海道旭川市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_5'),
    position: airport5,
    infoWindow: InfoWindow(
      title: '女満別空港',
      snippet: '北海道網走郡大空町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_6'),
    position: airport6,
    infoWindow: InfoWindow(
      title: '丘珠空港',
      snippet: '北海道札幌市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_7'),
    position: airport7,
    infoWindow: InfoWindow(
      title: '稚内空港',
      snippet: '北海道稚内市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_8'),
    position: airport8,
    infoWindow: InfoWindow(
      title: '帯広空港',
      snippet: '北海道帯広市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_9'),
    position: airport9,
    infoWindow: InfoWindow(
      title: '利尻空港',
      snippet: '北海道利尻郡利尻富士町にある日本最北端の空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_10'),
    position: airport10,
    infoWindow: InfoWindow(
      title: '礼文空港',
      snippet: '北海道礼文郡礼文町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_11'),
    position: airport11,
    infoWindow: InfoWindow(
      title: '紋別空港',
      snippet: '北海道紋別市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_12'),
    position: airport12,
    infoWindow: InfoWindow(
      title: '中標津空港',
      snippet: '北海道標津郡中標津町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_13'),
    position: airport13,
    infoWindow: InfoWindow(
      title: '奥尻空港',
      snippet: '北海道奥尻郡奥尻町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_14'),
    position: airport14,
    infoWindow: InfoWindow(
      title: '青森空港',
      snippet: '青森県青森市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_15'),
    position: airport15,
    infoWindow: InfoWindow(
      title: '三沢飛行場',
      snippet: '青森県三沢市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_16'),
    position: airport16,
    infoWindow: InfoWindow(
      title: '花巻空港',
      snippet: '岩手県花巻市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_17'),
    position: airport17,
    infoWindow: InfoWindow(
      title: '仙台空港',
      snippet: '宮城県名取市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_18'),
    position: airport18,
    infoWindow: InfoWindow(
      title: '大館能代空港',
      snippet: '秋田県北秋田市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_19'),
    position: airport19,
    infoWindow: InfoWindow(
      title: '秋田空港',
      snippet: '秋田県秋田市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_20'),
    position: airport20,
    infoWindow: InfoWindow(
      title: '庄内空港',
      snippet: '山形県酒田市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_21'),
    position: airport21,
    infoWindow: InfoWindow(
      title: '山形空港',
      snippet: '山形県東根市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_22'),
    position: airport22,
    infoWindow: InfoWindow(
      title: '福島空港',
      snippet: '福島県玉川村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_23'),
    position: airport23,
    infoWindow: InfoWindow(
      title: '羽田空港',
      snippet: '東京都大田区にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_24'),
    position: airport24,
    infoWindow: InfoWindow(
      title: '大島空港',
      snippet: '東京都大島町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_25'),
    position: airport25,
    infoWindow: InfoWindow(
      title: '新島空港',
      snippet: '東京都新島村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_26'),
    position: airport26,
    infoWindow: InfoWindow(
      title: '神津島空港',
      snippet: '東京都神津島村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_27'),
    position: airport27,
    infoWindow: InfoWindow(
      title: '三宅島空港',
      snippet: '東京都三宅村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_28'),
    position: airport28,
    infoWindow: InfoWindow(
      title: '八丈島空港',
      snippet: '東京都八丈町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_29'),
    position: airport29,
    infoWindow: InfoWindow(
      title: '調布飛行場',
      snippet: '東京都調布市にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_30'),
    position: airport30,
    infoWindow: InfoWindow(
      title: '成田空港',
      snippet: '千葉県成田市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_31'),
    position: airport31,
    infoWindow: InfoWindow(
      title: '茨城空港',
      snippet: '茨城県小美玉市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_32'),
    position: airport32,
    infoWindow: InfoWindow(
      title: '中部国際空港',
      snippet: '愛知県常滑市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_33'),
    position: airport33,
    infoWindow: InfoWindow(
      title: '県営名古屋空港',
      snippet: '愛知県豊山町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_34'),
    position: airport34,
    infoWindow: InfoWindow(
      title: '松本空港',
      snippet: '長野県松本市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_35'),
    position: airport35,
    infoWindow: InfoWindow(
      title: '新潟空港',
      snippet: '新潟県新潟市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_36'),
    position: airport36,
    infoWindow: InfoWindow(
      title: '佐渡空港',
      snippet: '新潟県佐渡市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_37'),
    position: airport37,
    infoWindow: InfoWindow(
      title: '富山空港',
      snippet: '富山県富山市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_38'),
    position: airport38,
    infoWindow: InfoWindow(
      title: '能登空港',
      snippet: '石川県輪島市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_39'),
    position: airport39,
    infoWindow: InfoWindow(
      title: '小松空港',
      snippet: '石川県小松市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_40'),
    position: airport40,
    infoWindow: InfoWindow(
      title: '福井空港',
      snippet: '福井県坂井市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_41'),
    position: airport41,
    infoWindow: InfoWindow(
      title: '静岡空港',
      snippet: '静岡県牧之原市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_42'),
    position: airport42,
    infoWindow: InfoWindow(
      title: '関西国際空港',
      snippet: '大阪府泉佐野市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_43'),
    position: airport43,
    infoWindow: InfoWindow(
      title: '伊丹空港',
      snippet: '兵庫県伊丹市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_44'),
    position: airport44,
    infoWindow: InfoWindow(
      title: '神戸空港',
      snippet: '兵庫県神戸市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_45'),
    position: airport45,
    infoWindow: InfoWindow(
      title: '但馬飛行場',
      snippet: '兵庫県豊岡市にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_46'),
    position: airport46,
    infoWindow: InfoWindow(
      title: '南紀白浜空港',
      snippet: '和歌山県西牟婁郡白浜町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_47'),
    position: airport47,
    infoWindow: InfoWindow(
      title: '鳥取空港',
      snippet: '鳥取県鳥取市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_48'),
    position: airport48,
    infoWindow: InfoWindow(
      title: '米子空港',
      snippet: '鳥取県境港市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_49'),
    position: airport49,
    infoWindow: InfoWindow(
      title: '出雲空港',
      snippet: '島根県出雲市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_50'),
    position: airport50,
    infoWindow: InfoWindow(
      title: '石見空港',
      snippet: '島根県益田市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_51'),
    position: airport51,
    infoWindow: InfoWindow(
      title: '隠岐空港',
      snippet: '島根県隠岐郡隠岐の島町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_52'),
    position: airport52,
    infoWindow: InfoWindow(
      title: '岡山空港',
      snippet: '岡山県岡山市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_53'),
    position: airport53,
    infoWindow: InfoWindow(
      title: '広島空港',
      snippet: '広島県三原市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_54'),
    position: airport54,
    infoWindow: InfoWindow(
      title: '岩国飛行場',
      snippet: '山口県岩国市にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_55'),
    position: airport55,
    infoWindow: InfoWindow(
      title: '山口宇部空港',
      snippet: '山口県宇部市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_56'),
    position: airport56,
    infoWindow: InfoWindow(
      title: '徳島飛行場',
      snippet: '徳島県板野郡松茂町にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_57'),
    position: airport57,
    infoWindow: InfoWindow(
      title: '高松空港',
      snippet: '香川県高松市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_58'),
    position: airport58,
    infoWindow: InfoWindow(
      title: '松山空港',
      snippet: '愛媛県松山市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_59'),
    position: airport59,
    infoWindow: InfoWindow(
      title: '高知空港',
      snippet: '高知県南国市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_60'),
    position: airport60,
    infoWindow: InfoWindow(
      title: '福岡空港',
      snippet: '福岡県福岡市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_61'),
    position: airport61,
    infoWindow: InfoWindow(
      title: '北九州空港',
      snippet: '福岡県北九州市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_62'),
    position: airport62,
    infoWindow: InfoWindow(
      title: '佐賀空港',
      snippet: '佐賀県佐賀市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_63'),
    position: airport63,
    infoWindow: InfoWindow(
      title: '長崎空港',
      snippet: '長崎県大村市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_64'),
    position: airport64,
    infoWindow: InfoWindow(
      title: '壱岐空港',
      snippet: '長崎県壱岐市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_65'),
    position: airport65,
    infoWindow: InfoWindow(
      title: '対馬空港',
      snippet: '長崎県対馬市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_66'),
    position: airport66,
    infoWindow: InfoWindow(
      title: '福江空港',
      snippet: '長崎県五島市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_67'),
    position: airport67,
    infoWindow: InfoWindow(
      title: '熊本空港',
      snippet: '熊本県上益城郡益城町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_68'),
    position: airport68,
    infoWindow: InfoWindow(
      title: '天草空港',
      snippet: '熊本県天草市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_69'),
    position: airport69,
    infoWindow: InfoWindow(
      title: '大分空港',
      snippet: '大分県国東市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_70'),
    position: airport70,
    infoWindow: InfoWindow(
      title: '宮崎空港',
      snippet: '宮崎県宮崎市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_71'),
    position: airport71,
    infoWindow: InfoWindow(
      title: '鹿児島空港',
      snippet: '鹿児島県霧島市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_72'),
    position: airport72,
    infoWindow: InfoWindow(
      title: '薩摩硫黄島飛行場',
      snippet: '鹿児島県鹿児島郡三島村にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_73'),
    position: airport73,
    infoWindow: InfoWindow(
      title: '種子島空港',
      snippet: '鹿児島県熊毛郡中種子町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_74'),
    position: airport74,
    infoWindow: InfoWindow(
      title: '屋久島空港',
      snippet: '鹿児島県熊毛郡屋久島町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_75'),
    position: airport75,
    infoWindow: InfoWindow(
      title: '諏訪之瀬島飛行場',
      snippet: '鹿児島県鹿児島郡十島村にある飛行場',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_76'),
    position: airport76,
    infoWindow: InfoWindow(
      title: '奄美空港',
      snippet: '鹿児島県奄美市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_77'),
    position: airport77,
    infoWindow: InfoWindow(
      title: '喜界空港',
      snippet: '鹿児島県大島郡喜界町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_78'),
    position: airport78,
    infoWindow: InfoWindow(
      title: '徳之島空港',
      snippet: '鹿児島県大島郡天城町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_79'),
    position: airport79,
    infoWindow: InfoWindow(
      title: '沖永良部空港',
      snippet: '鹿児島県大島郡和泊町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_80'),
    position: airport80,
    infoWindow: InfoWindow(
      title: '与論空港',
      snippet: '鹿児島県大島郡与論町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_81'),
    position: airport81,
    infoWindow: InfoWindow(
      title: '那覇空港',
      snippet: '沖縄県那覇市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_82'),
    position: airport82,
    infoWindow: InfoWindow(
      title: '久米島空港',
      snippet: '沖縄県島尻郡久米島町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_83'),
    position: airport83,
    infoWindow: InfoWindow(
      title: '北大東空港',
      snippet: '沖縄県島尻郡北大東村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_84'),
    position: airport84,
    infoWindow: InfoWindow(
      title: '南大東空港',
      snippet: '沖縄県島尻郡南大東村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_85'),
    position: airport85,
    infoWindow: InfoWindow(
      title: '宮古空港',
      snippet: '沖縄県宮古島市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_86'),
    position: airport86,
    infoWindow: InfoWindow(
      title: '下地島空港',
      snippet: '沖縄県宮古島市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_87'),
    position: airport87,
    infoWindow: InfoWindow(
      title: '多良間空港',
      snippet: '沖縄県宮古郡多良間村にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_88'),
    position: airport88,
    infoWindow: InfoWindow(
      title: '新石垣空港',
      snippet: '沖縄県石垣市にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_89'),
    position: airport89,
    infoWindow: InfoWindow(
      title: '波照間空港',
      snippet: '沖縄県八重山郡竹富町にある空港',
    ),
  ),
  const Marker(
    markerId: MarkerId('marker_90'),
    position: airport90,
    infoWindow: InfoWindow(
      title: '与那国空港',
      snippet: '沖縄県八重山郡与那国町にある空港',
    ),
  ),
};
