import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_troubleshooter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the splash screen is shown first.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Mobile Troubleshooter'), findsOneWidget);

      // Wait for the splash screen to disappear.
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that we have navigated to the DeviceSelectionScreen.
      expect(find.text('Select Your Device'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Example of how to interact with the screen
      // This part is commented out as it requires a running app, but shows the principle.
      /*
      // Find the dropdown and tap it.
      await tester.tap(find.byType(DropdownButtonFormField));
      await tester.pumpAndSettle();

      // Find an item in the dropdown and tap it.
      await tester.tap(find.text('Google Pixel 7').last);
      await tester.pumpAndSettle();

      // Tap the continue button.
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify that we have navigated to the HomeScreen.
      expect(find.byType(SearchBarWidget), findsOneWidget);
      */
    });
  });
}
