import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/state/riverpod/map_screen_state_notifier.dart';
import 'package:ticket_app/functions/airport_list.dart';
import 'package:ticket_app/ui/screen/flight_result_screen.dart';

final passengerProvider = StateProvider<int?>((ref) => null);
final dateProvider = StateProvider<DateTime?>((ref) => null);
final originCodeProvider = StateProvider<String?>((ref) => null);
final destinationCodeProvider = StateProvider<String?>((ref) => null);

class SearchFlightScreen extends ConsumerStatefulWidget {
  const SearchFlightScreen({super.key});

  @override
  SearchFlightScreenState createState() => SearchFlightScreenState();
}

double _iconRotation = 0.0;

class SearchFlightScreenState extends ConsumerState<SearchFlightScreen> {
  @override
  Widget build(BuildContext context) {
    final passengers = ref.watch(passengerProvider);
    final state = ref.watch(mapScreenProvider);
    final selectedDate = ref.watch(dateProvider);
    final originCode = ref.watch(originCodeProvider);
    final destinationCode = ref.watch(destinationCodeProvider);

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        const SizedBox(height: 100),
        Text(AppLocalizations.of(context)!.flight_screen_title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              readOnly: true,
              onTap: () => showAirportPicker(context, ref, "origin"),
              decoration: InputDecoration(
                hintText: 'From: ${state.selectedDeparture ?? ''}',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.flight_takeoff),
              ),
            ),
          ),
          if (state.tmpTakeoff && state.tmpLand) // TODO: なぜか片方nullだとうまくいかない
            AnimatedRotation(
                turns: _iconRotation,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                    icon: const Icon(Icons.swap_vert),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        _iconRotation += 0.5; // 180度回転
                      });
                      ref
                          .read(mapScreenProvider.notifier)
                          .swapDepartureAndDestination(ref);
                    })),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            readOnly: true,
            onTap: () => showAirportPicker(context, ref, "destination"),
            decoration: InputDecoration(
              hintText: 'To: ${state.selectedDestination ?? ''}',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.flight_land),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: (selectedDate != null)
                  ? "Date: ${selectedDate.year}/${selectedDate.month}/${selectedDate.day}"
                  : "Date",
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1));
              if (pickedDate != null) {
                ref.read(dateProvider.notifier).state = pickedDate;
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            // 数字を入力した後、確定できるようにする
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: (passengers != null) // TODO: 表記が確定しない問題
                  ? "Number of passengers: $passengers"
                  : "Number of passengers",
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.people),
            ),
            onChanged: (value) {
              ref.read(passengerProvider.notifier).state = int.tryParse(value);
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              // フライト検索処理を実装
              if (state.selectedDeparture == null ||
                  state.selectedDestination == null ||
                  selectedDate == null ||
                  passengers == null ||
                  originCode == null ||
                  destinationCode == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.white,
                    duration: const Duration(seconds: 1),
                    content: Text(AppLocalizations.of(context)!.fill_all_fields,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightResultScreen(
                      origin: state.selectedDeparture!,
                      originCode: originCode,
                      destination: state.selectedDestination!,
                      destinationCode: destinationCode,
                      date: selectedDate,
                      passengers: passengers,
                    ),
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.search_flight,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ])),
    );
  }
}

// 空港選択ピッカー
void showAirportPicker(BuildContext context, WidgetRef ref, String place) {
  int selectedIndex = 0;
  List airportNames =
      airportData.map((airport) => airport['title'](context)).toList();
  List airportCodes = airportData.map((airport) => airport['IATA']).toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext builder) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                itemExtent: 45,
                onSelectedItemChanged: (index) {
                  selectedIndex = index;
                  HapticFeedback.heavyImpact();
                },
                scrollController:
                    FixedExtentScrollController(initialItem: selectedIndex),
                children: airportNames
                    .map((name) => Center(
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))))
                    .toList(),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                  width: 100,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // モーダルを閉じる
                    },
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              SizedBox(
                  width: 100,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // モーダルを閉じる
                      if (place == "origin") {
                        ref
                            .read(mapScreenProvider.notifier)
                            .updateSelectedDeparture(
                                airportNames[selectedIndex]);
                        ref.read(originCodeProvider.notifier).state =
                            airportCodes[selectedIndex];
                        if (!ref.read(mapScreenProvider).tmpTakeoff) {
                          ref
                              .read(mapScreenProvider.notifier)
                              .toggleTmpTakeoff();
                        }
                      } else {
                        ref
                            .read(mapScreenProvider.notifier)
                            .updateSelectedDestination(
                                airportNames[selectedIndex]);
                        ref.read(destinationCodeProvider.notifier).state =
                            airportCodes[selectedIndex];
                        if (!ref.read(mapScreenProvider).tmpLand) {
                          ref.read(mapScreenProvider.notifier).toggleTmpLand();
                        }
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

// TODO: UI見直し (往復、直行、表示順、など追加？)
// TODO: マーカーをタップして空港を指定した際には、この画面に遷移させる。