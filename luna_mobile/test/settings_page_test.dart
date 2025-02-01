import 'package:luna_mobile/presentation/pages/settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:luna_core/utils/version_manager.dart';
import 'package:mockito/mockito.dart';

// Mock VersionManager due package_info_plus integration
class MockVersionManager extends Mock implements VersionManager {
  @override
  String get version => "1.0.0";
}

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockVersionManager mockVersionManager;

  setUp(() {
    mockVersionManager = MockVersionManager();
    //set VersionManager to a mock version
    VersionManager.resetInstance(mockVersionManager);
  });

  // Create a reusable setup function to reduce redundancy
  /// Initializes the `SettingsPage`
  Future<void> setupSettingsPage(WidgetTester tester) async {

    // Set up the Settings page wrapped in a material
    await tester.pumpWidget( MaterialApp(home: SettingsPage()));

    // Ensure that the title of the page is settings
    expect(find.text('Settings'), findsOneWidget);
  }

  testWidgets('Verify About The App Button Appears', (WidgetTester tester) async {
    await setupSettingsPage(tester);
    // Confirm that the AboutTheAppButton is displayed
    expect(find.text("About Luna"), findsOneWidget);
  });

  testWidgets('Verify tapping about the app shows the version', (WidgetTester tester) async {
    await setupSettingsPage(tester);
    // Simulate a tap on the "About the App" button
    await tester.tap(find.text('About Luna'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates
    // Confirm that the about box is displayed
    expect(find.byType(AboutDialog), findsOneWidget);
  });

  testWidgets('Verify tapping about the app shows the version', (WidgetTester tester) async {
    await setupSettingsPage(tester);
    // Simulate a tap on the "About the App" button
    await tester.tap(find.text('About Luna'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates
    // Confirm that the about box is displayed
    expect(find.text("Version: 1.0.0"), findsOneWidget);
  });
}
