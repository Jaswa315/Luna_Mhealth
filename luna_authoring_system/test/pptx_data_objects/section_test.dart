import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';

void main() {
  group('section Class Tests', () {
    test('Section object stores valid value.', () {
      Section section = Section({
        'Symptom1': [1, 2, 3],
        'Symptom2': [4],
        'Symptom3': [],
      });

      expect(section.value['Symptom1'], [1, 2, 3]);
      expect(section.value['Symptom2'], [4]);
      expect(section.value['Symptom3'], []);
    });

    test('Invalid Section values should throw an ArgumentError.', () {
      expect(
          () => Section({
                'Symptom1': [-1]
              }),
          throwsArgumentError);
      expect(
          () => Section({
                'Symptom1': [1, 2, -2]
              }),
          throwsArgumentError);
    });
  });
}
