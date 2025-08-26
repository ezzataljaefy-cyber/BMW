import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../../providers/auth_providers.dart';
import '../../../core/localization/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes. If the user is logged in, navigate to HomeScreen.
    ref.listen<AsyncValue<dynamic>>(authStateChangesProvider, (_, state) {
      if (state.asData?.value != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.handyman_rounded, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                l10n.translate('appTitle'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                icon: const Icon(Icons.login), // Placeholder, could use a Google logo
                label: Text(l10n.translate('login')),
                onPressed: () async {
                  try {
                    final user = await ref.read(authRepositoryProvider).signInWithGoogle();
                    if (user != null) {
                      await ref.read(analyticsServiceProvider).logLogin();
                    }
                    // The listener above will handle navigation
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to sign in: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
