// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

import '../../models/module.dart';
import '../../models/page.dart' as page_model;
import '../../renderers/component_factory.dart';
import '../../renderers/component_renderer.dart';
import '../../utils/scale_utilities.dart';

/// A class that provides services for managing module pages.
class ModulePageBuilderService {
  /// A utility class for scaling calculations.
  final ScaleUtilities scaleUtilities = ScaleUtilities();

  /// A map of cached pages for each module.
  Map<int, Widget> cachedPages = {};

  /// Builds or retrieves a cached page for a given module and page index.
  ///
  /// The [module] parameter represents the module for which the page is being built or retrieved.
  /// The [pageIndex] parameter represents the index of the page within the module.
  /// The [screenSize] parameter represents the size of the screen.
  /// The [buildSlide] parameter is a callback function that takes a page, screen size, and scale as input and returns a widget.
  ///
  /// Returns the built or retrieved cached page as a widget.
  Widget? buildOrRetrieveCachedPage(
      Module module,
      int pageIndex,
      Size screenSize,
      Widget Function(page_model.Page, Size, double) buildSlide) {
    double scale = scaleUtilities.calculateScale(screenSize, module.width);

    if (!cachedPages.containsKey(pageIndex)) {
      cachedPages[pageIndex] =
          buildSlide(module.pages[pageIndex], screenSize, scale);
    }
    return cachedPages[pageIndex];
  }

  /// Builds a page using the given [page], [screenSize], [scale], and [moduleTitle].
  ///
  /// The [page] parameter represents the page model to be built.
  /// The [screenSize] parameter represents the size of the screen.
  /// The [scale] parameter represents the scaling factor.
  /// The [moduleTitle] parameter represents the title of the module.
  ///
  /// Returns a [Widget] representing the built page.
  Widget buildPage(
      page_model.Page page, Size screenSize, double scale, String moduleTitle) {
    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: page.components.map((component) {
            ComponentRenderer renderer =
                ComponentFactory.getRenderer(component.runtimeType);
            return Positioned(
              left: component.bounds.left * scale,
              top: component.bounds.top * scale,
              width: component.bounds.width * scale,
              height: component.bounds.height * scale,
              child: renderer.renderComponent(component, scale, moduleTitle),
            );
          }).toList(),
        ),
      ),
    );
  }
}
