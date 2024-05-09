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
  /// The [PageController] for the navigation.
  final PageController pageController;

  /// The current page index.
  int currentPage;

  /// Constructs a [NavigationController] with the given [pageController] and [currentPage].
  NavigationController({required this.pageController, this.currentPage = 0});

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
