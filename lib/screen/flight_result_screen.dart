import 'dart:math';
import 'package:ticket_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ticket_app/functions/optimal_flight.dart';
import 'package:ticket_app/model/flight_offer.dart';

typedef FlightSearch = Future<List<FlightOffer>> Function(
    String originCode, String destinationCode, DateTime date, int passengers);

@immutable
class FlightResultScreen extends StatefulWidget {
  final String origin;
  final String originCode;
  final String destination;
  final String destinationCode;
  final DateTime date;
  final int passengers;
  final FlightSearch? flightSearch;

  const FlightResultScreen({
    super.key,
    required this.origin,
    required this.originCode,
    required this.destination,
    required this.destinationCode,
    required this.date,
    required this.passengers,
    this.flightSearch,
  });

  @override
  State<FlightResultScreen> createState() => _FlightResultScreenState();
}

class _FlightResultScreenState extends State<FlightResultScreen> {
  late Future<List<FlightOffer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  @override
  void didUpdateWidget(covariant FlightResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.originCode != widget.originCode ||
        oldWidget.destinationCode != widget.destinationCode ||
        oldWidget.date != widget.date ||
        oldWidget.passengers != widget.passengers ||
        oldWidget.flightSearch != widget.flightSearch) {
      _loadOffers();
    }
  }

  void _loadOffers() {
    _offersFuture = (widget.flightSearch ?? searchFlights)(widget.originCode,
        widget.destinationCode, widget.date, widget.passengers);
  }

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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   color: Theme.of(context).colorScheme.primary,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: FutureBuilder<List<FlightOffer>>(
        future: _offersFuture,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.flight_search_failed),
                  TextButton(
                    onPressed: () => setState(_loadOffers),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                                      child: Text(widget.origin,
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
                                      child: Text(widget.destination,
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
                                    widget.originCode,
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
                                    widget.destinationCode,
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
                                          "${AppLocalizations.of(context)!.passengers}: ${widget.passengers}",
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
                                        widget.originCode,
                                        widget.destinationCode,
                                        widget.date,
                                        widget.passengers),
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
