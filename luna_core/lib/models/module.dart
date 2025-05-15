import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a module in the application.
/// A module can contain multiple sequences of pages.
/// Each sequence can have multiple pages, and each page can have multiple components.
/// The module also has metadata such as title, author, and aspect ratio.
/// The moduleId is a unique identifier for the module.

class Module {
  final String moduleId;
  final String title;
  final String author;
  final String authoringVersion;
  final Set<SequenceOfPages> sequences;

  ///// Aspect ratio (height/width)
  final double aspectRatio;

  final Page entryPage;

  // Constructor with required parameters
  Module({
    required this.moduleId,
    required this.title,
    required this.author,
    required this.authoringVersion,
    required this.sequences,
    required this.aspectRatio,
    required this.entryPage,
  });

  /// Factory method to create a [Module] from JSON.
  factory Module.fromJson(Json json) {
    final serializedDefinitions = Map<String, Json>.from(json['definitions']);
    final idToObject = <String, Object>{};
    final sequences = <SequenceOfPages>{};

    for (final seqId in json['module']['sequences']) {
      final seqJson = serializedDefinitions[seqId];
      final sequence = SequenceOfPages.fromJson(
        seqJson!,
        seqId,
        idToObject,
        serializedDefinitions,
      );
      sequences.add(sequence);
    }

    final entryPageId = json['module']['entryPage'];
    final entryPage = idToObject[entryPageId] as Page;

    return Module(
      moduleId: json['module']['moduleId'] as String,
      title: json['module']['title'] as String,
      author: json['module']['author'] as String,
      authoringVersion: json['module']['authoringVersion'],
      sequences: sequences,
      aspectRatio: (json['module']['aspectRatio'] as num).toDouble(),
      entryPage: entryPage,
    );
  }

  /// Converts the [Module] object to a JSON map.
  Json toJson() {
    final objectIdMap = <Object, String>{};
    final serializedDefinitions = <String, Json>{};

    final sequenceIds = sequences.map((seq) {
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
        'sequences': sequenceIds,
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
