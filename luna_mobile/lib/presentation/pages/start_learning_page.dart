import 'package:flutter/material.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_mobile/core/services/page_builder_service.dart';
import 'package:luna_mobile/core/services/page_persistence_service.dart';
import 'package:luna_mobile/presentation/pages/module_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

/// This is the Start Learning page of the application.
/// It displays a list of all available modules that the user can explore.
/// Users navigate to this page from the Home page by clicking the "Start Learning" button.
/// When a module is clicked, the user is navigated to the corresponding module page.

class StartLearningPage extends StatefulWidget {
  @override
  _StartLearningPageState createState() => _StartLearningPageState();
}

class _StartLearningPageState extends State<StartLearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar provides the title for the Start Learning page with custom styling.
      appBar: AppBar(
        title: const Text(
          'Start Learning',
          style: TextStyle(
            fontFamily: 'Bookerly', // Custom Kindle-style font.
            fontSize: 26, // Larger font size for readability.
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black text for better contrast.
          ),
        ),
        backgroundColor: Colors.white, // White background for AppBar.
      ),
      backgroundColor: Colors.white, // Matches the overall theme.

      /// The main body contains a list of modules or a loader based on the data state.
      body: Center(
        child: Consumer<ModuleUIPicker>(
          /// Listens to changes in the `ModuleUIPicker` provider to load or display modules.
          builder: (context, moduleProvider, child) {
            return moduleProvider.areModulesLoaded
                ? ListView.separated(
                    /// Displays the list of available modules if they are loaded.
                    itemCount: moduleProvider.moduleList.length,
                    itemBuilder: (context, index) =>
                        _buildModuleListItem(context, index),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10, // Space between module list items.
                    ),
                  )
                : FutureBuilder(
                    /// If modules are not yet loaded, fetch them asynchronously.
                    future: moduleProvider.loadAvailableModules(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        /// Show a loading indicator while modules are being fetched.
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        /// Display an error message if fetching modules fails.
                        return Text('Error: ${snapshot.error}');
                      } else {
                        /// Show a message if no modules are available.
                        return const Text('No modules available');
                      }
                    },
                  );
          },
        ),
      ),
    );
  }

  /// Builds a single module list item.
  /// Each item includes the module title and an arrow icon for navigation.
  Widget _buildModuleListItem(BuildContext context, int index) {
    final moduleProvider = Provider.of<ModuleUIPicker>(context, listen: false);
    final module = moduleProvider.moduleList[index];

    /// Use the module's title, or a default name if the title is empty.
    final moduleTitle =
        (module.title.trim() == '') ? 'module_${index + 1}' : module.title;

    return Container(
      color: Colors.white, // Ensures a consistent background for the list item.
      child: ListTile(
        title: Text(
          moduleTitle, // Displays the module title.
          style: const TextStyle(fontSize: 16), // Custom text styling.
        ),
        trailing: const Icon(Icons.arrow_forward_ios), // Navigation arrow icon.
        onTap: () => _navigateToModulePage(context, module),

        /// Navigates to the corresponding module page when tapped.
      ),
    );
  }

  /// Navigates to the ModulePage when a module is selected.
  void _navigateToModulePage(BuildContext context, Module module) {
    /// Initialize services required by the ModulePage.
    ModulePageBuilderService pageServices = ModulePageBuilderService();
    PagePersistenceService persistenceService = PagePersistenceService();

    /// Navigate to the ModulePage, passing the selected module and services.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulePage(
          module: module, // The selected module.
          pageServices: pageServices, // Service for building module pages.
          persistenceService: persistenceService, // Service for saving state.
        ),
      ),
    );
  }
}
