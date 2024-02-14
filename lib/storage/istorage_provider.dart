/// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
/// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
/// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
/// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
/// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
/// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// IStorageProvider
/// Purpose: Storage provider interface for file access.  Powers local stoarge,
/// and cloud storage instances.
///
/// Author: Shaun Stangler

import 'dart:typed_data';

/// IStorageProvider: Interface for low level file storage access
/// To be implemented by local storage, database, and cloud data providers
abstract class IStorageProvider {
  /// saveFile: Save data to a file in a storage provider
  /// fileName: {path/}filename.ext
  /// data: data
  /// createContainer: Create a subdirectory or container based upon path
  /// returns: bool for success
  Future<bool> saveFile(String fileName, Uint8List data,
      {bool createContainer});

  /// loadFile: Load data from a file
  /// createContainer: Create a subdirectory or container based upon path
  /// fileName: {path/}filename.ext
  /// returns: Uint8List data 
  Future<Uint8List?> loadFile(String fileName);

  /// deleteFile: Delete a file.  Does not support recursive find.
  /// fileName: {path/}filename.ext
  /// returns: bool for success 
  Future<bool> deleteFile(String fileName);

  /// isFileExist: Lookup existance of a file.  Does not support recursive find.
  /// fileName: {path/}filename.ext
  /// returns: bool for success 
  Future<bool> isFileExists(String fileName);

  /// getAllFileNames: Get a list of filenames under the root path 
  /// or optional container.  Supports recursive lookup.
  /// container: the file subfolder or container
  /// returns: list of strings
  Future<List<String>> getAllFileNames({String container});

  /// getAllFiles: Get a list of files under the root path 
  /// or optional container.  Supports recursive lookup.
  /// container: the file subfolder or container
  /// returns: list of Uint8List data
  Future<List<Uint8List>> getAllFiles({String container});

  /// init: Supports connection initialization
  Future<bool> init({String options});

  /// Dispose and cleanup connections
  void close();
}
