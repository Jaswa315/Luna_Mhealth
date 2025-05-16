import 'package:flutter/material.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_mobile/controllers/navigation_buttons.dart';
import 'package:luna_mobile/controllers/page_navigation_controller.dart';
import 'package:luna_mobile/presentation/widgets/page_view.dart'
    as custom_page_view;
import 'package:luna_mobile/states/module_state.dart';

class ModulePage extends StatefulWidget {
  final Module module;

  const ModulePage({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late ModuleState moduleState;
  late PageNavigationController navigationController;

  @override
  void initState() {
    super.initState();
    final entryPage = widget.module.getEntryPage();
    moduleState = ModuleState(currentPage: entryPage);
    navigationController = PageNavigationController(moduleState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          custom_page_view.PageView(moduleState: moduleState),
          NavigationButtons(
            controller: navigationController,
            onPageChanged: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}
