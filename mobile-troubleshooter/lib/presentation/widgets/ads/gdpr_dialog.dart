import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/app_localizations.dart';

// Provider to hold the GDPR consent status
final gdprConsentProvider = StateProvider<bool?>((ref) => null);

class GdprDialog extends ConsumerWidget {
  const GdprDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if consent has already been given.
    if (prefs.getBool('gdpr_consent_given') != null) {
      ref.read(gdprConsentProvider.notifier).state = prefs.getBool('gdpr_consent_given');
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.translate('gdprConsentTitle')),
          content: Text(l10n.translate('gdprConsentMessage')),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.translate('decline')),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(l10n.translate('accept')),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      await prefs.setBool('gdpr_consent_given', result);
      ref.read(gdprConsentProvider.notifier).state = result;
      // Here you would initialize the Mobile Ads SDK with the new consent status
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget doesn't build anything itself, it just provides the `show` method.
    return const SizedBox.shrink();
  }
}
