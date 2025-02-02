import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/relationship.dart';

void main() {
  group('Tests for Relationship', () {
    test('Test Relationship Constructor', () async {
      
      Relationship rel = Relationship("rId1","slide","slide1");
      expect(rel.rID, "rId1");
      expect(rel.type, "slide");
      expect(rel.target, "slide1");

    });
  });
}
