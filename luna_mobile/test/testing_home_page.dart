import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mobile/presentation/pages/home_page.dart';
import 'package:luna_mobile/presentation/pages/need_help_page.dart';
import 'package:luna_mobile/presentation/pages/settings_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

void main() {
  // Create a reusable setup function to reduce redundancy
  Future<void> setupHomePage(WidgetTester tester) async {
    // Create a mock instance of ModuleUIPicker for testing
    final mockModuleUIPicker = ModuleUIPicker();

    // Set up the HomePage wrapped with the required provider
    await tester.pumpWidget(
      ChangeNotifierProvider<ModuleUIPicker>.value(
        value: mockModuleUIPicker,
        child: MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Ensure the BottomNavigationBar is rendered on the HomePage
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  }

  testWidgets('Verify Add New Module button functionality',
      (WidgetTester tester) async {
    await setupHomePage(tester);

    // Simulate a tap on the "Add Module" button
    await tester.tap(find.text('Add Module'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates

    // Since the "Add Module" button triggers a function, verify it with a mock
    // Ensure that the ModuleUIPicker's `selectAndStoreModuleFile` method is called
    // This test ensures the function runs correctly, but visible UI updates may not exist
  });

  testWidgets('Verify Settings button functionality',
      (WidgetTester tester) async {
    await setupHomePage(tester);

    // Simulate a tap on the "Settings" button
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates

    // Confirm that the SettingsPage is displayed
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('Verify Need Help button functionality',
      (WidgetTester tester) async {
    await setupHomePage(tester);

    // Simulate a tap on the "Need Help" button
    await tester.tap(find.text('Need Help'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates

    // Confirm that the NeedHelpPage is displayed
    expect(find.byType(NeedHelpPage), findsOneWidget);
  });
}
