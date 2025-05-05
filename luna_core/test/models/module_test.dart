import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/component.dart';
import 'dart:convert';

void main() {
  group('Module Class Tests', () {
    test('Module is created with expected properties', () {
      final module = Module(
        moduleId: '12345',
        title: 'This is title',
        author: 'Test Author',
        authoringVersion: '1.0.0',
        sequences: {
          SequenceOfPages(pages: [Page(components: [])])
        },
        aspectRatio: 16 / 9,
      );

      expect(module.moduleId, '12345');
      expect(module.title, 'This is title');
      expect(module.author, 'Test Author');
      expect(module.authoringVersion, '1.0.0');
      expect(module.sequences.length, 1);
      expect(module.sequences.first.pages.length, 1);
      expect(module.sequences.first.pages[0].components, isEmpty);
      expect(module.aspectRatio, closeTo(1.7777, 0.0001));
    });

    test('Deserialization from valid JSON with empty pages', () {
      final json = {
        'module': {
          'moduleId': '12345',
          'title': 'This is title',
          'author': 'John Doe',
          'authoringVersion': '1.0.0',
          'sequences': [],
          'aspectRatio': 1.7777777777777777,
        }
      };

      final module = Module.fromJson(json);

      expect(module.moduleId, '12345');
      expect(module.title, 'This is title');
      expect(module.author, 'John Doe');
      expect(module.authoringVersion, '1.0.0');
      expect(module.sequences, isEmpty);
      expect(module.aspectRatio, closeTo(1.7777777, 0.0001));
    });

    test('Deserialization from valid JSON with pages', () {
      final json = {
        'module': {
          'moduleId': '54321',
          'title': 'Module with Pages',
          'author': 'Jane Doe',
          'authoringVersion': '1.0.0',
          'sequences': [
            {
              'pages': [
                {
                  'type': 'page',
                  'shapes': [],
                },
                {
                  'type': 'page',
                  'shapes': [],
                }
              ]
            }
          ],
          'aspectRatio': 16 / 9,
        }
      };

      final module = Module.fromJson(json);

      expect(module.moduleId, '54321');
      expect(module.sequences.length, 1);
      expect(module.sequences.first.pages.length, 2);
      expect(module.sequences.first.pages[0].components, isEmpty);
      expect(module.sequences.first.pages[1].components, isEmpty);
      expect(module.aspectRatio, closeTo(1.7777, 0.0001));
    });

    test('Serialization to JSON', () {
      final module = Module(
        moduleId: '98765',
        title: 'Serializable Module',
        author: 'Author Name',
        authoringVersion: '1.0.0',
        sequences: {
          SequenceOfPages(pages: [
            Page(components: []),
            Page(components: []),
          ])
        },
        aspectRatio: 4 / 3,
      );

      final json = module.toJson();

      expect(json['module']['moduleId'], '98765');
      expect(json['module']['title'], 'Serializable Module');
      expect(json['module']['author'], 'Author Name');
      expect(json['module']['authoringVersion'], '1.0.0');
      expect(json['module']['sequences'].length, 1);
      expect(json['module']['sequences'][0]['pages'].length, 2);
      expect(json['module']['aspectRatio'], closeTo(1.3333, 0.0001));
    });

    test('Deserialization fails if one required field is missing', () {
      final jsonMissingAuthor = {
        'module': {
          'moduleId': '12345',
          'title': 'This is title',
          // Missing 'author'
          'authoringVersion': '1.0.0',
          'sequences': [],
          'aspectRatio': 1.7777777777777777,
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
          'sequences': [],
          'aspectRatio': 'not a number', // Wrong type
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
          'sequences': [
            {
              'pages': [
                {
                  'type': 'not_page', // Invalid type, should be 'page'
                  'shapes': [],
                },
              ]
            }
          ],
          'aspectRatio': 16 / 9,
        }
      };

      expect(
        () => Module.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
