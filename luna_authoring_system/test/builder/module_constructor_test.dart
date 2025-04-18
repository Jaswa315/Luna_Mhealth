import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'dart:io';
import 'package:luna_core/utils/version_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    VersionManager().setTestVersion("0.0.1");
  });

  group('Module Construction Tests', () {
    group('Basic Module Construction', () {
      test(
          'Should be able to create module.dart with pptx tree with single slide that has single line',
          () async {
        // Parse the PPTX tree
        PptxTree pptxTree =
            PptxTreeBuilder(File('test/test_assets/A line.pptx')).getPptxTree();

        ModuleConstructor moduleConstructor = ModuleConstructor(pptxTree);

        // Generate the module asynchronously
        Module generatedModule = await moduleConstructor.constructLunaModule();
        expect(generatedModule.pages.length, 1);
        expect(generatedModule.authoringVersion, "0.0.1");
        expect(generatedModule.pages[0].components.length, 1);
        expect(generatedModule.pages[0].components[0], isA<LineComponent>());
      });
      test('Should create a module with a single slide and single line',
          () async {
        final pptxTree = PptxTree();
        pptxTree.title = "Test Module";
        pptxTree.author = "Test Author";
        pptxTree.width = EMU(1920000);
        pptxTree.height = EMU(1080000);

        final slide = Slide();
        slide.shapes = [
          ConnectionShape(
            width: EMU(1000000),
            transform: Transform(
              Point(EMU(500000), EMU(500000)),
              Point(EMU(1000000), EMU(1000000)),
            ),
            isFlippedVertically: false,
          ),
        ];
        pptxTree.slides = [slide];

        final moduleConstructor = ModuleConstructor(pptxTree);
        final generatedModule = await moduleConstructor.constructLunaModule();

        expect(generatedModule.pages.length, 1);
        expect(generatedModule.authoringVersion, "0.0.1");
        expect(generatedModule.pages[0].components.length, 1);
        expect(generatedModule.pages[0].components[0], isA<LineComponent>());
      });

      test('Should correctly assign title and author from PptxTree', () async {
        final pptxTree = PptxTree();
        pptxTree.title = "Test Module";
        pptxTree.author = "Test Author";
        pptxTree.width = EMU(1920000);
        pptxTree.height = EMU(1080000);
        pptxTree.slides = [];

        final moduleConstructor = ModuleConstructor(pptxTree);
        final generatedModule = await moduleConstructor.constructLunaModule();

        expect(generatedModule.title, equals("Test Module"));
        expect(generatedModule.author, equals("Test Author"));
      });
    });

    group('Handling Multiple Slides', () {
      test('Should create a module with multiple slides and multiple lines',
          () async {
        final pptxTree = PptxTree();
        pptxTree.title = "Multi-Slide Module";
        pptxTree.author = "Test Author";
        pptxTree.width = EMU(1920000);
        pptxTree.height = EMU(1080000);

        final slide1 = Slide();
        slide1.shapes = [
          ConnectionShape(
            width: EMU(1000000),
            transform: Transform(
              Point(EMU(500000), EMU(500000)),
              Point(EMU(1000000), EMU(1000000)),
            ),
            isFlippedVertically: false,
          ),
        ];

        final slide2 = Slide();
        slide2.shapes = [
          ConnectionShape(
            width: EMU(800000),
            transform: Transform(
              Point(EMU(200000), EMU(200000)),
              Point(EMU(900000), EMU(900000)),
            ),
            isFlippedVertically: true,
          ),
        ];

        pptxTree.slides = [slide1, slide2];

        final moduleConstructor = ModuleConstructor(pptxTree);
        final generatedModule = await moduleConstructor.constructLunaModule();

        expect(generatedModule.pages.length, 2);
        expect(generatedModule.pages[0].components.length, 1);
        expect(generatedModule.pages[1].components.length, 1);
      });
    });

    group('Handling Edge Cases', () {
      test('Should handle an empty PptxTree without errors', () async {
        final pptxTree = PptxTree();
        pptxTree.title = "Empty Module";
        pptxTree.author = "Test Author";
        pptxTree.width = EMU(1920000);
        pptxTree.height = EMU(1080000);
        pptxTree.slides = [];

        final moduleConstructor = ModuleConstructor(pptxTree);
        final generatedModule = await moduleConstructor.constructLunaModule();

        expect(generatedModule.pages, isEmpty);
      });

      test(
          'Should generate an empty module when PptxTree has no valid components',
          () async {
        final pptxTree = PptxTree();
        pptxTree.title = "Module with No Components";
        pptxTree.author = "Test Author";
        pptxTree.width = EMU(1920000);
        pptxTree.height = EMU(1080000);

        final slide = Slide();
        slide.shapes = [];

        pptxTree.slides = [slide];

        final moduleConstructor = ModuleConstructor(pptxTree);
        final generatedModule = await moduleConstructor.constructLunaModule();

        expect(generatedModule.pages.length, 1);
        expect(generatedModule.pages[0].components, isEmpty);
      });
    });
  });
}
