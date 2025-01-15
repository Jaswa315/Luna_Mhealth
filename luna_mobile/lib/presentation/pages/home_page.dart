// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_mobile/core/constants/constants.dart';
import 'package:luna_mobile/core/services/page_builder_service.dart';
import 'package:luna_mobile/core/services/page_persistence_service.dart';
import 'package:luna_mobile/presentation/pages/module_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';
import 'package:luna_mobile/presentation/pages/need_help_page.dart';
import 'package:luna_mobile/presentation/pages/settings_page.dart';

/// The home page of the application.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Center(
        child: Consumer<ModuleUIPicker>(
          builder: (context, moduleProvider, child) {
            return moduleProvider.areModulesLoaded
                ? ListView.builder(
                    itemCount: moduleProvider.moduleList.length,
                    itemBuilder: _buildModuleListItem,
                  )
                : FutureBuilder(
                    future: moduleProvider.loadAvailableModules(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: \${snapshot.error}');
                      } else {
                        return const Text('No modules available');
                      }
                    },
                  );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures equal spacing
        selectedItemColor: Colors.black, // Selected item color
        unselectedItemColor: Colors.black, //Unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Add Module',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.question_circle),
            label: 'Need Help', // New Button
          ),
        ],
        onTap: (index) {
          _onBottomNavigationItemTapped(context, index);
        },
      ),
    );
  }
}

void _onBottomNavigationItemTapped(BuildContext context, int index) {
  switch (index) {
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
      break;
    case 2:
      Provider.of<ModuleUIPicker>(context, listen: false)
          .selectAndStoreModuleFile();
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NeedHelpPage(),
        ),
      );
      break;
  }
}

Widget _buildModuleListItem(BuildContext context, int index) {
  final module =
      Provider.of<ModuleUIPicker>(context, listen: false).moduleList[index];
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
