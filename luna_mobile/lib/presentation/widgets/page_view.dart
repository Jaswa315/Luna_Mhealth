import 'package:flutter/material.dart';
import 'package:luna_core/models/pages/page.dart' as page_model;
import 'package:luna_mobile/renderers/irenderer.dart';
import 'package:luna_mobile/renderers/renderer_factory.dart';
import 'package:luna_mobile/states/module_state.dart';

class PageView extends StatelessWidget {
  final ModuleState moduleState;

  const PageView({
    required this.moduleState,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final page_model.Page currentPage = moduleState.getCurrentPage();

    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: currentPage.getPageComponents.map((component) {
            IRenderer renderer =
                RendererFactory.getRenderer(component.runtimeType);

            return renderer.renderComponent(component, screenSize);
          }).toList(),
        ),
      ),
    );
  }
}
