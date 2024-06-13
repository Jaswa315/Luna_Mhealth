import 'dart:ui';

import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/text/text_component.dart';
import 'package:luna_core/models/image/image_component.dart';
// import 'package:luna_core/utils/logging.dart';

class ModuleObjectGenerator {
  late final PrsNode _root;

  ModuleObjectGenerator(PrsNode presentationData) {
    _root = presentationData;
  }

  Module generateLunaModule(PrsNode root) {
    return _createModule(root);
  }

  Module _createModule(PrsNode root) {
    // validate myself
    if (root.name != 'presentation') {
      throw ArgumentError('${root.name} is not a presentation');
    }
    // create myself
    // TODO: Try and Catch
    // TODO: make GUID for id.
    PresentationNode data = root as PresentationNode;

    List<Page> pages = [];

    for (PrsNode child in data.children) {
      if (child is SlideNode) {
        pages.add(_createPage(child));
      }
    }
    Module moduleObj = Module(
        id: data.moduleID,
        moduleId: data.moduleID,
        title: data.title,
        author: data.author,
        type: 'module',
        slideCount: data.children.length,
        section: {},
        pages: pages,
        width: data.x,
        height: data.y,
        games: []);
    return moduleObj;
  }

  Page _createPage(PrsNode root) {
    if (root.name != 'slide') {
      throw ArgumentError('${root.name} is not a slide');
    }
    SlideNode data = root as SlideNode;
    List<Component> pageComponents = [];
    for (PrsNode child in data.children) {
      if (child is TextBoxNode) {
        pageComponents.add(_createText(child));
      } else if (child is ImageNode) {
        pageComponents.add(_createImage(child));
      }
    }
    Page pageObj = Page(slideId: data.slideId, components: pageComponents);
    return pageObj;
  }

  ImageComponent _createImage(PrsNode root) {
    if (root.name != 'image') {
      throw ArgumentError('${root.name} is not a image');
    }
    ImageNode data = root as ImageNode;
    Transform transformData = data.transform;
    Point2D offset = transformData.offset;
    Point2D size = transformData.size;
    ImageComponent imageComponentObj = ImageComponent(
        imagePath: data.path,
        height: offset.y,
        width: offset.x,
        x: size.x,
        y: size.y);
    return imageComponentObj;
  }

  // TODO: Create Text Components. Check with team on status of text components
  // TextComponent _createText(PrsNode root) {
  //   TODO: Is text component updated? More explanation on text types ? What do we care about retrieving?
  // }

  // TODO: Create Necessary Components
  //

  // TODO: Create Game Components
}
