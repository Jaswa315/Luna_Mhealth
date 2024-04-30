// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_mhealth_mobile/main.dart';
import 'package:luna_mhealth_mobile/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:luna_mhealth_mobile/providers/module_provider.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
        //ChangeNotifierProvider(create: (_) => ClickStateProvider()),
      ],
      child: MyApp(),
    ));

    // Verify that the HomePage widget is present.
    expect(find.byType(HomePage), findsOneWidget);

    // Verify that the AppBar text "Luna" is present.
    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
