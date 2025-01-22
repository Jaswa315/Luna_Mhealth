import 'package:flutter/material.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_mobile/core/services/page_builder_service.dart';
import 'package:luna_mobile/core/services/page_persistence_service.dart';
import 'package:luna_mobile/presentation/pages/module_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

/// The Start Learning Page of the application.
class StartLearningPage extends StatefulWidget {
  @override
  _StartLearningPageState createState() => _StartLearningPageState();
}

class _StartLearningPageState extends State<StartLearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Learning',
          style: TextStyle(
            fontFamily: 'Bookerly',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<ModuleUIPicker>(
          builder: (context, moduleProvider, child) {
            return moduleProvider.areModulesLoaded
                ? ListView.separated(
                    itemCount: moduleProvider.moduleList.length,
                    itemBuilder: (context, index) =>
                        _buildModuleListItem(context, index),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  )
                : FutureBuilder(
                    future: moduleProvider.loadAvailableModules(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('No modules available');
                      }
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _buildModuleListItem(BuildContext context, int index) {
    final moduleProvider = Provider.of<ModuleUIPicker>(context, listen: false);
    final module = moduleProvider.moduleList[index];

    final moduleTitle =
        (module.title.trim() == '') ? 'module_${index + 1}' : module.title;

    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          moduleTitle,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _navigateToModulePage(context, module),
      ),
    );
  }

  void _navigateToModulePage(BuildContext context, Module module) {
    ModulePageBuilderService pageServices = ModulePageBuilderService();
    PagePersistenceService persistenceService = PagePersistenceService();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulePage(
          module: module,
          pageServices: pageServices,
          persistenceService: persistenceService,
        ),
      ),
    );
  }
}
