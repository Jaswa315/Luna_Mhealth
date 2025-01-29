import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _audioLanguage = "English";
  String _textLanguage = "English";

  void _updateAudioLanguage(String language) {
    setState(() {
      _audioLanguage = language;
    });
  }

  void _updateTextLanguage(String language) {
    setState(() {
      _textLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLanguageOption(
              title: "Audio",
              currentLanguage: _audioLanguage,
              icon: Icons.volume_up,
              onLanguageSelected: _updateAudioLanguage,
            ),
            SizedBox(height: 20),
            _buildLanguageOption(
              title: "Text",
              currentLanguage: _textLanguage,
              icon: Icons.text_fields,
              onLanguageSelected: _updateTextLanguage,
            ),
            SizedBox(height: 20),
            _buildAboutLuna(
              version: "0.0.0",
              icon: Icons.help,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String currentLanguage,
    required IconData icon,
    required Function(String) onLanguageSelected,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text("Current: $currentLanguage"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => _showLanguagePickerDialog(onLanguageSelected),
      ),
    );
  }

  void _showLanguagePickerDialog(Function(String) onLanguageSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("English"),
                onTap: () {
                  onLanguageSelected("English");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Español"),
                onTap: () {
                  onLanguageSelected("Español");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


// builds an AboutDialog (in built flutter widget) using showAboutDialog.
  Widget _buildAboutLuna({
    required String version,
    required IconData icon,
  }){
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text("About Luna"),
        onTap: () => showAboutDialog(
          context: context,
          applicationName: "Luna",
          applicationVersion: "Version: $version",
        ),
      ),
    );

  }

}