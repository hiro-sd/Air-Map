import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ticket_app/functions/optimal_flight.dart';

class FlightOffer {
  final String id;
  final String duration;
  final String departureTerminal;
  final String arrivalTerminal;
  final String carrier;
  final String flightNumber;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;

  FlightOffer({
    required this.id,
    required this.duration,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.carrier,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory FlightOffer.fromJson(Map<String, dynamic> json) {
    var itineraries = json['itineraries'] as List;
    if (itineraries.isEmpty) {
      throw Exception("No itineraries found");
    }

    var firstSegment = itineraries[0]['segments'] as List;
    if (firstSegment.isEmpty) {
      throw Exception("No segments found");
    }

    String formatDuration(String duration) {
      final regex = RegExp(r'PT(\d+H)?(\d+M)?');
      final match = regex.firstMatch(duration);

      if (match == null) return '';

      String hours = match.group(1)?.replaceAll('H', 'h') ?? '';
      String minutes = match.group(2)?.replaceAll('M', 'm') ?? '';

      return '$hours$minutes';
    }

    var firstFlight = firstSegment[0];

    return FlightOffer(
        id: json['id'] ?? "Unknown",
        duration: formatDuration(itineraries[0]['duration']),
        departureTerminal: firstFlight['departure']['terminal'] ?? "-",
        arrivalTerminal: firstFlight['arrival']['terminal'] ?? "-",
        carrier: firstFlight['carrierCode'] ?? "",
        flightNumber: firstFlight['number'] ?? "",
        departureTime: DateTime.parse(firstFlight['departure']['at']),
        arrivalTime: DateTime.parse(firstFlight['arrival']['at']),
        price: double.parse(json['price']['total']));
  }
}

class FlightResultScreen extends StatelessWidget {
  final String origin;
  final String originCode;
  final String destination;
  final String destinationCode;
  final DateTime date;
  final int passengers;

  const FlightResultScreen({
    super.key,
    required this.origin,
    required this.originCode,
    required this.destination,
    required this.destinationCode,
    required this.date,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.search_result,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<FlightOffer>?>(
        future: searchFlights(originCode, destinationCode, date, passengers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset(
              'assets/animations/loadingAnimation.json',
              width: 200,
              height: 200,
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty == true) {
            return Center(
              child: Text(AppLocalizations.of(context)!.no_flight,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          } else {
            var offers = snapshot.data!;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.alert_message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  var offer = offers[index];
                  return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text(origin,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ))),
                                  Text("${offer.carrier} ${offer.flightNumber}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      )),
                                  Flexible(
                                      child: Text(destination,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ))),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    originCode,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Transform.rotate(
                                      angle: pi / 2,
                                      child: Icon(
                                        Icons.flight,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      margin: const EdgeInsets.only(right: 8),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    destinationCode,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                            Text(
                              offer.duration,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${offer.departureTime.month}/${offer.departureTime.day}(${_getWeekday(offer.departureTime)})",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Column(children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .departure_time,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            "${offer.departureTime.hour}:${offer.departureTime.minute.toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(width: 10),
                                        Column(children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .terminal,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(offer.departureTerminal,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 0.5,
                                  height: 70,
                                  color: Colors.grey,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${offer.arrivalTime.month}/${offer.arrivalTime.day}(${_getWeekday(offer.arrivalTime)})",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Column(children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .terminal,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            offer.arrivalTerminal,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .arrival_time,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              "${offer.arrivalTime.hour}:${offer.arrivalTime.minute.toString().padLeft(2, '0')}",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.passengers}: $passengers",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "${AppLocalizations.of(context)!.price}: ${offer.price.toInt()}${AppLocalizations.of(context)!.yen}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                  TextButton(
                                    child: Text(
                                      AppLocalizations.of(context)!.booking,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => launchBookingSite(
                                        offer.carrier,
                                        offer.flightNumber,
                                        originCode,
                                        destinationCode,
                                        date,
                                        passengers),
                                  )
                                ])
                          ])));
                },
              )),
            ]);
          }
        },
      ),
    );
  }

  String _getWeekday(DateTime date) {
    // 曜日を取得
    const weekdays = ["月", "火", "水", "木", "金", "土", "日"];
    return weekdays[date.weekday - 1];
  }
}
