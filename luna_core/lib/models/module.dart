import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a module in the application.
/// A module can contain multiple setOfSequenceOfPages of pages.
/// Each sequence can have multiple pages, and each page can have multiple components.
/// The module also has metadata such as title, author, and aspect ratio.
/// The moduleId is a unique identifier for the module.

class Module {
  final String moduleId;
  final String title;
  final String author;
  final String authoringVersion;
  final Set<SequenceOfPages> setOfSequenceOfPages;

  ///// Aspect ratio (height/width)
  final double aspectRatio;

  final Page entryPage;

  // Constructor with required parameters
  Module({
    required this.moduleId,
    required this.title,
    required this.author,
    required this.authoringVersion,
    required this.setOfSequenceOfPages,
    required this.aspectRatio,
    required this.entryPage,
  });

  /// Factory constructor that creates a [Module] from a JSON structure.
  ///
  /// It reconstructs [SequenceOfPages] and [Page] objects using their serialized
  /// representations in the 'definitions' map. References such as the entry page
  /// are resolved using the ID-to-object map to restore full object linkage.
  factory Module.fromJson(Json json) {
    final serializedDefinitions = Map<String, Json>.from(json['definitions']);
    final idToObject = <String, Object>{};
    final setOfSequenceOfPages = <SequenceOfPages>{};

    for (final seqId in json['module']['setOfSequenceOfPages']) {
      final seqJson = serializedDefinitions[seqId];
      final sequence = SequenceOfPages.fromJson(
        seqJson!,
        seqId,
        idToObject,
        serializedDefinitions,
      );
      setOfSequenceOfPages.add(sequence);
    }

    final entryPageId = json['module']['entryPage'];
    final entryPage = idToObject[entryPageId] as Page;

    return Module(
      moduleId: json['module']['moduleId'] as String,
      title: json['module']['title'] as String,
      author: json['module']['author'] as String,
      authoringVersion: json['module']['authoringVersion'],
      setOfSequenceOfPages: setOfSequenceOfPages,
      aspectRatio: (json['module']['aspectRatio'] as num).toDouble(),
      entryPage: entryPage,
    );
  }

  /// Converts the [Module] object to a JSON-compatible map.
  ///
  /// It assigns unique string IDs to all [SequenceOfPages] and [Page] objects,
  /// stores their serialized data under a 'definitions' map, and references
  /// them by ID in the main 'module' object. This structure reduces duplication
  /// and preserves clear references between objects.
  Json toJson() {
    final objectIdMap = <Object, String>{};
    final serializedDefinitions = <String, Json>{};

    final sequenceIds = setOfSequenceOfPages.map((seq) {
      final id =
          objectIdMap.putIfAbsent(seq, () => 'seq_${objectIdMap.length}');
      serializedDefinitions[id] =
          seq.toJson(objectIdMap, serializedDefinitions);

      return id;
    }).toList();

    final entryPageId =
        objectIdMap.putIfAbsent(entryPage, () => 'page_${objectIdMap.length}');
    serializedDefinitions[entryPageId] =
        entryPage.toJson(objectIdMap, serializedDefinitions);

    return {
      'module': {
        'moduleId': moduleId,
        'title': title,
        'author': author,
        'authoringVersion': authoringVersion,
        'setOfSequenceOfPages': sequenceIds,
        'aspectRatio': aspectRatio,
        'entryPage': entryPageId,
      },
      'definitions': serializedDefinitions,
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}
