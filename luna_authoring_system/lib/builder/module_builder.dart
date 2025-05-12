import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/builder/sequence_of_page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/utils/version_manager.dart';
import 'package:uuid/uuid.dart';

/// ModuleBuilder is responsible for constructing a [Module] object.
/// It aggregates metadata such as the title, author, dimensions, and sequences of pages.
class ModuleBuilder implements IBuilder<Module> {
  late final String _moduleId;
  late String _title;
  late String _author;
  late double _aspectRatio;
  static late int _moduleWidth;
  static late int _moduleHeight;
  final Set<SequenceOfPages> _sequences = {};
  late final Page _entryPage;

  ModuleBuilder() {
    _moduleId = const Uuid().v4();
  }

  static int get moduleWidth => _moduleWidth;
  static int get moduleHeight => _moduleHeight;

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

  /// Converts the provided [slides] and [section] into sequences using SequenceOfPageBuilder.
  ModuleBuilder setSequencesFromSection(List<Slide> slides, Section section) {
    final SequenceOfPageBuilder builder =
        SequenceOfPageBuilder(slides: slides, section: section);
    final Set<SequenceOfPages> sequences = builder.build();

    _sequences
      ..clear()
      ..addAll(sequences);

    _entryPage = builder.firstPage;

    return this;
  }

  @override
  Module build() {
    return Module(
      moduleId: _moduleId,
      title: _title,
      author: _author,
      authoringVersion: VersionManager().version,
      sequences: _sequences,
      aspectRatio: _aspectRatio,
      entryPage: _entryPage,
    );
  }
}
