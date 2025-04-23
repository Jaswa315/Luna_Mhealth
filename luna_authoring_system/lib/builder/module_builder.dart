import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/utils/version_manager.dart';
import 'package:uuid/uuid.dart';

/// ModuleBuilder is responsible for constructing a [Module] object.
/// It aggregates metadata such as the title, author, dimensions, and pages.

/// The [ModuleBuilder] follows the builder pattern to construct a Module object.
/// This approach is chosen to:
/// - Ensure step-by-step configurability, allowing for flexibility in module creation.
/// - Maintain immutability in the final [Module] instance, reducing unintended modifications.

class ModuleBuilder implements IBuilder<Module> {
  late final String _moduleId;
  late String _title;
  late String _author;
  late double _aspectRatio;
  static late int _moduleWidth;
  static late int _moduleHeight;
  final List<Page> _pages = [];

  ModuleBuilder() {
    _moduleId = Uuid().v4();
  }

  int get moduleWidth => _moduleWidth;
  int get moduleHeight => _moduleHeight;

  ModuleBuilder setTitle(String title) {
    _title = title;

    return this;
  }

  ModuleBuilder setAuthor(String author) {
    _author = author;

    return this;
  }

  /// Aspect Ratio Calculation: Instead of taking an aspect ratio as an
  /// explicit parameter, it is derived from module dimensions
  /// to prevent inconsistencies.
  ModuleBuilder setDimensions(int moduleWidth, int moduleHeight) {
    _moduleWidth = moduleWidth;
    _moduleHeight = moduleHeight;
    _aspectRatio = _moduleHeight / _moduleWidth;

    return this;
  }

  ModuleBuilder setPages(PptxTree pptxTree) {
    _pages.clear();
    for (var slide in pptxTree.slides) {
      _pages.add(
        PageBuilder(_moduleWidth, _moduleHeight)
            .buildPage(slide.shapes ?? [])
            .build(),
      );
    }

    return this;
  }

  @override
  Module build() {
    return Module(
      moduleId: _moduleId,
      title: _title,
      author: _author,
      authoringVersion: VersionManager().version,
      pages: _pages,
      aspectRatio: _aspectRatio,
    );
  }
}
