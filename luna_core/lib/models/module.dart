// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/utils/types.dart';

class Module {
  final String moduleId;
  final String title;
  final String author;
  final String authoringVersion;
  final List<Page> pages;

  ///// Aspect ratio (height/width)
  final double aspectRatio;

  // Constructor with required parameters
  Module({
    required this.moduleId,
    required this.title,
    required this.author,
    required this.authoringVersion,
    required this.pages,
    required this.aspectRatio,
  });

  /// Factory method to create a [Module] from JSON.
  factory Module.fromJson(Json json) {
    var slidesJson = json['module']['pages'] as List<dynamic>;
    var pages =
        slidesJson.map((slideJson) => Page.fromJson(slideJson)).toList();

    return Module(
      moduleId: json['module']['moduleId'] as String,
      title: json['module']['title'] as String,
      author: json['module']['author'] as String,
      authoringVersion: json['module']['authoringVersion'],
      pages: pages,
      aspectRatio: (json['module']['aspectRatio'] as num).toDouble(),
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
        'pages': pages.map((page) => page.toJson()).toList(),
        'aspectRatio': aspectRatio,
      },
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}
