/// The main entry point for the Luna mHealth Mobile application.
/// This application displays a module with pages containing text and image components.
/// Each component is rendered based on its type.

/// - [MyApp], the root widget of the application.
/// - [ModuleView], the widget that displays the module and its pages.
/// - [Module], a class representing a module with a title, description, and pages.
/// - [slide_page.Page], a class representing a page within a module.
/// - [TextComponent], a class representing a text component.
/// - [ImageComponent], a class representing an image component.
/// - [ComponentType], an enum representing the type of a component.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:luna_mhealth_mobile/models/image/image_component.dart';

import 'enums/component_type.dart';
import 'models/module.dart';
import 'models/page.dart' as slide_page;
import 'models/text/text_component.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModuleView(),
    );
  }
}

class ModuleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // sample data (will ultimately come from PPT parsed JSON file)
    Module module = Module(title: 'Module #0', description: 'Demo');
    slide_page.Page page = slide_page.Page(index: 0);
    page.addComponent(
        TextComponent(text: 'Hello, Luna!!!', type: ComponentType.text));
    page.addComponent(ImageComponent(
        imagePath: 'assets/images/luna.png',
        type: ComponentType.image,
        width: 200,
        height: 200));
    module.addPage(page);

    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: Center(
        child: Column(
          children:
              page.components.map((component) => component.render()).toList(),
        ),
      ),
    );
  }
}
