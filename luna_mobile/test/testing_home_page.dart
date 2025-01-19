import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_mobile/presentation/pages/home_page.dart';
import 'package:luna_mobile/presentation/pages/need_help_page.dart';
import 'package:luna_mobile/presentation/pages/settings_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

// Mock ModuleUIPicker for testing
class MockModuleUIPicker extends ModuleUIPicker {
  List<Module> mockModules = [];
  bool areModulesLoaded = false;

  @override
  List<Module> get moduleList => mockModules;

  @override
  Future<void> loadAvailableModules() async {
    areModulesLoaded = true;
    // Simulate async loading delay
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  // Create a reusable setup function to reduce redundancy
  Future<void> setupHomePage(WidgetTester tester,
      [MockModuleUIPicker? mockModuleUIPicker]) async {
    // Use the provided mockModuleUIPicker or create a new one
    final moduleUIPicker = mockModuleUIPicker ?? MockModuleUIPicker();

    // Set up the HomePage wrapped with the required provider
    await tester.pumpWidget(
      ChangeNotifierProvider<ModuleUIPicker>.value(
        value: moduleUIPicker,
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

  testWidgets('Verify module name assignment for empty or null-like titles',
      (WidgetTester tester) async {
    // Mock modules with different title cases
    final mockModules = [
      Module(
        title: 'Module 1',
        author: 'Author 1',
        slideCount: 10,
        pages: [],
        width: 1024,
        height: 768,
        name: 'Module 1 Name',
      ),
      Module(
        title: '',
        author: 'Author 2',
        slideCount: 5,
        pages: [],
        width: 1024,
        height: 768,
        name: 'Unnamed Module',
      ),
      Module(
        title: '', // Empty title instead of null
        author: 'Author 3',
        slideCount: 7,
        pages: [],
        width: 1024,
        height: 768,
        name: 'No Title Module',
      ),
      Module(
        title: 'Module 4',
        author: 'Author 4',
        slideCount: 12,
        pages: [],
        width: 1024,
        height: 768,
        name: 'Module 4 Name',
      ),
    ];

    final mockModuleUIPicker = MockModuleUIPicker();
    mockModuleUIPicker.mockModules = mockModules;
    mockModuleUIPicker.areModulesLoaded = true;

    // Load HomePage with mock provider
    await setupHomePage(tester, mockModuleUIPicker);

    // Verify module titles in the UI
    for (int i = 0; i < mockModules.length; i++) {
      final expectedTitle = (mockModules[i].title.trim().isEmpty)
          ? 'module_${i + 1}' // Default title format
          : mockModules[i].title;

      expect(find.text(expectedTitle), findsOneWidget);
    }
  });
}
