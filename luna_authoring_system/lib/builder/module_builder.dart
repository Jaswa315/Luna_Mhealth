import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/utils/version_manager.dart';
import 'package:uuid/uuid.dart';

class ModuleBuilder implements IBuilder<Module> {
  late final String _moduleId;
  late String _title;
  late String _author;
  late double _aspectRatio;
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

  ModuleBuilder setDimensions(int _moduleWidth, int _moduleHeight) {
    _aspectRatio = _moduleHeight / _moduleWidth;

    return this;
  }

  /*
  ModuleBuilder setPages(PptxTree pptxTree) {
    _pages.clear();
    for (var slide in pptxTree.slides) {
  
      Page page = PageBuilder(_moduleWidth, _moduleHeight).buildPage(slide.shapes);
      _pages.add(page);
    }

    return this;
  }
  */

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
