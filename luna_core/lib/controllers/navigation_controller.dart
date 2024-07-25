// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';

/// Controller for managing navigation between pages.
class NavigationController {
  static final NavigationController _instance =
      NavigationController._internal();

  /// The [PageController] for the navigation.
  final PageController pageController;

  /// The current page index.
  int currentPage;

  /// Constructs a [NavigationController] with the given and optional [currentPage].
  factory NavigationController({int? currentPage}) {
    if (currentPage != null) {
      _instance.currentPage = currentPage;
      _instance.pageController.jumpToPage(currentPage);
    }
    return _instance;
  }

  NavigationController._internal()
      : pageController = PageController(),
        currentPage = 0;

  /// Jumps to the specified [page].
  void jumpToPage(int page) {
    pageController.jumpToPage(page);
    currentPage = page;
  }

  /// Animates to the specified [page].
  void animateToPage(int page) {
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    currentPage = page;
  }
}
