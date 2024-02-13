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

abstract class IStorageProvider {
  // Save data to a file
  Future<bool> saveFile(String fileName, Uint8List data);

  // Load data from a file
  Future<Uint8List?> loadFile(String fileName);

  // Delete a file
  Future<bool> deleteFile(String fileName);

  // Check if a file exists
  Future<bool> isFileExists(String fileName);

  // Dispose and cleanup connections
  void close();
}
