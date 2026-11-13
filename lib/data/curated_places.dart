import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_app/model/travel_place.dart';

// 小さな試作のために選んだ場所。紹介文はこのアプリ用に作成した短文。
const curatedPlaces = <TravelPlace>[
  TravelPlace(
    id: 'sensoji',
    position: LatLng(35.7148, 139.7967),
    nameJa: '浅草寺',
    nameEn: 'Sensō-ji',
    teaserJa: '東京のにぎわいを歩く',
    teaserEn: 'A lively walk through old Tokyo',
    descriptionJa: '門をくぐって、仲見世のにぎわいと街の空気をゆっくり楽しむ。',
    descriptionEn:
        'Walk through the gate and take your time with the lively streets.',
    theme: PlaceTheme.culture,
    isUnexpected: false,
  ),
  TravelPlace(
    id: 'nezu_shrine',
    position: LatLng(35.7203, 139.7608),
    nameJa: '根津神社',
    nameEn: 'Nezu Shrine',
    teaserJa: '街角から静かな境内へ',
    teaserEn: 'A quiet shrine tucked into the city',
    descriptionJa: '下町を散歩する途中で、木々に囲まれた境内に寄り道。',
    descriptionEn:
        'Pause among the trees during a walk through the neighborhood.',
    theme: PlaceTheme.culture,
    isUnexpected: true,
  ),
  TravelPlace(
    id: 'kiyosumi_garden',
    position: LatLng(35.67954, 139.7968),
    nameJa: '清澄庭園',
    nameEn: 'Kiyosumi Gardens',
    teaserJa: '水辺をぐるりと一周',
    teaserEn: 'Follow a peaceful path by the pond',
    descriptionJa: '池の周りを歩いて、都会の中の静かな時間を見つける。',
    descriptionEn: 'Circle the pond and find a calm moment in the city.',
    theme: PlaceTheme.nature,
    isUnexpected: true,
  ),
  TravelPlace(
    id: 'inokashira_park',
    position: LatLng(35.7008, 139.5742),
    nameJa: '井の頭恩賜公園',
    nameEn: 'Inokashira Park',
    teaserJa: '池のほとりでひと休み',
    teaserEn: 'A pause by the pond',
    descriptionJa: '吉祥寺を歩いたら、池と緑のそばで少しのんびり。',
    descriptionEn:
        'After exploring Kichijoji, slow down beside the pond and trees.',
    theme: PlaceTheme.nature,
    isUnexpected: false,
  ),
  TravelPlace(
    id: 'ritsurin_garden',
    position: LatLng(34.3296, 134.0440),
    nameJa: '栗林公園',
    nameEn: 'Ritsurin Garden',
    teaserJa: '高松で庭園さんぽ',
    teaserEn: 'A garden stroll in Takamatsu',
    descriptionJa: '池や橋を眺めながら、歩くたびに景色が変わる庭園へ。',
    descriptionEn:
        'Wander past ponds and bridges as the scenery changes along the path.',
    theme: PlaceTheme.nature,
    isUnexpected: false,
  ),
  TravelPlace(
    id: 'chichibugahama',
    position: LatLng(34.1890, 133.6490),
    nameJa: '父母ヶ浜',
    nameEn: 'Chichibugahama Beach',
    teaserJa: '瀬戸内の夕暮れを見に',
    teaserEn: 'Watch the Seto Inland Sea at dusk',
    descriptionJa: '砂浜に座って、空と海の色が変わる時間を待ってみる。',
    descriptionEn:
        'Sit by the shore and watch the colors of the sky and sea change.',
    theme: PlaceTheme.nature,
    isUnexpected: true,
  ),
  TravelPlace(
    id: 'iya_vine_bridge',
    position: LatLng(33.8753, 133.8353),
    nameJa: '祖谷のかずら橋',
    nameEn: 'Iya Vine Bridge',
    teaserJa: '山あいの橋を渡る',
    teaserEn: 'Cross a bridge in the mountains',
    descriptionJa: '山の奥へ足を延ばして、谷の景色と橋の揺れを体験する。',
    descriptionEn:
        'Head into the mountains for a bridge and a view of the valley.',
    theme: PlaceTheme.nature,
    isUnexpected: true,
  ),
  TravelPlace(
    id: 'jiufen',
    position: LatLng(25.1096, 121.8442),
    nameJa: '九份',
    nameEn: 'Jiufen',
    teaserJa: '坂道の先に海が見える街',
    teaserEn: 'A hillside town overlooking the sea',
    descriptionJa: '路地と坂道を歩きながら、山と海に囲まれた街を眺める。',
    descriptionEn:
        'Explore the lanes and slopes of this town between hills and sea.',
    theme: PlaceTheme.town,
    isUnexpected: false,
  ),
  TravelPlace(
    id: 'burano',
    position: LatLng(45.4850, 12.4167),
    nameJa: 'ブラーノ島',
    nameEn: 'Burano',
    teaserJa: '色とりどりの島を歩く',
    teaserEn: 'Wander an island full of color',
    descriptionJa: '水辺を曲がるたび、違う色の家並みが現れる小さな島。',
    descriptionEn:
        'Turn a corner by the canals to find another colorful street.',
    theme: PlaceTheme.town,
    isUnexpected: true,
  ),
  TravelPlace(
    id: 'hallgrimskirkja',
    position: LatLng(64.1417, -21.9266),
    nameJa: 'ハットルグリムス教会',
    nameEn: 'Hallgrímskirkja',
    teaserJa: '街の輪郭を見上げる',
    teaserEn: 'Look up at Reykjavík’s skyline',
    descriptionJa: 'レイキャビクの街歩きで、空に伸びる建物を目印に。',
    descriptionEn:
        'Use this landmark as a starting point for a walk around Reykjavík.',
    theme: PlaceTheme.culture,
    isUnexpected: false,
  ),
];

TravelPlace? curatedPlaceById(String id) {
  for (final place in curatedPlaces) {
    if (place.id == id) return place;
  }
  return null;
}
