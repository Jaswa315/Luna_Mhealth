import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:luna_mobile/main.dart';


void main() {
  
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test Non-Module Luna Activities', () {
    testWidgets('Go to settings and back home', (tester) async {

      await tester.pumpWidget(MyApp());

      // Find settings button
      expect(find.text('Settings'), findsOneWidget);
  
      // Tap on settings button
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Find about luna and tap on it
      expect(find.text('About Luna'),findsOneWidget);
      await tester.tap(find.text('About Luna'));
      await tester.pumpAndSettle();

      // Ensure about dialog shows up
      expect(find.text('View licenses'), findsOneWidget);

      // Tap close
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      // Tap back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      
      // check we can see home page
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
