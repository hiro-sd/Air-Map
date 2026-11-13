# AeroAPI 時刻表検証

更新日: 2026-11-13。検証状態: **候補に追加、API 実測前、未採用**。AeroAPI の API キーがないため、以下は空港の公式時刻表から作った照合表であり、AeroAPI が取得できた便の一覧ではない。

## 目的と照合対象

FlightAware AeroAPI の `GET /schedules/{date_start}/{date_end}` を、国内旅行の「予定便がある」判定に使えるか検証する。運賃、販売中の座席数、予約可能性はこの検証の対象外。

2026 年 12 月の日本時間の出発日を指定し、各空港の公式時刻表と照合する。掲載時刻は変更され得るため、実測する日に公式ページを再確認し、その時点の時刻表を正とする。

| 出発日 | 区間 | 運航便 | 予定時刻（JST） | 公式時刻表 |
| --- | --- | --- | --- | --- |
| 12/5 | 羽田 HND → 高松 TAK | ANA531 | 06:55 → 08:15 | [高松空港](https://www.takamatsu-airport.com/timetable/dom-next.php) |
| 12/5 | 羽田 HND → 高松 TAK | JAL475 | 07:40 → 09:05 | [高松空港](https://www.takamatsu-airport.com/timetable/dom-next.php) |
| 12/5 | 成田 NRT → 高松 TAK | JJP449 | 07:30 → 09:10 | [高松空港](https://www.takamatsu-airport.com/timetable/dom-next.php) |
| 12/5 | 成田 NRT → 高松 TAK | JJP445 | 18:10 → 20:00 | [高松空港](https://www.takamatsu-airport.com/timetable/dom-next.php) |
| 12/9 | 成田 NRT → 高松 TAK | JJP445 | 16:55 → 18:45 | [高松空港](https://www.takamatsu-airport.com/timetable/dom-next.php) |
| 12/5 | 羽田 HND → 徳島 TKS | JAL453 | 06:55 → 08:10 | [徳島空港](https://www.tokushima-airport.co.jp/flight/in/) |
| 12/5 | 羽田 HND → 徳島 TKS | ANA281 | 08:55 → 10:15 | [徳島空港](https://www.tokushima-airport.co.jp/flight/in/) |
| 12/5 | 福岡 FUK → 徳島 TKS | JAL3563 | 09:50 → 10:55 | [徳島空港](https://www.tokushima-airport.co.jp/flight/in/) |

2 つの到着空港、3 つの航空会社、羽田・成田・福岡発、LCC、日付による時刻変更を含む。JJP はジェットスター・ジャパンの ICAO コード。照合時は IATA 表記（GK）や共同運航便との重複を正規化し、運航会社・便番号・区間・日付で比べる。

## 実測手順と記録

1. 個人用 AeroAPI キーを取得し、秘密情報はリポジトリに保存しない。FlightAware の公式 [OpenAPI 定義](https://www.flightaware.com/commercial/aeroapi/resources/aeroapi-openapi.yml) に従い、`x-apikey` ヘッダーを付けてサーバー側またはローカル検証環境から呼ぶ。
2. `2026-12-05` と `2026-12-09` の **JST 00:00～翌日 00:00** を UTC の日時へ変換し、`date_start` / `date_end` に指定する。日付だけを渡すと UTC の 00:00 が境界になるため、日本の暦日とずれる。
3. `origin` と `destination` を指定して、HND→TAK、NRT→TAK、HND→TKS、FUK→TKS を取得する。`include_codeshares=false`、`include_regional=true` とし、`links.next` がなくなるまでページを取得する。応答の `ident_icao` / `ident_iata`、`actual_ident_icao` / `actual_ident_iata`、`scheduled_out` / `scheduled_in` を記録する。
4. 上表の各便について「取得したか」「便番号・時刻が一致したか」「共同運航や日付境界による見かけの差か」を記録する。さらに各区間の公式時刻表に載る**全便**を数え、未取得の便を列挙する。API エラー、空の応答、ページ未取得は「就航なし」と扱わない。
5. 代表的な週末と平日、LCC・地域航空会社、地域外の周辺空港を追加して少なくとも 30 便を照合する。呼び出し回数、ページ数、応答時間も記録する。

## 採用判定

- 対象とする空港・航空会社の区間が取得でき、公式時刻表の照合対象 30 便以上の **95% 以上**で運航便と予定時刻が一致すること。特定の航空会社・空港が丸ごと欠ける場合は、総一致率にかかわらず不採用または補助データ源扱いとする。
- 日付変更便を正しい日付・時刻で区別でき、欠落と通信エラーを区別できること。予定時刻はあくまで時刻表で、当日の運航状況ではない。
- 想定利用量で料金と応答時間が許容でき、**一般利用者向けアプリでの表示・保存・他データ源との併用**が契約上許可されること。FlightAware の Personal 区分は個人・学術用途に限定されるため、公開アプリでの利用条件を確認する。

現時点ではキーがなく API 応答を測定できていないので、いずれの条件も未判定。AeroAPI を「採用済み」や国内便を「網羅」とは表示しない。欠落した便があれば FlightAware の [欠損に関する説明](https://support.flightaware.com/hc/en-us/articles/33161341318935-Why-Is-A-Frequently-Used-Endpoint-Returning-A-Null-Value) を確認し、取得不可を「便なし」に変換しない。

## 料金とデータの境界

[FlightAware の料金表](https://www.flightaware.com/commercial/aeroapi/)では `/schedules` は結果セット単位の従量課金。Personal は月額最低料金なし、月 5 USD 分の無料枠、一般消費者向け商用利用は対象外。Standard は一般消費者向け利用が可能だが、月額最低 100 USD と従量課金がある。正式採用前に最新の料金と [Personal ライセンス（2025 年版）](https://www.flightaware.com/commercial/aeroapi/AeroAPI_Personal_License_Jan2025.pdf) を確認する。

FlightAware が掲げる「scheduled seats」は機材の座席数であり、販売可能な残席ではない。AeroAPI に航空券の運賃・在庫・購入用オファーがあるとは扱わない。販売中の運賃・空席は別の提供元で調達し、取得できない場合は「運賃・空席は未確認」と表示する。
