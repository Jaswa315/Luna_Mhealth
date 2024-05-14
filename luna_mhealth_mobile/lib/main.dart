/// The main entry point for the Luna mHealth Mobile application.
/// This application displays a module with pages containing text and image components.
/// Each component is rendered based on its type.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_mhealth_mobile/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'providers/module_ui_picker.dart';
import '../../luna_core/lib/utils/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await LogManager.createInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModuleUIPicker()),
        //ChangeNotifierProvider(create: (_) => ClickStateProvider()),
      ],
      child: MyApp(),
    ));
  });
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
