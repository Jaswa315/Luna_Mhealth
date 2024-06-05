// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:luna_mhealth_mobile/games/game.dart';
import 'package:luna_mhealth_mobile/games/gamecontext.dart';

/// Represents an image component that can be rendered and clicked.
class CategoryGame extends Component {

  ///The Game context of the current game
  GameContext gameContext;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath], [x], [y], [width], and [height].
  CategoryGame({
    required this.gameContext,
    required double x,
    required double y,
    required double width,
    required double height,
  }) : super(
            type: ComponentType.category_game,
            x: x,
            y: y,
            width: width,
            height: height,
            name: 'CategoryGame');

  @override
  Future<Widget> render() async {

    return GameContainer(gameContext: gameContext);
  }

  /// Creates an [ImageComponent] from a JSON map.
  /// Updated the fromJson method to include moduleName
  static CategoryGame fromJson(Map<String, dynamic> json, List<GameContext> games) {
    int gameIndex = (json['game_index'] as num).toInt();
    return CategoryGame(
      gameContext: games[gameIndex],
      x: json['position']['left'].toDouble(),
      y: json['position']['top'].toDouble(),
      width: json['position']['width'].toDouble(),
      height: json['position']['height'].toDouble(),
    );
  }

  @override
  void onClick() {}
}
