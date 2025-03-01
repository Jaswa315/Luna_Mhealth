


import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';


class AuthoringHomeScreen extends StatefulWidget {
  @override
  _AuthoringHomeScreenState createState() => _AuthoringHomeScreenState();
}

class _AuthoringHomeScreenState extends State<AuthoringHomeScreen> {
  String? filePath;
  String? moduleName;
  bool filePicked = false;
  bool textEntered = false;

  final TextEditingController _controller = TextEditingController();

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.single.name;
        filePicked = true;
      });
    }
  }

  void submitText() async{
    setState(() {
      textEntered = true;
      moduleName = _controller.text;
    });
    await PptxRunner().processPptx(pptxFile,moduleName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Luna Authoring System")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              if (!filePicked) 
                ElevatedButton(
                  onPressed: pickFile, 
                  child: Text("Pick a PPTX File"),
                ),

              if (filePicked && !textEntered) ...[
                Text("File Selected: $filePath"),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "Enter Module Name"),
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: submitText,
                  child: Text("Submit"),
                ),

              ],
              if (textEntered) Text("!", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}