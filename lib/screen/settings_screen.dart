import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void openUrl(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('URLを開くことができませんでした: $url')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final String contactUrl = 'https://forms.gle/NkXVb3CU1JLB4pJa8';
  final String shareUrl =
      'https://apps.apple.com/jp/app/air-map/id6742508414?l=ja';
  final String termsUrl =
      'https://yummy-clownfish-5b7.notion.site/1a6c73c0d34080f3aac1e300589a4c97';
  final String privacyPolicyUrl =
      'https://yummy-clownfish-5b7.notion.site/1a6c73c0d3408094b2c3d5eb18f6dab8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => openUrl(context, contactUrl),
              child: Text(
                AppLocalizations.of(context)!.contact_us,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Share.share(shareUrl),
              child: Text(AppLocalizations.of(context)!.share_this_app,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () => openUrl(context, termsUrl),
              child: Text(
                AppLocalizations.of(context)!.terms_of_use,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => openUrl(context, privacyPolicyUrl),
              child: Text(AppLocalizations.of(context)!.privacy_policy,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
