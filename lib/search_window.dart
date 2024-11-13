import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// SearchWindowの状態を管理するStateNotifier
class SearchWindowStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  SearchWindowStateNotifier() : super([]);

  String apiKey = 'AIzaSyDQ35E-oPP-Nkitj5vzXor6bSXQd82qmpU';

  // 検索候補の取得
  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      state = [];
      return;
    }

    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String requestUrl =
        '$baseUrl?input=$input&key=$apiKey&components=country:jp'; // 日本限定

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'];
        state = predictions.map<Map<String, dynamic>>((dynamic prediction) {
          return {
            'description': prediction['description'],
            'place_id': prediction['place_id'],
          };
        }).toList();
      } else {
        //print('Failed to fetch suggestions: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error occurred while fetching suggestions: $e');
    }
  }

// 特定の場所の詳細情報を取得
  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    final String requestUrl = '$baseUrl?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        return {
          'lat': location['lat'],
          'lng': location['lng'],
        };
      } else {
        //print('Failed to fetch place details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      //print('Error occurred while fetching place details: $e');
      return null;
    }
  }
}

// Providerの定義
final searchWindowProvider = StateNotifierProvider<SearchWindowStateNotifier,
    List<Map<String, dynamic>>>((ref) => SearchWindowStateNotifier());

class SearchWindow extends ConsumerStatefulWidget {
  const SearchWindow({super.key});

  @override
  ConsumerState<SearchWindow> createState() => _SearchWindowState();
}

class _SearchWindowState extends ConsumerState<SearchWindow> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNodeを追加

  @override
  void initState() {
    super.initState();
    // 画面遷移後にフォーカスを当てる
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode); // フォーカスを当てる
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNodeの解放
    searchController.dispose(); // Controllerの解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(searchWindowProvider); // 候補リストの監視

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text(
          AppLocalizations.of(context)!.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(10, 10))
              ],
            ),
            child: TextFormField(
              controller: searchController,
              focusNode: _focusNode, // FocusNodeを設定
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ref
                      .read(searchWindowProvider.notifier)
                      .fetchSuggestions(value); // ユーザーの入力に応じて候補を取得
                } else {
                  ref.read(searchWindowProvider.notifier).fetchSuggestions('');
                }
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: const Color.fromARGB(255, 100, 100, 100),
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                hintText: AppLocalizations.of(context)!.search_airport,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Card(
                  shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      0.5), // 丸みをなくす
                  margin: const EdgeInsets.all(0),
                  child: Column(children: [
                    ListTile(
                      title: Text(suggestion['description'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      onTap: () async {
                        // 候補をタップした際、TextFormFieldに選択された場所を設定
                        searchController.text = suggestion['description'];
                        // 選択された候補の詳細を取得
                        final placeDetails = await ref
                            .read(searchWindowProvider.notifier)
                            .fetchPlaceDetails(suggestion['place_id']);

                        if (placeDetails != null) {
                          // 候補リストをクリアし、main.dartに緯度・経度を渡す
                          ref
                              .read(searchWindowProvider.notifier)
                              .fetchSuggestions('');

                          // GoogleMapが表示されている画面に戻る
                          Navigator.pop(context, placeDetails);
                        }
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                  ]));
            },
          )),
        ],
      ),
    );
  }
}

// TODO: 指定した行き先を検索ウィンドウに表示し、新たに出発地を指定するウィンドウを表示する。
// TODO: リファクタリング