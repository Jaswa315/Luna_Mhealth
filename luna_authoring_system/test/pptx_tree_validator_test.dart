import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/data_tree_validator.dart';

void main() {
  group('Data Tree Validator Test', () {
    test('Given module and component bottom right coordinates, validate out of bounds component as false', () {
      double modulePageWidth = 500.0;
      double modulePageHeight = 500.0;
      double componentRightX = 480.0 + 100.0;
      double componentBottomY = 480.0 + 100.0;

      bool isValid = DataTreeValidator.isComponentInBounds(
          modulePageWidth, modulePageHeight, componentRightX, componentBottomY);

      expect(isValid, false);
    });
  });
}
