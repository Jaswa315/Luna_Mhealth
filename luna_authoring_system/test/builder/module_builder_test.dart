import 'package:test/test.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/builder/sequence_of_page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/utils/version_manager.dart';

class TestSection extends Section {
  @override
  final Map<String, List<int>> value;

  TestSection(this.value) : super(value);
}

void main() {
  group('ModuleBuilder Tests', () {
    late ModuleBuilder builder;
    late VersionManager versionManager;

    setUp(() {
      builder = ModuleBuilder();
      versionManager = VersionManager(); // Getting the singleton instance
      versionManager
          .setTestVersion("1.0.1"); // Setting a specific version for testing
    });

    test('Should set and get title correctly', () {
      String expectedTitle = "Module for Testing Title";
      builder.setTitle(expectedTitle);
      builder.setAuthor("Author for Title Test");
      builder.setDimensions(EMU(1920000).value, EMU(1080000).value);
      final dummySlide = Slide()..shapes = [];
      builder.setSequencesFromSection(
          [dummySlide],
          TestSection({
            'section': [1]
          }));
      Module result = builder.build();
      expect(result.title, equals(expectedTitle));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should correctly process slides into pages', () {
      PptxTree mockTree = PptxTree();
      mockTree.title = "Mock Module";
      mockTree.author = "Test Author";
      mockTree.width = EMU(1920000);
      mockTree.height = EMU(1080000);

      final dummySlide = Slide();
      dummySlide.shapes = [];

      mockTree.slides = [dummySlide, dummySlide, dummySlide];
      mockTree.section = TestSection({
        'section-1': [1, 2, 3]
      });

      builder
          .setTitle("Test Module")
          .setAuthor("Test Author")
          .setDimensions(EMU(1920000).value, EMU(1080000).value)
          .setSequencesFromSection(mockTree.slides, mockTree.section)
          .build();

      final result = builder.build();
      final totalPages = result.setOfSequenceOfPages
          .expand((seq) => seq.sequenceOfPages)
          .length;
      expect(totalPages, equals(3));
    });

    test('Should correctly process empty pptx tree', () {
      PptxTree mockTree = PptxTree();
      mockTree.title = "Mock Module";
      mockTree.author = "Test Author";
      mockTree.width = EMU(1920000);
      mockTree.height = EMU(1080000);
      mockTree.slides = [];
      mockTree.section = TestSection({});

      expect(
        () => builder
            .setTitle("Test Module")
            .setAuthor("Test Author")
            .setDimensions(EMU(1920000).value, EMU(1080000).value)
            .setSequencesFromSection(mockTree.slides, mockTree.section),
        throwsA(isA<StateError>()),
      );
    });

    test('Should set and get author correctly', () {
      String expectedAuthor = "Author Name";
      builder.setTitle("Some Title");
      builder.setAuthor(expectedAuthor);
      builder.setDimensions(EMU(1920000).value, EMU(1080000).value);
      final dummySlide = Slide()..shapes = [];
      builder.setSequencesFromSection(
          [dummySlide],
          TestSection({
            'section': [1]
          }));
      Module result = builder.build();
      expect(result.author, equals(expectedAuthor));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should calculate aspect ratio correctly', () {
      builder.setTitle("Aspect Ratio Title");
      builder.setAuthor("Aspect Ratio Author");
      builder.setDimensions(EMU(2560000).value, EMU(1440000).value);
      final dummySlide = Slide()..shapes = [];
      builder.setSequencesFromSection(
          [dummySlide],
          TestSection({
            'section': [1]
          }));
      Module result = builder.build();
      expect(
          result.aspectRatio, equals(EMU(1440000).value / EMU(2560000).value));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should generate a unique module ID for each instance', () {
      builder.setTitle("Unique ID Title");
      builder.setAuthor("Unique ID Author");
      builder.setDimensions(EMU(1920000).value, EMU(1080000).value);

      ModuleBuilder builder1 = ModuleBuilder();
      builder1.setTitle("Module 1");
      builder1.setAuthor("Author 1");
      builder1.setDimensions(EMU(1920000).value, EMU(1080000).value);
      final dummySlide1 = Slide()..shapes = [];
      builder1.setSequencesFromSection(
          [dummySlide1],
          TestSection({
            'section': [1]
          }));

      ModuleBuilder builder2 = ModuleBuilder();
      builder2.setTitle("Module 2");
      builder2.setAuthor("Author 2");
      builder2.setDimensions(EMU(1920000).value, EMU(1080000).value);
      final dummySlide2 = Slide()..shapes = [];
      builder2.setSequencesFromSection(
          [dummySlide2],
          TestSection({
            'section': [1]
          }));

      Module result1 = builder1.build();
      Module result2 = builder2.build();

      expect(result1.moduleId, isNot(equals(result2.moduleId)));
      expect(result1.authoringVersion, equals(versionManager.version));
      expect(result2.authoringVersion, equals(versionManager.version));
    });

    test('Should correctly set and retrieve module width and height', () {
      // Arrange
      int expectedWidth = EMU(1920000).value; // Example width in EMUs
      int expectedHeight = EMU(1080000).value; // Example height in EMUs

      // Act
      builder.setDimensions(expectedWidth, expectedHeight);
      final dummySlide = Slide()..shapes = [];
      builder.setSequencesFromSection(
          [dummySlide],
          TestSection({
            'section': [1]
          }));

      // Assert
      expect(ModuleBuilder.moduleWidth, equals(expectedWidth));
      expect(ModuleBuilder.moduleHeight, equals(expectedHeight));
    });

    tearDown(() {
      versionManager.resetVersion();
    });
  });
}
