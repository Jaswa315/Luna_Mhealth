// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';

/// Home page for the Authoring System
/// Goes through each input for the system
/// Once all inputs are selected, converts the specified input file to a .luna
class AuthoringHomeScreen extends StatefulWidget {
  @override
  _AuthoringHomeScreenState createState() => _AuthoringHomeScreenState();
}

class _AuthoringHomeScreenState extends State<AuthoringHomeScreen> {
  String? filePath;
  bool filePicked = false;
  bool textEntered = false;

  final TextEditingController _controller = TextEditingController();

  Future _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
        filePicked = true;
      });
    }
  }

  Future _submitText() async{
    await PptxRunner().processPptx(filePath!,_controller.text);
    setState(() {
      textEntered = true;
    });
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
                  onPressed: () => _pickFile(), 
                  child: Text("Pick a PPTX File"),
                ),

              if (filePicked && !textEntered) ...[ // spread operator
                Text("File Selected: $filePath"),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "Enter Module Name"),
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _submitText(),
                  child: Text("Submit"),
                ),

              ],
              if (textEntered) Text("Job done!", style: TextStyle(fontSize: 20)), // text has been entered so luna file should be generated
            ],
          ),
        ),
      ),
    );
  }
}