import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/riverpod/search_window_state_notifier.dart';

// 検索ウィンドウを表示する画面
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
      // ignore: use_build_context_synchronously
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
    final state = ref.watch(mapScreenProvider);

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
                hintText: state.tmp
                    ? AppLocalizations.of(context)!.search_departing_airport
                    : AppLocalizations.of(context)!.search_airport,
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
                          Navigator.pop(
                              // ignore: use_build_context_synchronously
                              context,
                              placeDetails); // placeDetailsを渡す
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