// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../../providers/click_state_provider.dart';
import 'module_page.dart';

/// The home page of the application.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ClickStateProvider>(context, listen: false)
                  .loadModules();
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<ClickStateProvider>(
          builder: (context, clickStateProvider, child) {
            if (clickStateProvider.modulesLoaded) {
              return ListView.builder(
                itemCount: clickStateProvider.loadedModules.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(clickStateProvider.loadedModules[index].title),
                    onTap: () => _navigateToModulePage(
                        context, clickStateProvider.loadedModules[index]),
                  );
                },
              );
            } else {
              return const Text(AppConstants.noModuleErrorMessage);
            }
          },
        ),
      ),
    );
  }
}

void _navigateToModulePage(BuildContext context, Module module) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModulePage(module: module),
    ),
  );
}
