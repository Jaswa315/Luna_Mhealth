// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Tree Validator Test', () {
    test('Given module and component bottom right coordinates, validate out of bounds component as false', () {
      double modulePageWidth = 500.0;
      double modulePageHeight = 500.0;
      double componentRightX = 480.0 + 100.0;
      double componentBottomY = 480.0 + 100.0;

      bool isValid = DataTreeValidator.isComponentInBounds(
          modulePageWidth, modulePageHeight, componentRightX, componentBottomY);

      expect(isValid, false);
    });
  });
}
