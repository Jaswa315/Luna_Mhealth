import 'dart:ui';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/percent.dart';

/// Test-only factory: creates a small Module for unit/integration tests.
Module createFakeModule() {
  final page1 = Page(components: [
    TextComponent(
      textChildren: [TextPart(text: 'Eat healthy during pregnancy')],
      boundingBox: BoundingBox(
        topLeftCorner: const Offset(0, 0),
        width: DisplayPixel(0),
        height: Percent(0),
      ),
    ),
  ]);

  final page2 = Page(components: [
    TextComponent(
      textChildren: [TextPart(text: 'Visit a clinic if you feel weak or dizzy')],
      boundingBox: BoundingBox(
        topLeftCorner: const Offset(0, 0),
        width: DisplayPixel(0),
        height: Percent(0),
      ),
    ),
  ]);

  final sequence = SequenceOfPages(sequenceOfPages: [page1, page2]);

  return Module(
    moduleId: 'fakeModule',
    title: 'Pregnancy Tips',
    author: 'Lakshmi',
    authoringVersion: '1.0',
    setOfSequenceOfPages: {sequence},
    aspectRatio: 1.0,
    entryPage: page1,
  );
}
