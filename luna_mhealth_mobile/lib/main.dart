/// The main entry point for the Luna mHealth Mobile application.
/// This application displays a module with pages containing text and image components.
/// Each component is rendered based on its type.

/// - [MyApp], the root widget of the application.
/// - [Module], a class representing a module with a title, description, and pages.
/// - [slide_page.Page], a class representing a page within a module.
/// - [TextComponent], a class representing a text component.
/// - [ImageComponent], a class representing an image component.
/// - [ComponentType], an enum representing the type of a component.
/// - [ClickStateProvider], a provider class that manages the state of a click event.

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_mhealth_mobile/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'enums/component_type.dart';
import 'models/image/image_component.dart';
import 'models/module.dart';
import 'models/page.dart' as slide_page;
import 'models/text/text_component.dart';
import 'providers/click_state_provider.dart';
import 'utils/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await LogManager.createInstance();

  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => ModuleProvider()),
      ChangeNotifierProvider(create: (_) => ClickStateProvider()),
    ],
    child: MyApp(),
  ));
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Center(
      //       child: Text('Luna mHealth Mobile'),
      //     ),
      //   ),
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
