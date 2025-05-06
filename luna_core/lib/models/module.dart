// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/utils/types.dart';

class Module {
  final String moduleId;
  final String title;
  final String author;
  final String authoringVersion;
  final Set<SequenceOfPages> sequences;

  ///// Aspect ratio (height/width)
  final double aspectRatio;

  final Page entryPage;

  // Constructor with required parameters
  Module({
    required this.moduleId,
    required this.title,
    required this.author,
    required this.authoringVersion,
    required this.sequences,
    required this.aspectRatio,
    required this.entryPage,
  });

  /// Factory method to create a [Module] from JSON.
  factory Module.fromJson(Json json) {
    var sequencesJson = json['module']['sequences'] as List<dynamic>;
    var sequences = sequencesJson
        .map((seqJson) => SequenceOfPages.fromJson(seqJson))
        .toSet();

    var entryPage = Page.fromJson(json['module']['entryPage']);

    return Module(
      moduleId: json['module']['moduleId'] as String,
      title: json['module']['title'] as String,
      author: json['module']['author'] as String,
      authoringVersion: json['module']['authoringVersion'],
      sequences: sequences,
      aspectRatio: (json['module']['aspectRatio'] as num).toDouble(),
      entryPage: entryPage,
    );
  }

  /// Converts the [Module] object to a JSON map.
  Json toJson() {
    return {
      'module': {
        'moduleId': moduleId,
        'title': title,
        'author': author,
        'authoringVersion': authoringVersion,
        'sequences': sequences.map((seq) => seq.toJson()).toList(),
        'aspectRatio': aspectRatio,
        'entryPage': entryPage.toJson(),
      },
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}
