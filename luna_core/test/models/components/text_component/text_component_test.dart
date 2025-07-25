import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/bounding_box_component.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/emu.dart';

main () {
  test('TextComponent constructor initializes with correct properties', () {
    final boundingBox = BoundingBox(
        topLeftCorner: Offset(10.0, 20.0),
        width: DisplayPixel(300.0),
        height: EMU(50),
      );
    final textPart = TextPart(text: 'Sample Text');
    final textComponent = TextComponent(
      textChildren: [textPart],
      boundingBox: boundingBox,
    );

    expect(textComponent.textChildren.length, 1);
    expect(textComponent.textChildren[0].text, 'Sample Text');
    expect(textComponent.boundingBox.topLeftCorner.dx, 10.0);
    expect(textComponent.boundingBox.topLeftCorner.dy, 20.0);
    expect(textComponent.boundingBox.width.toString(), DisplayPixel(300.0).toString());
    expect(textComponent.boundingBox.height.toString(), EMU(50).toString());
  });

  test('TextComponent fromJson initializes properties correctly', () {
    final json = {
      'textParts': [
        {
          'text': 'Test Text',
          'fontSize': 18.0,
          'fontStyle': '',
          'fontWeight': '',
          'fontUnderline': '',
          'color': null,
        }
      ],
      'boundingBox': {
        'topLeftCorner': {
          'dx': 5.0, 
          'dy': 10.0
        },
        'width': {
          'unit': 'displayPixels',
          'value': 200.0
        },
        'height': {
          'unit': 'emu',
          'value': 75
        },
      },
    };

    final textComponent = TextComponent.fromJson(json);
    expect(textComponent.textChildren.length, 1);
    expect(textComponent.textChildren[0].text, 'Test Text');
    expect(textComponent.boundingBox.topLeftCorner.dx, 5.0);
    expect(textComponent.boundingBox.topLeftCorner.dy, 10.0);
    expect(textComponent.boundingBox.width.toString(), DisplayPixel(200.0).toString());
    expect(textComponent.boundingBox.height.toString(), EMU(75).toString());
  });

  test('TextComponent toJson returns a JSON representation of the object', () {
    final boundingBox = BoundingBox(
      topLeftCorner: Offset(15.0, 25.0),
      width: DisplayPixel(400.0),
      height: EMU(100),
    );
    final textPart = TextPart(text: 'Example Text', fontSize: 20.0);
    final textComponent = TextComponent(
      textChildren: [textPart],
      boundingBox: boundingBox,
    );

    final json = textComponent.toJson();
    expect(json['textParts'][0]['text'], 'Example Text');
    expect(json['textParts'][0]['fontSize'], 20.0);
    expect(json['boundingBox']['topLeftCorner']['dx'], 15.0);
    expect(json['boundingBox']['topLeftCorner']['dy'], 25.0);
    expect(json['boundingBox']['width']['unit'], 'displayPixels');
    expect(json['boundingBox']['width']['value'], 400.0);
    expect(json['boundingBox']['height']['unit'], 'emu');
    expect(json['boundingBox']['height']['value'], 100);
  });
}