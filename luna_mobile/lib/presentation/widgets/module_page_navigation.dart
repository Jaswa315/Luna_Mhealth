// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

/// A widget that displays a navigation bar for navigating between pages.
class ModulePageNavigation extends StatelessWidget {
  /// Represents the current page number in the module page navigation.
  final int currentPage;

  /// Represents the total number of pages in the module page navigation.
  final int pageCount;

  /// Represents the first page number in the module page navigation.
  final int firstPage = 1;

  /// Represents the first page index in the module page navigation.
  final int firstPageIndex = 0;

  /// A callback function that is called when a page is changed.
  final void Function(int) onPageChange;

  /// Creates a [ModulePageNavigation] widget.
  ///
  /// The [currentPage] parameter represents the current page index.
  /// The [pageCount] parameter represents the total number of pages.
  /// The [onPageChange] parameter is a callback function that is called when a page is changed.
  ModulePageNavigation({
    Key? key,
    required this.currentPage,
    required this.pageCount,
    required this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: currentPage > firstPageIndex
                ? () => onPageChange(currentPage - 1)
                : null,
            child: Text('Prev'),
          ),
          TextButton(
            onPressed: currentPage != firstPageIndex
                ? () => onPageChange(firstPageIndex)
                : null,
            child: Text('Page 1'),
          ),
          TextButton(
            onPressed: currentPage < pageCount - 1
                ? () => onPageChange(currentPage + 1)
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
