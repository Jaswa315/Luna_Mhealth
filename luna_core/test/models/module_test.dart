import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/component.dart';
import 'dart:convert';

void main() {
  group('Module Class Tests', () {
    test('Module is created with expected properties', () {
      final entryPg = Page(components: [], slideNumber: 1);
      final module = Module(
        moduleId: '12345',
        title: 'This is title',
        author: 'Test Author',
        authoringVersion: '1.0.0',
        setOfSequenceOfPages: {
          SequenceOfPages(sequenceOfPages: [entryPg])
        },
        aspectRatio: 16 / 9,
        entryPage: entryPg,
      );

      expect(module.moduleId, '12345');
      expect(module.title, 'This is title');
      expect(module.author, 'Test Author');
      expect(module.authoringVersion, '1.0.0');
      expect(module.setOfSequenceOfPages.length, 1);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages.length, 1);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages[0].components,
          isEmpty);
      expect(module.aspectRatio, closeTo(1.7777, 0.0001));
      expect(module.entryPage, entryPg);
    });

    test('Deserialization from valid JSON with empty pages', () {
      final json = {
        'module': {
          'moduleId': '12345',
          'title': 'This is title',
          'author': 'John Doe',
          'authoringVersion': '1.0.0',
          'setOfSequenceOfPages': ['sequence_1'],
          'aspectRatio': 1.7777777777777777,
          'entryPage': 'page_1',
        },
        'definitions': {
          'page_1': {'type': 'page', 'shapes': [], 'slideNumber': 1},
          'sequence_1': {
            'sequenceOfPages': ['page_1']
          }
        }
      };

      final module = Module.fromJson(json);

      expect(module.moduleId, '12345');
      expect(module.title, 'This is title');
      expect(module.author, 'John Doe');
      expect(module.authoringVersion, '1.0.0');
      expect(module.setOfSequenceOfPages.length, 1);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages.length, 1);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages[0].components,
          isEmpty);
      expect(module.aspectRatio, closeTo(1.7777777, 0.0001));
      expect(module.entryPage.runtimeType, Page);
      expect(module.entryPage.components, isEmpty);
      expect(module.entryPage.slideNumber, 1);
    });

    test('Deserialization from valid JSON with pages', () {
      final json = {
        'module': {
          'moduleId': '54321',
          'title': 'Module with Pages',
          'author': 'Jane Doe',
          'authoringVersion': '1.0.0',
          'setOfSequenceOfPages': ['sequence_1'],
          'aspectRatio': 16 / 9,
          'entryPage': 'page_1',
        },
        'definitions': {
          'page_1': {'type': 'page', 'shapes': [], 'slideNumber': 1},
          'page_2': {'type': 'page', 'shapes': [], 'slideNumber': 2},
          'sequence_1': {
            'sequenceOfPages': ['page_1', 'page_2']
          }
        }
      };

      final module = Module.fromJson(json);

      expect(module.moduleId, '54321');
      expect(module.setOfSequenceOfPages.length, 1);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages.length, 2);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages[0].components,
          isEmpty);
      expect(module.setOfSequenceOfPages.first.sequenceOfPages[1].components,
          isEmpty);
      expect(module.aspectRatio, closeTo(1.7777, 0.0001));
      expect(module.entryPage.runtimeType, Page);
      expect(module.entryPage.components, isEmpty);
    });

    test('Deserialization fails if one required field is missing', () {
      final jsonMissingAuthor = {
        'module': {
          'moduleId': '12345',
          'title': 'This is title',
          // Missing 'author'
          'authoringVersion': '1.0.0',
          'setOfSequenceOfPages': [],
          'aspectRatio': 1.7777777777777777,
          'entryPage': 'page_1',
        },
        'definitions': {
          'page_1': {'type': 'page', 'shapes': []}
        }
      };

      expect(
        () => Module.fromJson(jsonMissingAuthor),
        throwsA(isA<TypeError>()),
      );
    });

    test('Deserialization fails if aspectRatio is not a number', () {
      final invalidAspectRatioJson = {
        'module': {
          'moduleId': '12345',
          'title': 'This is title',
          'author': 'John Doe',
          'authoringVersion': '1.0.0',
          'setOfSequenceOfPages': [],
          'aspectRatio': 'not a number', // Wrong type
          'entryPage': 'page_1',
        },
        'definitions': {
          'page_1': {'type': 'page', 'shapes': []}
        }
      };

      expect(
        () => Module.fromJson(invalidAspectRatioJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('Deserialization fails if a page has wrong type', () {
      final json = {
        'module': {
          'moduleId': '12345',
          'title': 'Module with Invalid Page',
          'author': 'John Doe',
          'authoringVersion': '1.0.0',
          'setOfSequenceOfPages': ['sequence_1'],
          'aspectRatio': 16 / 9,
          'entryPage': 'page_1',
        },
        'definitions': {
          'page_1': {'type': 'not_page', 'shapes': []}, // Invalid type
          'sequence_1': {
            'sequenceOfPages': ['page_1']
          }
        }
      };

      expect(
        () => Module.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
