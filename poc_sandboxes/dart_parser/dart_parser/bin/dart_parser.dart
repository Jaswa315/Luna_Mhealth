import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

String? extractXMLFromZip(String filename, String xmlFilePath) {
  var bytes = File(filename).readAsBytesSync();
  var archive = ZipDecoder().decodeBytes(bytes);
  var file = archive.firstWhere((file) => file.name == xmlFilePath);
  return utf8.decode(file.content);
}

void extractTextShapes(XmlElement parentElement) {
  for (var child in parentElement.children) {
    if (child is XmlElement) {
      if (child.name.local == 'sp') {
        var off = child
            .getElement('p:spPr')
            ?.getElement('a:xfrm')
            ?.findElements('a:off')
            .firstOrNull;
        var ext = child
            .getElement('p:spPr')
            ?.getElement('a:xfrm')
            ?.findElements('a:ext')
            .firstOrNull;

        var xPos = off != null
            ? double.tryParse(off.getAttribute("x") ?? "0.0") ?? 0.0
            : 0.0;
        var yPos = off != null
            ? double.tryParse(off.getAttribute("y") ?? "0.0") ?? 0.0
            : 0.0;

        var cX = ext != null
            ? double.tryParse(ext.getAttribute("cx") ?? "0.0") ?? 0.0
            : 0.0;
        var cY = ext != null
            ? double.tryParse(ext.getAttribute("cy") ?? "0.0") ?? 0.0
            : 0.0;

        var lnElem = child.getElement('p:spPr')?.getElement('a:ln');

        String? lineColor;
        String? lineWidth;
        if (lnElem != null) {
          lineWidth = lnElem.getAttribute("w");
          lineColor = lnElem
              .getElement("a:solidFill")
              ?.getElement('a:schemeClr')
              ?.getAttribute('val');
        }

        var txBody = child.findElements('p:txBody').firstOrNull;
        if (txBody != null) {
          var rList = txBody.getElement('a:p')?.findElements('a:r');
          for (var r in rList!) {
            var t = r.getElement('a:t')?.firstChild;
            if (t != null) {
              var textContent = t.value;
              print("Text Box Content: $textContent");

              var font = t.parent?.parent?.findElements("a:rPr").firstOrNull;
              var fontElem = font?.getElement('a:latin');
              var fontFamily = fontElem?.getAttribute("typeface");
              var italics = font != null ? font.getAttribute("i") : "0";
              var bgHighlightElem =
                  font?.getElement('a:highlight')?.getElement('a:srgbClr');
              var highlight = bgHighlightElem?.getAttribute('val');
              var bold = font != null ? font.getAttribute("b") : "0";
              var fontSize = font != null
                  ? double.tryParse(font.getAttribute("sz") ?? "0.0") ?? 0.0
                  : 0.0;

              print(
                  "Position Data: offx, offy: ($xPos, $yPos), extx, exty: ($cX, $cY), Outline Color: $lineColor, Outline Width: $lineWidth");
              print(
                  "Font Family: $fontFamily, Font Size: $fontSize, Italics: $italics, BGHighlight: $highlight, Bolded: $bold\n");
            }
          }
        }
      }

      extractTextShapes(child);
    }
  }
}

void main() {
  var filename = "Luna_sample_module.pptx";

  var slideXML = extractXMLFromZip(filename, "ppt/slides/slide2.xml");
  if (slideXML == null) {
    print("Error: slide1.xml not found in the .pptx file.");
    return;
  }

  var doc = XmlDocument.parse(slideXML);
  var root = doc.rootElement;
  if (root.name.local == "sld") {
    extractTextShapes(root);
  }
}
