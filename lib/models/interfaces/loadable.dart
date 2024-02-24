// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/foundation.dart';

/// An abstract class representing a loadable element.
///
/// Implementing classes must provide an implementation for the [load] method
/// and fire callbacks (if necessary) after loading is complete.
abstract class Loadable {
  /// Indicates if the component data is loading
  bool get isLoading;

  /// Indicates if the component has been loaded successfully
  bool get isLoaded;

  /// Starts loading the component's data/assets.
  Future<void> load();

  /// Registers a callback function, executed after component loading completes.
  void addLoadListener(VoidCallback listener);
}
