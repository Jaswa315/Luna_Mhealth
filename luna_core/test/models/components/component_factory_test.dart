import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/component_serializer.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/point.dart';
import '../../mocks/mock.mocks.dart';

void main() {
  group('ComponentSerializer', () {
    final sampleLineComponent = LineComponent(
      color: Color(0xFF123456),
      thickness: 1.5,
      style: BorderStyle.none,
      startPoint: Point(Percent(0.1), Percent(0.1)),
      endPoint: Point(Percent(0.9), Percent(0.9)),
    );

    test('should deserialize LineComponent from JSON', () {
      final json = {
        'componentType': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.5, 'y': 0.6},
        'color': 0xFF000000,
        'thickness': 2.0,
        'style': 0,
      };

      final component = ComponentSerializer.fromJson(json);
      expect(component, isA<LineComponent>());
    });

    test('should serialize LineComponent to JSON', () {
      final line = sampleLineComponent;

      final json = ComponentSerializer.serializeComponent(line);
      expect(json['componentType'], 'line');
      expect(json['thickness'], 1.5);
    });

    test('should throw on unknown componentType in fromJson', () {
      final json = {'componentType': 'unknown'};
      expect(() => ComponentSerializer.fromJson(json), throwsException);
    });

    test('should throw on unknown runtime type in serializeComponent', () {
      final mock = MockComponent();
      when(mock.toJson()).thenReturn({'mocked': true});
      expect(
          () => ComponentSerializer.serializeComponent(mock), throwsException);
    });

    test('should round-trip serialize and deserialize LineComponent', () {
      final original = sampleLineComponent;

      final json = ComponentSerializer.serializeComponent(original);
      final deserialized = ComponentSerializer.fromJson(json);

      expect(deserialized.runtimeType, original.runtimeType);
      final reJson = ComponentSerializer.serializeComponent(deserialized);
      expect(reJson, json);
    });
  });
}
