import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/utils/version_manager.dart';
import 'package:uuid/uuid.dart';

/// ModuleBuilder is responsible for constructing a `Module` object.
/// It aggregates metadata such as the title, author, dimensions, and pages.
///
/// This builder allows the setting of:
/// - `Title` and `Author` for the module.
/// - `Module dimensions` (width and height).
/// - `Pages`, which are built from slides within a `PptxTree`.
///
/// Once all properties are set, calling `build()` generates a `Module`
/// instance with the configured attributes.

class ModuleBuilder implements IBuilder<Module> {
  late final String _moduleId;
  late String _title;
  late String _author;
  late double _aspectRatio;
  late int _moduleWidth;
  late int _moduleHeight;
  final List<Page> _pages = [];

  ModuleBuilder() {
    _moduleId = Uuid().v4();
  }

  ModuleBuilder setTitle(String title) {
    _title = title;

    return this;
  }

  ModuleBuilder setAuthor(String author) {
    _author = author;

    return this;
  }

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
