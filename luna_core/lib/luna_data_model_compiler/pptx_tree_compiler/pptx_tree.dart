// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

library pptx;

import 'package:built_value/built_value.dart';
import 'package:luna_core/utils/emu.dart';

part 'pptx_tree.g.dart';

abstract class PptxTree implements Built<PptxTree, PptxTreeBuilder> {
  @nullable
  EMU get width;
  @nullable
  EMU get height;

  PptxTree._();

  factory PptxTree([updates(PptxTreeBuilder b)]) = _$PptxTree;
}
