// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/image/image_component.dart';
import '../../models/module.dart';
import '../../models/page.dart' as page_model;
import '../../models/text/text_component.dart';

/// A page that displays the content of a module.
class ModulePage extends StatefulWidget {
  /// The module to display.
  final Module module;

  /// Constructs a new [ModulePage] with the given [module].
  ModulePage({Key? key, required this.module}) : super(key: key);

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.module.pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) =>
                  buildSlide(widget.module.pages[index], screenSize),
            ),
          ),
          modulePageNavigation(),
        ],
      ),
    );
  }

  Widget buildSlide(page_model.Page page, Size screenSize) {
    double componentScale = screenSize.width / widget.module.width;
    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: page.components.map((component) {
            if (component is TextComponent) {
              return Positioned(
                left: component.bounds.left * componentScale,
                top: component.bounds.top * componentScale,
                width: component.bounds.width * componentScale,
                height: component.bounds.height * componentScale,
                child: component.render(),
              );
            } else if (component is ImageComponent) {
              return Positioned(
                left: component.bounds.left * componentScale,
                top: component.bounds.top * componentScale,
                width: component.bounds.width * componentScale,
                height: component.bounds.height * componentScale,
                child: component.render(),
              );
            } else {
              // Placeholder for other component types like ImageComponent
              // This can be expanded later to include actual rendering logic for images
              return Container();
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget modulePageNavigation() {
    // Navigation logic remains unchanged
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: _currentPage > 0
                ? () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                : null,
            child: Text('Pre'),
          ),
          TextButton(
            onPressed: () {
              _pageController.jumpToPage(0);
            },
            child: Text('Page 1'),
          ),
          TextButton(
            onPressed: _currentPage < widget.module.pages.length - 1
                ? () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
