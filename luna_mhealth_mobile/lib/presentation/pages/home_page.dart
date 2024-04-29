// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/services/page_builder_service.dart';
import '../../core/services/page_persistence_service.dart';
import '../../models/module.dart';
import '../../providers/module_provider.dart';
import 'module_page.dart';

/// The home page of the application.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print("HomePage initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("HomePage didChangeDependencies");
  }

  @override
  void dispose() {
    print("HomePage dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("HomePage build method called");
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            onPressed: () => Provider.of<ModuleProvider>(context, listen: false)
                .selectAndStoreModuleFile(),
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: Center(
        child: Consumer<ModuleProvider>(
          builder: (context, moduleProvider, child) {
            if (moduleProvider.areModulesLoaded) {
              return ListView.builder(
                itemCount: moduleProvider.moduleList.length,
                itemBuilder: _buildModuleListItem,
              );
            } else {
              return FutureBuilder(
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
            }
          },
        ),
      ),
    );
  }
}

Widget _buildModuleListItem(BuildContext context, int index) {
  final module =
      Provider.of<ModuleProvider>(context, listen: false).moduleList[index];
  return ListTile(
    title: Text(module.title),
    onTap: () => _navigateToModulePage(context, module),
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
