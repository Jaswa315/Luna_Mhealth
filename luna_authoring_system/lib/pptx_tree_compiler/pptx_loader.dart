import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

/// `PptxLoader` is responsible for extracting, loading, and converting XML files
/// from a `.pptx` archive (which is a ZIP file containing XML-based slide data).
///
/// This class extracts the `.pptx` file only once to a temporary directory,
/// maintains its original folder structure, and provides methods to retrieve XML
/// files as JSON for easier processing.
///
/// Assumes: `_pptxFile` is a valid `.pptx` file.
class PptxLoader {
  final File _pptxFile;
  late final Directory _tempDir;
  bool _isExtracted = false;

  PptxLoader(this._pptxFile) {
    _tempDir = Directory.systemTemp.createTempSync('pptx_loader_');
  }

  /// Extracts the `.pptx` archive while preserving its original file structure
  /// and saves the extracted files in `_tempDir`.
  /// Input: None.
  /// Returns: `void` (Extracts files into `_tempDir`).
  void _extractPptxOnce() {
    if (_isExtracted) return;
    var bytes = _pptxFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      if (file.isFile) {
        var extractedFilePath = p.join(_tempDir.path, file.name);
        var outFile = File(extractedFilePath);

        outFile.createSync(recursive: true);
        outFile.writeAsBytesSync(file.content as List<int>);
      }
    }
    _isExtracted = true;
  }

  /// Loads an XML file from the extracted temp storage. Throws an exception if missing.
  /// Input:`filePath` (relative path to the XML file inside `_tempDir`).
  /// Returns: `XmlDocument` representing the parsed XML content.
  XmlDocument _loadXml(String filePath) {
    _extractPptxOnce();
    var fullPath = p.join(_tempDir.path, filePath);
    var file = File(fullPath);

    if (!file.existsSync()) {
      throw Exception("XML file not found: $filePath");
    }

    return XmlDocument.parse(file.readAsStringSync());
  }

  /// Converts XML into a JSON-friendly structure.
  /// Input: `document` (`XmlDocument`) containing structured XML.
  /// Returns: `Map<String, dynamic>` representing the JSON structure of the XML.
  dynamic _transformXmlToJson(XmlDocument document) {
    Xml2Json xml2json = Xml2Json();
    // "&#xA" is equivalent to Line Feed Character (\n)
    String processedXml = document.toXmlString().replaceAll('&#xA;', '\\n');
    xml2json.parse(processedXml);

    return jsonDecode(xml2json.toParkerWithAttrs());
  }

  /// Retrieves an XML file, converts it to JSON, and returns it.
  /// Input: `xmlFilePath` (relative path to the XML file in `_tempDir`).
  /// Returns: `Map<String, dynamic>` representing the JSON structure of the XML.
  dynamic getJsonFromPptx(String xmlFilePath) {
    XmlDocument doc = _loadXml(xmlFilePath);
    return _transformXmlToJson(doc);
  }

  /// Returns the path of the temporary directory where `.pptx` files are extracted.
  /// Input: None.
  /// Returns: `String` representing the absolute path of `_tempDir`.
  String getTempPath() {
    return _tempDir.path;
  }

  /// Deletes extracted files and removes the temp directory.
  /// Input: None.
  /// Returns: `void` (Deletes files from `_tempDir`).
  void dispose() {
    if (_tempDir.existsSync()) {
      _tempDir.deleteSync(recursive: true);
    }
  }
}
