import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_app/state/map_screen_state_notifier.dart';
import 'package:ticket_app/screen/root_screen.dart';
import 'package:ticket_app/screen/search_flight_screen.dart';

// BottomSheetを表示する関数
void showCustomBottomSheet(BuildContext context, ref, String placeName,
    String snippet, List<String> photoUrls, String airportCode) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      //final state = ref.read(mapScreenProvider);
      return SingleChildScrollView(
          child: IntrinsicHeight(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Text(
              placeName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              snippet,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            if (photoUrls.isNotEmpty)
              SizedBox(
                height: 350,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: photoUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      photoUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                            AppLocalizations.of(context)!.failed_to_load_image);
                      },
                    );
                  },
                ),
              )
            else
              Text(AppLocalizations.of(context)!.no_photo), // 写真がない場合
            const SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!.set_location,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15)),
                    onPressed: () {
                      ref
                          .read(mapScreenProvider.notifier)
                          .updateSelectedDeparture(
                            placeName,
                          );
                      ref.read(originCodeProvider.notifier).state = airportCode;
                      ref.read(indexProvider.notifier).state = 1;
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.origin,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15)),
                  onPressed: () {
                    Navigator.pop(context); // BottomSheetを閉じる
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15)),
                    onPressed: () {
                      ref
                          .read(mapScreenProvider.notifier)
                          .updateSelectedDestination(
                            placeName,
                          );
                      ref.read(destinationCodeProvider.notifier).state =
                          airportCode;
                      ref.read(indexProvider.notifier).state = 1;
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.destination,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      )));
    },
  );
}
