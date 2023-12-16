import 'package:flutter/material.dart';

import 'package:luna_mhealth_mobile/views/about_page.dart';
import 'package:luna_mhealth_mobile/views/help_support_page.dart';
import 'package:luna_mhealth_mobile/views/library_page.dart';
import 'package:luna_mhealth_mobile/views/profile_page.dart';
import 'package:luna_mhealth_mobile/views/settings_page.dart';

// Import other necessary pages or utilities

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.of(context).pop(), // Close drawer
          ),
          _createDrawerItem(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () => _navigateToPage(context, ProfilePage()),
          ),
          _createDrawerItem(
            icon: Icons.library_books,
            text: 'Library',
            onTap: () => _navigateToPage(context, LibraryPage()),
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => _navigateToPage(context, SettingsPage()),
          ),
          _createDrawerItem(
            icon: Icons.info,
            text: 'About',
            onTap: () => _navigateToPage(context, AboutPage()),
          ),
          _createDrawerItem(
              icon: Icons.help,
              text: 'Help & Support',
              onTap: () => _navigateToPage(context, HelpSupportPage())),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout/Sign in',
            onTap: () {
              // Handle Logout/Sign in action
            },
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).pop(); // Close the drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
