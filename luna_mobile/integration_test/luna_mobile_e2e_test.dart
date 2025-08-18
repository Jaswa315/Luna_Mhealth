
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_mobile/core/constants/keys.dart';
import 'package:luna_mobile/main.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:patrol/patrol.dart' as p;
import 'package:provider/provider.dart';



void main() {
// ,"a_red_line_test.luna":"A Red Line"
  // list of luna files and assocaited titles to test
  const lunaFileTitlesTest = {"a_line_test.luna":"A line"};


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

      expect($(Keys.homeSettingsButton), findsOneWidget);
      expect($('Lorem ipsum does not exist. NO TEXT'), findsNothing);
    },
    
  );

    p.patrolTest(
    'Go to settings and back home',
    ($) async {
      Widget testApp = await createTestApp();
      await $.pumpWidgetAndSettle(testApp);

      expect($(Keys.homeSettingsButton), findsOneWidget);
      await $(Keys.homeSettingsButton).tap();
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

        //check if file name is present
        try{
          await tester.native.tap(p.Selector(text: lunaTestFileName ));
          
          return;
        } on p.PatrolActionException  catch (_) {} // ignore PatrolActionException since the test file name may not be there. it will error anyway if we can't load a file
        // Expand file picker menu
        await tester.native.tap(p.Selector(contentDescription: "Show roots"));

        // Pick downloads folder
        await tester.native.waitUntilVisible(p.Selector(text: "Downloads"));
        await tester.native.tap(p.Selector(text: "Downloads"));

        // Tap file name
        await tester.native.tap(p.Selector(text: lunaTestFileName ));

    }

    /// Test adding a module from the file system
    ///  This test will fail if there is not a file with from the
    /// lunaFileTitlesTest map in the testAssets folder
    p.patrolTest(
    'Load and Open Test Modules',
    ($) async {

      Widget testApp = await createTestApp();
      await $.pumpWidgetAndSettle(testApp);

      for (var fileNameTitle in lunaFileTitlesTest.entries){
        await loadModule($,fileNameTitle.key);
        await $.waitUntilExists($(Keys.homeSettingsButton));
        //open the module
        await $.tester.tap($(Keys.startLearningButton));
        //await $.tap($(fileNameTitle.value));
        //make sure title is listed in module list
        await $.waitUntilVisible($(Keys.startLearningTitle));
        expect($(fileNameTitle.value), findsOneWidget);
        //tap the module
        await $.tap($(fileNameTitle.value));
        //navigate into module. 
        expect($(Keys.startLearningTitle), findsNothing);
        //navigatge back to module list
        await $.tap(find.byKey(Keys.backContextButton));
        //await $.tap(find.byIcon(CupertinoIcons.back));
        await $.tap(find.byKey(Keys.startLearningBackButton));
      }
    },
  );



}
