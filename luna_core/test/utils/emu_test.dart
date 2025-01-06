// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for EMU', () {
    test('Argument error is thrown when input is negative', () async {
      expect(() => EMU((b) => b..value = -1), throwsA(isArgumentError));
    });

    test('Value can be initialized with zero', () async {
      EMU emu = EMU((b) => b..value = 0);

      expect(emu.value, 0);
    });

    test('Value can be initialized with positive integer', () async {
      EMU emu = EMU((b) => b..value = 1);

      expect(emu.value, 1);
    });
  });
}
