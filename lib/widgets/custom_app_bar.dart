import 'package:flutter/material.dart';

import '../services/language_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showDrawer;
  final bool showSettings;
  final bool showSoundToggle;
  final Function? onSoundToggle;
  final bool isSoundOn;
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.showDrawer = false,
    this.showSettings = false,
    this.showSoundToggle = false,
    this.onSoundToggle,
    this.isSoundOn = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Start with an empty list of action widgets
    List<Widget> actionWidgets = [];

    // Add settings button if required
    if (showSettings) {
      actionWidgets.add(
        IconButton(
          icon: Icon(Icons.language),
          onPressed: () => _showLanguageSelectionDialog(context),
        ),
      );
    }

    // Add sound toggle button if required
    if (showSoundToggle) {
      actionWidgets.add(
        IconButton(
          icon: Icon(isSoundOn ? Icons.volume_up : Icons.volume_off),
          onPressed: () => onSoundToggle?.call(),
        ),
      );
    }

    // Add any additional action widgets passed to the AppBar
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return AppBar(
      title: Text(title),
      leading: _buildLeadingIcon(context),
      actions: actionWidgets,
    );
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      );
    } else if (showDrawer) {
      return Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
    }
    return null;
  }

  Future<void> _showLanguageSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    LanguageService.updateLanguage('en');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Spanish'),
                  onTap: () {
                    LanguageService.updateLanguage('es');
                    Navigator.of(context).pop();
                  },
                ),
                // Add more language options here
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
