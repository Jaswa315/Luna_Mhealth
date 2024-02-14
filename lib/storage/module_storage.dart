// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// ModuleStorage
/// Purpose: Module Storage class for module file handling.  Operates on an
/// IStorageProvider.  Handles unpacking, packing, and validation of modules

import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';

class ModuleStorage {
  final IStorageProvider storageProvider;

  // CTOR.  Needs to handle userProfiles going forward.  
  // TODO: Add a defualt profile to the parameters
  ModuleStorage(this.storageProvider);

  // future<bool> saveModule(String moduleName, )
}
