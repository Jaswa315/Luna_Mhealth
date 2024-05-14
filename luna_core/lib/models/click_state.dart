// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// Represents the state of a click event.
///
/// This class is responsible for managing the state of a click event, including
/// whether the text should be displayed in bold, the color of the border, and
/// the current text value. It also provides methods to toggle the bold state,
/// change the text value, and change the border color. This class extends
/// [ChangeNotifier] to allow for the notification of listeners when the state
/// changes.
class ClickState with ChangeNotifier {
  bool _isBold = false;
  Color _borderColor = Colors.transparent;
  String _text = "Hello, World!";

  bool get isBold => _isBold;
  Color get borderColor => _borderColor;
  String get text => _text;

  /// Toggles the bold state.
  ///
  /// This method toggles the value of [_isBold] and notifies listeners of the
  /// state change.
  void toggleBold() {
    _isBold = !_isBold;
    notifyListeners();
  }

  /// Changes the text value.
  ///
  /// This method changes the value of [_text] to either "Updated Text" or
  /// "Initial Text" based on its current value. It also notifies listeners of
  /// the state change.
  void changeText() {
    _text = _text == "Hello, World!" ? "Updated Text" : "Hello, World!";
    notifyListeners();
  }

  /// Changes the border color.
  ///
  /// This method changes the value of [_borderColor] based on its current
  /// value. If the current color is transparent, it changes it to blue. If the
  /// current color is blue, it changes it to red. Otherwise, it changes it to
  /// transparent. It also notifies listeners of the state change.
  void changeBorderColor() {
    _borderColor = _borderColor == Colors.transparent
        ? Colors.blue
        : _borderColor == Colors.blue
            ? Colors.red
            : Colors.transparent;
    notifyListeners();
  }
}
