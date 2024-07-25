// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart' as page_model;
import 'package:luna_core/renderers/irenderer.dart';
import 'package:luna_core/renderers/renderer_factory.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/utils/scale_utilities.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';

/// A class that provides services for managing module pages.
class ModulePageBuilderService {
  /// The maximum number of pages to cache.
  final int cacheSizeLimit = AppConstants.numberOfPagesCacheLimit;

  /// A map of cached pages for each module.
  final LinkedHashMap<int, Widget> cachedPages = LinkedHashMap();

  /// A utility class for scaling calculations.
  final ScaleUtilities scaleUtilities = ScaleUtilities();

  /// A map of cached pages for each module.
  //Map<int, Widget> cachedPages = {}; // FIXEME: remove this line

  /// Builds or retrieves a cached page for a given module and page index.
  ///
  /// The [module] parameter represents the module for which the page is being built or retrieved.
  /// The [pageIndex] parameter represents the index of the page within the module.
  /// The [screenSize] parameter represents the size of the screen.
  /// The [buildPage] parameter is a callback function that takes a page, screen size, and scale as input and returns a widget.
  ///
  /// Returns the built or retrieved cached page as a widget.
  Widget? buildOrRetrieveCachedPage(
    Module module,
    int pageIndex,
    Size screenSize,
    Widget Function(page_model.Page, Size) buildPage,
  ) {
    //double scale = scaleUtilities.calculateScale(screenSize, module.width);

    // ToDo: Fix We should be using a ModuleContext to get the current module and core properties
    ModuleResourceFactory.moduleName = module.name; 

    if (!cachedPages.containsKey(pageIndex)) {
      if (cachedPages.length >= cacheSizeLimit) {
        cachedPages.remove(cachedPages.keys.first);
      }
      cachedPages[pageIndex] = buildPage(module.pages[pageIndex], screenSize);
    } else {
      // Move the accessed page to the end of the map to implement LRU policy.
      cachedPages[pageIndex] = cachedPages.remove(pageIndex)!;
    }

    return cachedPages[pageIndex];
  }

  /// Builds a page using the given [page], and [screenSize].
  ///
  /// The [page] parameter represents the page model to be built.
  /// The [screenSize] parameter represents the size of the screen.
  ///
  /// Returns a [Widget] representing the built page.
  Widget buildPage(page_model.Page page, Size screenSize) {
    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: page.getPageComponents.map((component) {
            IRenderer renderer =
                RendererFactory.getRenderer(component.runtimeType);

            return Positioned(
              child: renderer.renderComponent(component),
            );
          }).toList(),
        ),
      ),
    );
  }
}
