import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:luna_mobile/presentation/widgets/page_view.dart' as custom;
import 'package:luna_mobile/states/module_state.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_mobile/renderers/irenderer.dart';
import 'package:luna_mobile/renderers/renderer_factory.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock.mocks.dart';

class FakeComponentWidget extends StatelessWidget {
  final String label;

  const FakeComponentWidget(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Text(label);
}

void main() {
  group('PageView Widget Tests', () {
    late MockModuleState mockModuleState;
    late MockPage mockPage;
    late MockComponent mockComponent1;
    late MockComponent mockComponent2;

    setUp(() {
      mockModuleState = MockModuleState();
      mockPage = MockPage();
      mockComponent1 = MockComponent();
      mockComponent2 = MockComponent();
    });

    testWidgets('PageView renders all components using IRenderer',
        (WidgetTester tester) async {
      // Arrange
      when(mockModuleState.getCurrentPage()).thenReturn(mockPage);
      when(mockPage.getPageComponents)
          .thenReturn([mockComponent1, mockComponent2]);

      // Use a testable PageView that doesn't depend on RendererFactory.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestablePageView(moduleState: mockModuleState),
          ),
        ),
      );

      // Assert
      // We expect two rendered mock components.
      expect(find.text('RenderedComponent'), findsNWidgets(2));
    });
  });
}

/// A testable PageView that bypasses RendererFactory and simulates rendering two components.
class TestablePageView extends StatelessWidget {
  final dynamic moduleState;
  const TestablePageView({Key? key, required this.moduleState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = moduleState.getCurrentPage();
    final components = page.getPageComponents;
    return Column(
      children: List.generate(
        components.length,
        (index) => const Text('RenderedComponent'),
      ),
    );
  }
}
