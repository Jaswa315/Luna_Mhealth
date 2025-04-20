import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_mobile/main.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:patrol/patrol.dart' as p;
import 'package:provider/provider.dart';



void main() {


    Future<Widget> createTestApp() async {
      await GlobalConfiguration().loadFromAsset("app_settings");
      await LogManager.createInstance();
     
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ModuleUIPicker()), // Provide ModuleUIPicker manually
        ],
        child: MyApp(),
      );
    }
    p.patrolTest(
    'Basic test to validate Patrol works',
    ($) async {
      Widget testApp = await createTestApp();
      await $.pumpWidgetAndSettle(testApp);

      expect($('Settings'), findsOneWidget);
      expect($('Lorem ipsum does not exist. NO TEXT'), findsNothing);
    },
    
  );

    p.patrolTest(
    'Go to settings and back home',
    ($) async {
      Widget testApp = await createTestApp();
      await $.pumpWidgetAndSettle(testApp);

      expect($('Settings'), findsOneWidget);
      await $('Settings').tap();
      await $('About Luna').tap();
      expect($('Version: 1.0.0'), findsOneWidget);
    },
    
  );

    /// Helper function to load a luna file with "lunaTestFilename"
    loadModule(p.PatrolIntegrationTester tester,String lunaTestFileName) async {
        await tester('Add Module').tap();

        // check to see if a permissions dialog for file manipulation appears.
        if(await tester.native.isPermissionDialogVisible()){
          await tester.native.grantPermissionWhenInUse();
        }

        // Expand file picker menu
        await tester.native.waitUntilVisible(p.Selector(contentDescription: "Show roots"));
        await tester.native.tap(p.Selector(contentDescription: "Show roots"));

        // Pick downloads folder
        await tester.native.waitUntilVisible(p.Selector(text: "Downloads"));
        await tester.native.tap(p.Selector(text: "Downloads"));

        // Tap file name
        await tester.native.tap(p.Selector(text: lunaTestFileName ));

    }

    /// Test adding a module from the file system
    ///  This test will fail if there is not a file with lunaTestFileName 
    ///  in the downloads folder
    p.patrolTest(
    'Load and Open A Line Module',
    ($) async {

      const lunaTestFileName = "luna_test.luna";
      Widget testApp = await createTestApp();
      await $.pumpWidgetAndSettle(testApp);
      await loadModule($,lunaTestFileName);
        await $.waitUntilExists($("Home"));
      //open the module
      await $.tester.tap(find.text("Start Learning"));
      await $.tap($("A line"));
      expect($("A line"), findsOneWidget);
    },
    
  );
}
