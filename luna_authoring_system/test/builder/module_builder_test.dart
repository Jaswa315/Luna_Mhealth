import 'package:test/test.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/utils/version_manager.dart'; // Ensure this import path is correct

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
      builder.setDimensions(1920000, 1080000);
      Module result = builder.build();
      expect(result.title, equals(expectedTitle));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should set and get author correctly', () {
      String expectedAuthor = "Author Name";
      builder.setTitle("Some Title");
      builder.setAuthor(expectedAuthor);
      builder.setDimensions(1920000, 1080000);
      Module result = builder.build();
      expect(result.author, equals(expectedAuthor));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should calculate aspect ratio correctly', () {
      builder.setTitle("Aspect Ratio Title");
      builder.setAuthor("Aspect Ratio Author");
      builder.setDimensions(2560000, 1440000);
      Module result = builder.build();
      expect(result.aspectRatio, equals(1440000 / 2560000));
      expect(result.authoringVersion, equals(versionManager.version));
    });

    test('Should generate a unique module ID for each instance', () {
      builder.setTitle("Unique ID Title");
      builder.setAuthor("Unique ID Author");
      builder.setDimensions(1920000, 1080000);

      ModuleBuilder builder1 = ModuleBuilder();
      builder1.setTitle("Module 1");
      builder1.setAuthor("Author 1");
      builder1.setDimensions(1920000, 1080000);

      ModuleBuilder builder2 = ModuleBuilder();
      builder2.setTitle("Module 2");
      builder2.setAuthor("Author 2");
      builder2.setDimensions(1920000, 1080000);

      Module result1 = builder1.build();
      Module result2 = builder2.build();

      expect(result1.moduleId, isNot(equals(result2.moduleId)));
      expect(result1.authoringVersion, equals(versionManager.version));
      expect(result2.authoringVersion, equals(versionManager.version));
    });

    tearDown(() {
      versionManager.resetVersion();
    });
  });
}
