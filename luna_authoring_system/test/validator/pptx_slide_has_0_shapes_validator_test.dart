import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_slide_has_no_shapes_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_authoring_system/validator/issue/pptx_slide_has_no_shapes.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PptxSlideHasNoShapesValidator', () {
    test('Expect 1 issue in issueList when Slide has 0 shapes', () {
      final pptxTree = PptxTree();
      pptxTree.title = "";
      final slide = Slide();
      slide.shapes = [];
      pptxTree.slides = [slide];

      IValidator validator = PptxSlideHasNoShapesValidator(pptxTree);
      final Set<IValidationIssue> issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<PptxSlideHasNoShapes>());
    });

    test('Expect 0 issues when PptxTree has no slides', () {
      final pptxTree = PptxTree();
      pptxTree.title = "";
      pptxTree.slides = [];

      IValidator validator = PptxSlideHasNoShapesValidator(pptxTree);
      final Set<IValidationIssue> issues = validator.validate();

      expect(issues.length, 0);
    });

    test('Expect 1 issue when Slide 1 has shapes, but Slide 2 has no shapes',
        () {
      final mockPptxTree = MockPptxTree();
      final mockSlide1 = MockSlide();
      final mockSlide2 = MockSlide();
      final mockShape = MockShape();

      when(mockSlide1.shapes).thenReturn([mockShape]);
      when(mockSlide2.shapes).thenReturn([]);
      when(mockPptxTree.slides).thenReturn([mockSlide1, mockSlide2]);

      final validator = PptxSlideHasNoShapesValidator(mockPptxTree);
      final Set<IValidationIssue> issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<PptxSlideHasNoShapes>());
    });

    test('Expect 0 issues when Slide has 1 shape', () {
      final mockPptxTree = MockPptxTree();
      final mockSlide = MockSlide();
      final mockShape = MockShape();

      // Stub the shapes list to contain 1 mockShape
      when(mockSlide.shapes).thenReturn([mockShape]);

      // Stub the slides list on pptxTree
      when(mockPptxTree.slides).thenReturn([mockSlide]);

      // Run validator
      IValidator validator = PptxSlideHasNoShapesValidator(mockPptxTree);
      final Set<IValidationIssue> issues = validator.validate();

      expect(issues.length, 0);
    });
    test(
        'Expect LateInitializationError when slides in PptxTree is not initialized',
        () {
      final pptxTree = PptxTree();
      IValidator validator = PptxSlideHasNoShapesValidator(pptxTree);

      expect(
        () => validator.validate(),
        throwsA(predicate((e) =>
            e.runtimeType.toString().contains('LateError') &&
            e.toString().contains("Field 'slides' has not been initialized."))),
      );
    });
  });
}
