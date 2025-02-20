import 'package:luna_authoring_system/helper/connection_shape_helper.dart';
import 'package:luna_authoring_system/helper/emu_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/shape/line_component.dart';
import 'package:luna_core/utils/version_manager.dart';

/// [ModuleObjectGenerator] takes in a pptx tree and converts the data into in-memory representation of
/// Module and all descendant objects of a module. This includes Pages, Components, and other items inside a Module.
///
/// Please view the Luna Domain module model rendering diagram at
/// https://app.diagrams.net/#G1oO_dalj6fEq2QAfdHzyQPQiMiSi9CpXE#%7B%22pageId%22%3A%22jMWzNvhAAJqccfFervB2%22%7D
///
/// Our goal is to match that diagram implementation-wise
class ModuleObjectGenerator {
  late final PptxTree pptxTree;
  late int _slideWidth;
  late int _slideHeight;

  ModuleObjectGenerator(this.pptxTree);

  Future<Module> generateLunaModule() async {
    return _createModule(pptxTree);
  }

  Module _createModule(PptxTree root) {
    _slideWidth = root.width.value;
    _slideHeight = root.height.value;

    List<Page> pages = [];

    for (Slide child in root.slides) {
      //TODO: pass width and height value to translate into percentage
      pages.add(_createPage(child));
    }

    Module moduleObj = Module(
      title: root.title,
      author: root.author,
      authoringVersion: VersionManager().version,
      pages: pages,
      width: root.width.value,
      height: root.height.value,
    );

    return moduleObj;
  }

  Page _createPage(Slide slide) {
    List<Component> pageComponents = [];
    for (Shape child in slide.shapes!) {
      if (child is ConnectionShape) {
        pageComponents.add(_createLine(child));
      } else {
        // ToDo: use exception handling and logging instead of print
        // print('ParseTree conversion not supported: ${child.name}');
      }
    }
    Page pageObj = Page(components: pageComponents);

    return pageObj;
  }

  LineComponent _createLine(
    ConnectionShape cxn,
  ) {
    double thicknessOfLine =
        EmuConversions.updateThicknessToDisplayPixels(cxn.width);
    // Get computed start and end points
    final points = ConnectionShapeHelper.getStartAndEndPoints(
      cxn,
      _slideWidth,
      _slideHeight,
    );

    return LineComponent(
      startPoint: points['startPoint']!,
      endPoint: points['endPoint']!,
      thickness: thicknessOfLine,
    );
  }
}
