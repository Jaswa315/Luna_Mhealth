import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:flutter/material.dart';

void main() {
  test('TextPart constructor initializes with correct default properties', () {
    final textPart = TextPart(text: 'Hello World');
    expect(textPart.text, 'Hello World');
    expect(textPart.fontSize, 16.0);
    expect(textPart.fontStyle, FontStyle.normal);
    expect(textPart.fontWeight, FontWeight.normal);
    expect(textPart.fontUnderline, TextDecoration.none);
    expect(textPart.textID, isNull);
    expect(textPart.color, isNull);
  });

  test('TextPart getTextSpan returns a TextSpan with correct properties', () {
    final textPart = TextPart(
      text: 'Hello World',
      fontSize: 20.0,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontUnderline: TextDecoration.underline,
      color: const Color(0xFF0000FF), // Blue color
    );

    final textSpan = textPart.getTextSpan();
    expect(textSpan.text, 'Hello World');
    expect(textSpan.style?.fontSize, 20.0);
    expect(textSpan.style?.fontStyle, FontStyle.italic);
    expect(textSpan.style?.fontWeight, FontWeight.bold);
    expect(textSpan.style?.decoration, TextDecoration.underline);
    expect(textSpan.style?.color, const Color(0xFF0000FF));
  });

  test('TextPart fromJson initializes properties correctly', () {
    final json = {
      'text': 'Sample Text',
      'textID': 1,
      'fontSize': 20.0,
      'fontStyle': 'italic',
      'fontWeight': 'bold',
      'fontUnderline': 'underline',
      'color': 0xFF0000FF, // Blue color
    };

    final textPart = TextPart.fromJson(json);
    expect(textPart.text, 'Sample Text');
    expect(textPart.textID, 1);
    expect(textPart.fontSize, 20.0);
    expect(textPart.fontStyle, FontStyle.italic);
    expect(textPart.fontWeight, FontWeight.bold);
    expect(textPart.fontUnderline, TextDecoration.underline);
    expect(textPart.color, const Color(0xFF0000FF));
  });

  test('TextPart toJson returns a JSON representation of the object', () {
    final textPart = TextPart(
      text: 'Test Text',
      fontSize: 18.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontUnderline: TextDecoration.none,
      textID: 42,
      color: const Color(0xFFFF0000), // Red color
    );

    final json = textPart.toJson();
    expect(json['text'], 'Test Text');
    expect(json['fontSize'], 18.0);
    expect(json['fontStyle'], '');
    expect(json['fontWeight'], '');
    expect(json['fontUnderline'], '');
    expect(json['textID'], 42);
    expect(json['color'], 0xFFFF0000);
  });
}