import 'dart:ui';
import 'package:flutter/src/painting/borders.dart';
import 'package:pptx_parser/parser/presentation_parser.dart';
import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/text/text_component.dart';
import 'package:luna_core/models/image/image_component.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:pptx_parser/utils/size_converter.dart';

// import 'package:luna_core/utils/logging.dart';
// Font size is described as 100 * point value.
// OpenXML: http://officeopenxml.com/drwSp-text-runProps.php
const sizeToPointFactor = 100;
const defaultFontSize = 1600; // 16.0 pt * 100

class ModuleObjectGenerator {
  late final PresentationParser parser;
  late double _slideWidth;
  late double _slideHeight;
  late Map<String, double> _padding;
  //late final PrsNode _root;

  ModuleObjectGenerator(this.parser);

  Future<Module> generateLunaModule(String fileName) async {
    PrsNode root = await parser.toPrsNode();
    return _createModule(root, fileName);
  }

  Module _createModule(PrsNode root, String fileName) {
    // validate myself
    if (root.name != 'presentation') {
      throw ArgumentError('${root.name} is not a presentation');
    }
    // create myself
    // TODO: Try and Catch
    PresentationNode data = root as PresentationNode;
    _slideWidth = data.width;
    _slideHeight = data.height;

    List<Page> pages = [];

    for (PrsNode child in data.children) {
      //TODO: pass width and height value to translate into percentage
      if (child is SlideNode) {
        pages.add(_createPage(child));
      }
    }

    /// The width and height are in EMU values.
    Module moduleObj = Module(
        id: data.moduleID,
        moduleId: data.moduleID,
        title: data.title,
        name: fileName,
        author: data.author,
        slideCount: data.children.length,
        section: {},
        pages: pages,
        width: data.width,
        height: data.height,
        games: []);
    return moduleObj;
  }

  Page _createPage(PrsNode root) {
    if (root.name != 'slide') {
      throw ArgumentError('${root.name} is not a slide');
    }
    SlideNode data = root as SlideNode;
    _padding = data.padding;

    List<Component> pageComponents = [];
    for (PrsNode child in data.children) {
      if (child is TextBoxNode) {
        pageComponents.add(_createTextBox(child));
      } else if (child is ImageNode) {
        pageComponents.add(_createImage(child));
      } else if (child is ConnectionNode) {
        pageComponents.add(_createDivider(child));
      } else {
        // ToDo: use exception handling and logging instead of print
        print('ParseTree conversion not supported: ${child.name}');
      }
    }
    Page pageObj = Page(slideId: data.slideId, components: pageComponents);

    return pageObj;
  }

  DividerComponent _createDivider(PrsNode root) {
    if (root is! ConnectionNode) {
      throw ArgumentError('${root.name} is not a connection line');
    }

    ConnectionNode cxn = root;

    return DividerComponent(
        x: SizeConverter.getPointPercentX(
            cxn.transform.offset.x, _slideWidth, _padding),
        y: SizeConverter.getPointPercentY(
            cxn.transform.offset.y, _slideHeight, _padding),
        width: SizeConverter.getSizePercentX(
            cxn.transform.size.x, _slideWidth, _padding),
        height: SizeConverter.getSizePercentY(
            cxn.transform.size.y, _slideHeight, _padding),
        thickness: cxn.weight);
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
        imagePath: data.path.replaceFirst('../media', 'resources/images'),
        x: SizeConverter.getPointPercentX(size.x, _slideWidth, _padding),
        y: SizeConverter.getPointPercentY(size.y, _slideHeight, _padding),
        width: SizeConverter.getSizePercentX(offset.x, _slideWidth, _padding),
        height: SizeConverter.getSizePercentY(offset.y, _slideHeight, _padding),
        hyperlink: data.hyperlink?.toString());
    return imageComponentObj;
  }

  // TODO: Create Text Components. Check with team on status of text components
  TextComponent _createTextBox(PrsNode root) {
    late final Transform tsr;
    late final TextBodyNode textBody;
    List<TextPart> textParts = [];

    if (root.name != 'textbox') {
      throw ArgumentError('${root.name} is not a textbox');
    }

    TextBoxNode prsTextBox = root as TextBoxNode;

    for (PrsNode child in prsTextBox.children) {
      if (child is ShapeNode) {
        tsr = child.transform as Transform;
      }
      if (child is TextBodyNode) {
        textBody = child;
        for (PrsNode textChild in textBody.children) {
          if (textChild is TextParagraphNode) {
            for (PrsNode pChild in textChild.children) {
              if (pChild is TextNode) {
                TextPart text = TextPart(
                    text: pChild.text ?? "",
                    fontSize: (pChild.size?.toDouble() ?? defaultFontSize) /
                        sizeToPointFactor,
                    fontStyle:
                        pChild.italics ? FontStyle.italic : FontStyle.normal,
                    fontWeight:
                        pChild.bold ? FontWeight.bold : FontWeight.normal,
                    fontUnderline: pChild.underline
                        ? TextDecoration.underline
                        : TextDecoration.none);
                // ToDo: Reenable color.  Disabling due to unmapped values in presentation parser _parseText
                // color: pChild.color != null ? Color(pChild.color) : null );
                textParts.add(text);
              }
            }
          }
        }
      }
    }

    return TextComponent(
        textChildren: textParts,
        x: SizeConverter.getPointPercentX(tsr.offset.x, _slideWidth, _padding),
        y: SizeConverter.getPointPercentY(tsr.offset.y, _slideHeight, _padding),
        width: SizeConverter.getSizePercentX(tsr.size.x, _slideWidth, _padding),
        height:
            SizeConverter.getSizePercentY(tsr.size.y, _slideHeight, _padding));
  }

  // TODO: Create Necessary Components
  //

  // TODO: Create Game Components
}
