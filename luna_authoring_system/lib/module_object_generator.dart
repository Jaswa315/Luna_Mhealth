import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import '../utils/size_converter.dart';

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
      if (child is Slide) {
        pages.add(_createPage(child));
      }
    }

    /// The width and height are in EMU values.
    Module moduleObj = Module(
      // moduleId: root.moduleID,
      title: root.title,
      author: root.author,
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
        pageComponents.add(_createDivider(child));
      } else {
        // ToDo: use exception handling and logging instead of print
        // print('ParseTree conversion not supported: ${child.name}');
      }
    }
    Page pageObj = Page(components: pageComponents);

    return pageObj;
  }

  DividerComponent _createDivider(ConnectionShape cxn) {
    Point2D offset = cxn.transform.offset;
    Point2D size = cxn.transform.size;

    // TODO: in parser, convert EMU values into Percentage, This should work w/o SizeCOnverter
    return DividerComponent(
      startPoint: Point2DPercentage(
        SizeConverter.getPointPercentX(offset.x.value, _slideWidth),
        SizeConverter.getPointPercentY(offset.y.value, _slideHeight),
      ),
      endPoint: Point2DPercentage(
        SizeConverter.getPointPercentX(
            offset.x.value + size.x.value, _slideWidth),
        SizeConverter.getPointPercentY(
            offset.y.value + size.y.value, _slideHeight),
      ),
      thickness: cxn.width.value,
    );
  }
}