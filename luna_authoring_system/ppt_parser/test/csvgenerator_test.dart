import 'dart:io';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/textnode_uniqueid_assigner.dart';
import 'package:ppt_parser/csv_generator.dart'; // Assuming you have a CSVGenerator class
import 'package:path/path.dart' as path;

const String assetsFolder = 'test/test_assets';
const String outputFolder = 'test/output';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CSVGenerator Class Tests', () {
    setUpAll(() async {
      //LogManager.createInstance();
      // Ensure the output directory exists
      await Directory(outputFolder).create(recursive: true);
    });

    tearDownAll(() async {
      // Clean up and remove the output directory after tests are done
      if (await Directory(outputFolder).exists()) {
        await Directory(outputFolder).delete(recursive: true);
      }
    });

    Future<PrsNode> getPresentationData(var pptx_name) async {
      File file = File("$assetsFolder/$pptx_name");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsData = await parser.toPrsNode();
      return prsData;
    }

    List<String> _getCSVColumnElements(String columnAsString) {
      return columnAsString
          .substring(1, columnAsString.length - 1)
          .split('","');
    }

    test(
        'CSVGenerator: Generate a CSV, given a PrsNode with one element. Check file exists and named correctly.',
        () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      CSVGenerator generator = CSVGenerator();
      Locale language = Locale('en', 'US');
      File csvFile =
          await generator.createCSVFromPrsDataTextNodes(data, language);
      expect(csvFile.existsSync(), isTrue);
      expect(path.basename(csvFile.path),
          equals('${language.toLanguageTag()}.csv'));
    });

    test('CSVGenerator: CSV File Exists when saved to disk', () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);

      CSVGenerator generator = CSVGenerator();
      Locale language = Locale('en', 'US');

      // Generate the CSV and obtain it as a File object
      File csvFile =
          await generator.createCSVFromPrsDataTextNodes(data, language);

      // Save this file to a specific directory
      String targetFilePath =
          path.join(outputFolder, path.basename(csvFile.path));
      await csvFile.copy(targetFilePath);

      // Check that the file was saved correctly
      File savedFile = File(targetFilePath);
      expect(savedFile.existsSync(), isTrue);
      expect(path.basename(savedFile.path),
          equals('${language.toLanguageTag()}.csv'));
    });
    test(
        'CSVGenerator: Generate a CSV, given a PrsNode with one element. Check that CSV strings are correct.',
        () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      CSVGenerator generator = CSVGenerator();
      Locale language = Locale('en', 'US');
      File csvFile =
          await generator.createCSVFromPrsDataTextNodes(data, language);
      List<String> lines = await csvFile.readAsLines();
      expect(lines.length, 2);
      List<String> columns = lines[0].split(',');
      expect(columns[0], 'textID');
      expect(columns[1], 'originalText');
      expect(columns[2], 'translatedText');
      columns = _getCSVColumnElements(lines[1]);
      expect(columns[0], '1');
      expect(columns[1], 'Hello, World!');
      expect(columns[2], 'Hello, World!');
    });
  });
}
