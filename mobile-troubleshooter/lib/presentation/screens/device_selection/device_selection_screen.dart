import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import '../../../core/localization/app_localizations.dart';

final selectedDeviceProvider = StateProvider<String?>((ref) => null);

class DeviceSelectionScreen extends ConsumerWidget {
  const DeviceSelectionScreen({Key? key}) : super(key: key);

  final List<String> _devices = const [
    'iPhone 14 Pro',
    'iPhone 14',
    'Samsung Galaxy S23 Ultra',
    'Samsung Galaxy S23',
    'Google Pixel 7 Pro',
    'Google Pixel 7',
    'Other'
  ];

  Future<void> _onContinue(BuildContext context, WidgetRef ref) async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('device_selected', true);
      await prefs.setString('user_device', selectedDevice);

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      // Show a snackbar if no device is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a device to continue.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_android, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                l10n.translate('deviceSelectionTitle'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.translate('deviceSelectionSubtitle'),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                value: selectedDevice,
                hint: const Text('Select your device'),
                isExpanded: true,
                items: _devices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  ref.read(selectedDeviceProvider.notifier).state = newValue;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _onContinue(context, ref),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(l10n.translate('continue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
