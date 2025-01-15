import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mobile/presentation/pages/home_page.dart';
import 'package:luna_mobile/presentation/pages/settings_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Verify Settings button functionality',
      (WidgetTester tester) async {
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

    // Simulate a tap on the "Settings" button
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle(); // Wait for any animations or UI updates

    // Confirm that the SettingsPage is displayed
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
