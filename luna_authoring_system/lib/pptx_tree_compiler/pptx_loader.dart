import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

/// PptxLoader creates in-memory representation of the .pptx.
/// .pptx files are ZIP archives containing XML documents and embedded resources.
/// .pptx file is decompressed using ZipDecoder.
/// XML files are extracted
/// Assumes pptxFile is a valid file. 
class PptxLoader {
  late final File _pptxFile;

  PptxLoader(File pptxFilePath) {

    _pptxFile = pptxFilePath;

  }


  ArchiveFile _extractFileFromPptx(String filePath) {
    var bytes = _pptxFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    return archive.firstWhere((file) => p.equals(file.name, filePath));
  }

  XmlDocument _extractXmlFromPptx(String xmlFilePath) {
    return XmlDocument.parse(
      utf8.decode(_extractFileFromPptx(xmlFilePath).content),
    );
  }

  dynamic _transformXmlToJson(XmlDocument document) {
    Xml2Json xml2json = Xml2Json();

    // "&#xA" is equivalent to Line Feed Character (\n)
    String processedXml = document.toXmlString().replaceAll('&#xA;', '\\n');

    xml2json.parse(processedXml);

    return jsonDecode(xml2json.toParkerWithAttrs());
  }

  dynamic getJsonFromPptx(String xmlFilePath) {
    XmlDocument doc = _extractXmlFromPptx(xmlFilePath);

    return _transformXmlToJson(doc);
  }
}
