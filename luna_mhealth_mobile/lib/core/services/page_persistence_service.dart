// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:shared_preferences/shared_preferences.dart';

/// A service class for persisting and retrieving module-related data.
class PagePersistenceService {
  /// Loads the last visited page for a specific module.
  ///
  /// Returns the index of the last visited page for the given [moduleId].
  /// If no last visited page is found, returns 0.
  /// The [moduleId] parameter represents the unique identifier of the module.
  // TODO: implement the strong key [moduleId] to prevent conflicts
  Future<int> loadLastVisitedPage(String moduleId) async {
    print("ModulePersistenceService loadLastVisitedPage $moduleId");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lastPage_$moduleId') ?? 0;
  }

  /// Saves the last visited page for a specific module.
  ///
  /// The [pageIndex] parameter represents the index of the last visited page
  /// for the given [moduleId].
  /// The [moduleId] parameter represents the unique identifier of the module.
  // TODO: implement the strong key [moduleId] to prevent conflicts
  Future<void> saveLastVisitedPage(String moduleId, int pageIndex) async {
    print("ModulePersistenceService saveLastVisitedPage $moduleId");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage_$moduleId', pageIndex);
  }
}
