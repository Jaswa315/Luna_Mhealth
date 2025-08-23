import 'dart:ui';
import 'package:test/test.dart';
import 'package:luna_authoring_system/translator/csv_export_use_case.dart';
import 'package:luna_authoring_system/storage/csv_writer.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/percent.dart';

/// Test double 
class FakeCsvWriter extends CsvWriter {
  bool called = false;
  String? capturedPath;
  String? capturedCsv;

  @override
  Future<bool> saveCsvToFile(String filePath, String csvText) async {
    called = true;
    capturedPath = filePath;
    capturedCsv = csvText;
    return true; // Simulate successful write
  }
}

/// Helpers to build tiny Modules inline
Module _moduleWithTexts(List<String> texts) {
  final page = Page(
    slideNumber: 1,
    components: [
      TextComponent(
        textChildren: texts.map((t) => TextPart(text: t)).toList(),
        boundingBox: BoundingBox(
          topLeftCorner: const Offset(0, 0),
          width: DisplayPixel(0),
          height: Percent(0),
        ),
      ),
    ],
  );

  final sequence = SequenceOfPages(sequenceOfPages: [page]);

  return Module(
    moduleId: 'm1',
    title: 'Test',
    author: 'Author',
    authoringVersion: '1.0',
    setOfSequenceOfPages: {sequence},
    aspectRatio: 1.0,
    entryPage: page,
  );
}

void main() {
  group('CsvExportUseCase', () {
    test('returns false and does not write when no non-empty text exists', () async {
      final fakeWriter = FakeCsvWriter();
      final useCase = CsvExportUseCase(writer: fakeWriter);

      // Only empty/whitespace parts → extractor should yield 0 chunks
      final module = _moduleWithTexts(['', '   ']);

      final ok = await useCase.exportModuleToCsv(
        module: module,
        outputFilePath: 'export.csv',
      );

      expect(ok, isFalse);
      expect(fakeWriter.called, isFalse);
    });

    test('writes CSV when text exists (happy path)', () async {
      final fakeWriter = FakeCsvWriter();
      final useCase = CsvExportUseCase(writer: fakeWriter);

      final module = _moduleWithTexts(['Eat healthy during pregnancy']);

      final ok = await useCase.exportModuleToCsv(
        module: module,
        outputFilePath: 'translation.csv',
      );

      expect(ok, isTrue);
      expect(fakeWriter.called, isTrue);
      expect(fakeWriter.capturedPath, 'translation.csv');

      // CSV sanity: has headers and exported text
      expect(fakeWriter.capturedCsv, contains('Slide,Text,Translation'));
      expect(fakeWriter.capturedCsv, contains('Eat healthy during pregnancy'));
    });
  });
}
