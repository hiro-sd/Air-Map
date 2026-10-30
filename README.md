# 空港・航空券検索アプリ Air Map✈️

## 概要📖
日本国内の空港とフライトを対象に、地域、現在地からの距離、マップ上をかこう等で空港を検索することができます。
出発地・到着地・日付・人数を指定すると、フライト情報を取得できます。
本アプリはFlutterを使用して開発しました。

## 使用技術🧩
・Flutter (Dart)
・Google Maps API (マップの表示)
・Amadeus API (フライト情報の取得)
・Riverpod (状態管理)

## 特徴☕️
・地図から空港を選択可能
・かこって検索で空港の場所を表示
・複数空港を指定した最安値フライト比較 (開発中)

## その他
お問い合わせ: https://forms.gle/NkXVb3CU1JLB4pJa8
App Storeリンク: https://apps.apple.com/jp/app/air-map/id6742508414?l=ja

## 開発環境

Flutter 3.40.0-0.1.pre で Android デバッグ版の起動と iOS シミュレータ向けビルドを確認しています。別の Flutter バージョンで作業する場合は、先に `flutter analyze` と各対象のビルドを確認してください。

このリポジトリには API キーを含むファイルを登録していません。開発機に次のファイルを用意してください。

| ファイル | 必要な設定 |
| --- | --- |
| `.env` | `GOOGLE_MAPS_API_KEY`、`AMADEUS_API_KEY`、`AMADEUS_API_SECRET` |
| `android/secret.properties` | `googleMap.apiKey` |
| `ios/Runner/Environment.swift` | `struct Env { static let googleMapsApiKey = "..." }` |

依存関係と生成コードを準備します。

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```

Android で実行する場合は `flutter run -d <AndroidのデバイスID>`、iOS シミュレータで実行する場合は `flutter run -d <iOSのデバイスID>` を使用します。接続先は `flutter devices` で確認できます。地域から旅を探す機能の次の実装順序は [開発計画](docs/development-plan.md) に記載しています。

Android エミュレータで地図だけが表示されない場合は、端末日時と通信状態を確認してください。検証時は古いスナップショットにより日時がずれており、コールドブート後に地図が表示されました。
