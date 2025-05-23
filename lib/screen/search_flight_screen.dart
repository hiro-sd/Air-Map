import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/airport_list.dart';
import 'package:ticket_app/screen/flight_result_screen.dart';
import 'package:ticket_app/state/map_state_controller.dart';

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
    final state = ref.watch(mapStateControllerProvider);
    final selectedDate = ref.watch(dateProvider);
    final passengers = ref.watch(passengerProvider);
    final originCode = ref.watch(originCodeProvider);
    final destinationCode = ref.watch(destinationCodeProvider);

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        const SizedBox(height: 100),
        Text(AppLocalizations.of(context)!.flight_screen_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Row(children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              readOnly: true,
              onTap: () => showAirportPicker(context, ref, "origin"),
              decoration: InputDecoration(
                hintText: 'From: ${state.selectedDeparture ?? ''}',
                hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.flight_takeoff),
              ),
            ),
          ),
          if (state.selectedDeparture != null &&
              state.selectedDestination != null)
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
                          .read(mapStateControllerProvider.notifier)
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
              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
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
              hintText:
                  "${AppLocalizations.of(context)!.date}: ${selectedDate != null ? "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}" : ''}",
              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
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
              readOnly: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context)!.number_of_passengers}: ${passengers ?? ''}",
                hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.people),
              ),
              onTap: () => showPassengerPicker(context, ref),
            )),
        const SizedBox(height: 40),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              // フライト検索処理を実装
              if ([
                state.selectedDeparture,
                state.selectedDestination,
                selectedDate,
                passengers,
                originCode,
                destinationCode
              ].contains(null)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(AppLocalizations.of(context)!.fill_all_fields,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightResultScreen(
                      origin: state.selectedDeparture!,
                      originCode: originCode!,
                      destination: state.selectedDestination!,
                      destinationCode: destinationCode!,
                      date: selectedDate!,
                      passengers: passengers!,
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

// 空港選択Picker
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
                      if (place == "origin") {
                        ref
                            .read(mapStateControllerProvider.notifier)
                            .updateSelectedDeparture(
                                airportNames[selectedIndex]);
                        ref.read(originCodeProvider.notifier).state =
                            airportCodes[selectedIndex];
                      } else {
                        ref
                            .read(mapStateControllerProvider.notifier)
                            .updateSelectedDestination(
                                airportNames[selectedIndex]);
                        ref.read(destinationCodeProvider.notifier).state =
                            airportCodes[selectedIndex];
                      }
                      Navigator.of(context).pop(); // モーダルを閉じる
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

// 乗客選択Picker
void showPassengerPicker(BuildContext context, WidgetRef ref) {
  int selectedPassengers = ref.read(passengerProvider) ?? 1; // 初期値1人

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
                  selectedPassengers = index + 1; // 1~9人まで選択可能
                  HapticFeedback.heavyImpact();
                },
                scrollController: FixedExtentScrollController(
                  initialItem: selectedPassengers - 1, // 1人目が index=0
                ),
                children: List.generate(9, (index) {
                  return Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(passengerProvider.notifier).state =
                          selectedPassengers;
                      Navigator.of(context).pop(); // モーダルを閉じる
                    },
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}


// TODO: UI見直し (往復、直行、表示順、など追加？)