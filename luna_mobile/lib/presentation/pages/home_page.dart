// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luna_mobile/core/constants/constants.dart';
import 'package:luna_mobile/presentation/pages/need_help_page.dart';
import 'package:luna_mobile/presentation/pages/settings_page.dart';
import 'package:luna_mobile/presentation/pages/start_learning_page.dart';
import 'package:luna_mobile/providers/module_ui_picker.dart';
import 'package:provider/provider.dart';

/// The HomePage widget is the main entry point of the application.
/// It displays navigation options to other important screens, such as:
/// - Start Learning Page
/// - Need Help Page
/// - Settings Page
/// The page also includes a bottom navigation bar for quick access.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize any necessary state or resources.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Perform actions dependent on inherited widgets or context.
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up resources when the widget is removed from the tree.
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Screen width
    final screenHeight = MediaQuery.of(context).size.height; // Screen height

    return Scaffold(
      appBar: AppBar(
        /// AppBar provides the application title and branding.
        /// Custom styling ensures the title aligns with the app's theme.
        title: const Text(
          AppConstants.appName, // Title defined in constants file.
          style: TextStyle(
            fontFamily: 'Bookerly', // Custom Kindle-style font.
            fontSize: 26, // Larger font size for readability.
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white, // AppBar background color.
        elevation: 1, // Adds subtle shadow for better separation.
      ),
      backgroundColor:
          Colors.grey[200], // Background color for the entire page.
      body: Container(
        color: Colors.grey[200], // Matches the overall background theme.
        child: SingleChildScrollView(
          /// Ensures the content is scrollable if it exceeds the screen height.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Adds space below the AppBar.
                Center(
                  /// "Start Learning" button that navigates to the Start Learning page.
                  child: GestureDetector(
                    onTap: () {
                      /// Navigates to the StartLearningPage when the button is tapped.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartLearningPage(),
                        ),
                      );
                    },
                    child: Container(
                      /// Container for the button with a card-like design.
                      width: screenWidth * 0.8, // 80% of the screen width.
                      height: screenHeight * 0.32, // 32% of the screen height.
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for the card.
                        borderRadius:
                            BorderRadius.circular(16.0), // Rounded corners.
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Light shadow.
                            blurRadius: 12.0, // Shadow blur radius.
                            offset: const Offset(0, 6), // Shadow offset.
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          /// Displays a placeholder image for the "Start Learning" button.
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                16.0), // Rounds image corners.
                            child: Image.asset(
                              'assets/images/start_learning.jpg', // Placeholder image path.
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.32 * 0.8,
                              fit: BoxFit
                                  .cover, // Ensures the image fits properly.
                            ),
                          ),
                          const SizedBox(
                              height: 8), // Space between image and text.
                          const Text(
                            'Start Learning',

                            /// Text label for the button with custom styling.
                            style: TextStyle(
                              fontFamily: 'Bookerly',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        /// Provides navigation options at the bottom of the screen.
        type: BottomNavigationBarType.fixed, // Fixed layout for items.
        backgroundColor: Colors.white, // White navigation bar background.
        selectedItemColor:
            const Color(0xFF0078D4), // Kindle Blue for the selected icon.
        unselectedItemColor:
            const Color(0xFF808080), // Gray for unselected icons.
        items: const [
          /// Defines each item in the bottom navigation bar.
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Home.
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon for Settings.
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled), // Icon for Add Module.
            label: 'Add Module',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.question_circle), // Icon for Need Help.
            label: 'Need Help',
          ),
        ],
        onTap: (index) {
          /// Handles navigation based on the selected item index.
          _onBottomNavigationItemTapped(context, index);
        },
      ),
    );
  }
}

/// Handles the navigation when a bottom navigation item is tapped.
void _onBottomNavigationItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0: // Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false, // Clears the navigation stack.
      );
      break;
    case 1: // Settings
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
      break;
    case 2: // Add Module
      /// Opens a file picker to add a new module.
      Provider.of<ModuleUIPicker>(context, listen: false)
          .selectAndStoreModuleFile();
      break;
    case 3: // Need Help
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NeedHelpPage(),
        ),
      );
      break;
    default:

      /// Displays an error dialog for unexpected indices.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Invalid menu selection'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Dismisses the dialog.
              child: const Text('OK'),
            ),
          ],
        ),
      );
      break;
  }
}
