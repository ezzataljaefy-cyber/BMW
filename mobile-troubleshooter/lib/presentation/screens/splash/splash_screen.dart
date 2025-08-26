import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../device_selection/device_selection_screen.dart';
import '../home/home_screen.dart';
import '../../widgets/ads/gdpr_dialog.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for a few seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Show GDPR consent dialog
    await GdprDialog.show(context, ref);

    // Initialize Google Mobile Ads SDK after getting consent
    // In a real app, you would pass the consent status to the initialization.
    await MobileAds.instance.initialize();

    // Navigate to the next screen
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool deviceSelected = prefs.getBool('device_selected') ?? false;

    if (deviceSelected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DeviceSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with a proper logo widget later
            Icon(Icons.handyman, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Mobile Troubleshooter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
