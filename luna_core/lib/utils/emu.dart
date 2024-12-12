// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// EMU(English Metric Units) is a measurement in computer typography.
/// These units are used to translate on-screen layouts to printed layouts for specified printer hardware.
/// EMU units are always positive as descrived in the c-rex documentation.
/// More information about EMU
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_sldSz_topic_ID0EULOGB.html
/// https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-odraw/40cd0cf9-f038-4603-b790-252d93e3e8fd

import 'package:luna_core/utils/logging.dart';

class EMU {
  int value;

  EMU(this.value) {
    if (value < 0) {
      LogManager().logTrace(
        'value must be a non-negative integer, but got $value',
        LunaSeverityLevel.Warning,
      );
    }
  }
}
