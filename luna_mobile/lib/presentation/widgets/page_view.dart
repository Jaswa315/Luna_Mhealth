import 'package:flutter/material.dart';
import 'package:luna_core/models/pages/page.dart' as page_model;
import 'package:luna_mobile/renderers/irenderer.dart';
import 'package:luna_mobile/renderers/renderer_factory.dart';
import 'package:luna_mobile/states/module_state.dart';

/// A widget that displays the current page of a module.
///
/// This widget is part of the module rendering system and is driven by the
/// [ModuleState], which manages the state and navigation of pages within a module.
/// It renders all components of the current page using their respective renderers.
class PageView extends StatelessWidget {
  final ModuleState moduleState;

  const PageView({
    required this.moduleState,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final page_model.Page currentPage = moduleState.getCurrentPage();

    // Render a scrollable container that stacks all components of the current page.
    // For each component, resolve its renderer via RendererFactory and render it
    // with the screen size.
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
