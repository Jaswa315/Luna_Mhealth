// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/controllers/navigation_controller.dart';
import '../../core/services/page_builder_service.dart';
import '../../core/services/page_persistence_service.dart';
import '../../models/module.dart';
import '../../models/page.dart' as page_model;
import '../widgets/module_page_navigation.dart';

/// A page that displays the content of a module.
class ModulePage extends StatefulWidget {
  /// The module to display.
  final Module module;

  /// The services for managing module pages.
  final ModulePageBuilderService pageServices;

  /// The service for persisting module data.
  final PagePersistenceService persistenceService;

  /// Creates a [ModulePage] widget.
  ModulePage({
    Key? key,
    required this.module,
    required this.pageServices,
    required this.persistenceService,
  }) : super(key: key);

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late NavigationController _navigationController;
  late List<Widget> _cachedPagesWidgets;

  @override
  void initState() {
    print("ModulePage initState");
    super.initState();
    _navigationController =
        NavigationController(pageController: PageController());
    _loadLastVisitedPage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("ModulePage didChangeDependencies");
    _setupPageWidgets();
  }

  @override
  void dispose() {
    _saveLastVisitedPage();
    _navigationController.pageController.dispose();
    super.dispose();
    print("ModulePage dispose");
  }

  @override
  Widget build(BuildContext context) {
    print("ModulePage build method called");

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.module.title),
          leading: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context))),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _navigationController.pageController,
                itemCount: widget.module.pages.length,
                onPageChanged: (index) {
                  setState(() => _navigationController.currentPage = index);
                  _saveLastVisitedPage();
                },
                itemBuilder: (context, index) => _cachedPagesWidgets[index]),
          ),
          ModulePageNavigation(
            currentPage: _navigationController.currentPage,
            pageCount: widget.module.pages.length,
            onPageChange: (index) => _navigationController.animateToPage(index),
          ),
        ],
      ),
    );
  }

  Future<void> _loadLastVisitedPage() async {
    int lastPage = await widget.persistenceService
        .loadLastVisitedPage(widget.module.title);
    setState(() => _navigationController.currentPage = lastPage);
    _navigationController.jumpToPage(lastPage);
  }

  Future<void> _saveLastVisitedPage() async {
    await widget.persistenceService.saveLastVisitedPage(
        widget.module.title, _navigationController.currentPage);
  }

  void _setupPageWidgets() {
    print("ModulePage _setupPageWidgets called");
    final screenSize = MediaQuery.of(context).size;
    _cachedPagesWidgets = widget.module.pages
        .asMap()
        .map((index, page) =>
            MapEntry(index, _getCachedOrBuildSlide(page, screenSize, index)))
        .values
        .toList();
  }

  /// Builds or retrieves a cached slide for the given [page].
  Widget _getCachedOrBuildSlide(
      page_model.Page page, Size screenSize, int pageIndex) {
    return widget.pageServices.buildOrRetrieveCachedPage(
          widget.module,
          pageIndex,
          screenSize,
          (page, size, scale) => widget.pageServices
              .buildPage(page, size, scale, widget.module.title),
        ) ??
        SizedBox();
  }
}
