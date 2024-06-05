//This is a temporary class that contains all classes relevant to the games.
// I will split this up into multiple classes as they make sense.

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luna_core/models/image/image_component.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:luna_mhealth_mobile/games/animatedwidgets.dart';
import 'package:luna_mhealth_mobile/games/gameconstants.dart';
import 'package:luna_mhealth_mobile/games/gamecontext.dart';
import 'package:provider/provider.dart';

class GameContainer extends StatefulWidget {
  const GameContainer({super.key, required this.gameContext});

  final GameContext gameContext;

  @override
  State<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ProviderContainer(
        key: Key("game_${counter}"),
        gameContext: widget.gameContext,
      )),
      GameButton(
          text: TEXT_RESET_GAME,
          onTap: () {
            setState(() {
              counter++;
            });
          }),
      GameButton(
          text: TEXT_NEW_CATEGORY,
          onTap: () {
            setState(() {
              counter++;
            });
          }),
    ]);
  }
}

class ProviderContainer extends StatelessWidget {
  const ProviderContainer({super.key, required this.gameContext});

  final GameContext gameContext;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Game(gameContext: gameContext),
        ),
      ],
      child: GameInstanceWidget(
        key: Key("innergame_${super.key}"),
      ),
    );
  }
}

class GameInstanceWidget extends StatelessWidget {
  const GameInstanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Game game = context.watch<Game>();

    return Column(
      children: [
        Text("${TEXT_PROMPT} ${game.targetCategory.category_name}",
            textScaler: TextScaler.linear(GAME_FONT_SIZE)),
        if (game.gameState == GameState.active)
          Text("", textScaler: TextScaler.linear(GAME_FONT_SIZE)),
        if (game.gameState == GameState.won)
          Text(TEXT_WIN, textScaler: TextScaler.linear(GAME_FONT_SIZE)),
        if (game.gameState == GameState.lost)
          Text(TEXT_LOST, textScaler: TextScaler.linear(GAME_FONT_SIZE)),
        GameGrid(columns: 3, children: game.getTiles()),
        LivesRemainingDisplay(livesRemaining: game.incorrectRemaining),
      ],
    );
  }
}

class LivesRemainingDisplay extends StatelessWidget {
  const LivesRemainingDisplay({required this.livesRemaining, super.key});

  final int livesRemaining;

  @override
  Widget build(BuildContext context) {
    List<Widget> livesDisplay = List.empty(growable: true);
    //livesDisplay.add(SizedBox(width: 30,));
    livesDisplay.add(Text(
      "${TEXT_MISTAKES_REMAINING}",
      textScaler: TextScaler.linear(GAME_FONT_SIZE),
    ));

    for (int i = 0; i < livesRemaining; i++) {
      livesDisplay.add(Icon(
        Icons.circle,
        color: COLOR_MISTAKES_REMAINING,
      ));
    }
    //livesDisplay.add(SizedBox(width: 30,));

    return Row(
      children: livesDisplay,
    );
  }
}

class Game with ChangeNotifier {
  Game({required this.gameContext}) {
    RandomCategoryIterator iterator = RandomCategoryIterator();

    targetCategory = iterator.pickCategory(gameContext);

    tiles = List.empty(growable: true);

    for (int i = 0; i < 9; i++) {
      tiles.add(createTile());
    }

    incorrectRemaining = STARTING_MISTAKES;
  }

  late Category targetCategory;

  GameContext gameContext;

  late List<Widget> tiles;

  GameState gameState = GameState.active;

  int correctRemaining = 0;
  int incorrectRemaining = 0;

  Widget createTile() {
    RandomCategoryIterator iterator = RandomCategoryIterator();

    Category category = iterator.pickCategory(gameContext);
    CategoryMember member = iterator.pickCategoryMember(category);

    if (category == targetCategory) {
      correctRemaining++;
    }

    return TileWidget(
      category: category,
      member: member,
    );
  }

  List<Widget> getTiles() {
    return tiles;
  }

  TileState scoreTile(TileWidget tile) {
    if (tile.category == targetCategory) {
      correctRemaining--;
      return TileState.selected_correct;
    } else {
      incorrectRemaining--;
      notifyListeners();
      return TileState.selected_incorrect;
    }
  }

  void checkForEndGame() {
    if (correctRemaining == 0) {
      //Game won
      _ChangeGameState(GameState.won);
    }

    if (incorrectRemaining == 0) {
      //Game lost

      _ChangeGameState(GameState.lost);
    }
  }

  void _ChangeGameState(GameState newState) {
    gameState = newState;

    notifyListeners();
  }
}

enum GameState { active, won, lost }

//ITERATORS
abstract class CategoryIterator {
  ///Pick a  tiles from a given game context
  Category pickCategory(GameContext gameContext);

  ///Pick a category member from a given category
  CategoryMember pickCategoryMember(Category category);
}

///Randomly pick tiles from the game context
class RandomCategoryIterator extends CategoryIterator {
  @override
  Category pickCategory(GameContext gameContext) {
    Random random = Random();
    Category category =
        gameContext.categories[random.nextInt(gameContext.categories.length)];

    return category;
  }

  @override
  CategoryMember pickCategoryMember(Category category) {
    Random random = Random();

    CategoryMember member =
        category.members[random.nextInt(category.members.length)];

    return member;
  }
}

class GameGrid extends StatelessWidget {
  const GameGrid(
      {super.key, required int columns, required List<Widget> children})
      : _columns = columns,
        _children = children;

  final int _columns;
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: _columns,
        children: _children,
      ),
    );
  }
}

class TileWidget extends StatefulWidget {
  const TileWidget({super.key, required this.category, required this.member});

  final Category category;
  final CategoryMember member;

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  TileState state = TileState.unselected;

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Game game = context.watch<Game>();

    if (game.gameState != GameState.active) {
      if (state == TileState.unselected) {
        state = TileState.unselected_locked;
        controller.forward();
      }
    }

    TileRender tileRender = TileRender(
      drawBorder: (state == TileState.unselected),
      image: widget.member.imagePath,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _select(game);
      },
      child: Container(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            //
            //TileRender(drawBorder: (state == TileState.unselected), image: widget.member.image,),
            if (state == TileState.unselected) tileRender,

            if (state == TileState.selected_correct)
              ZoomWidget(
                  controller: controller, child: tileRender, intensity: 15),
            if (state == TileState.selected_incorrect)
              ShakeWidget(
                  controller: controller, child: tileRender, intensity: 10),
            if (state == TileState.unselected_locked) tileRender,
            //if (state == TileState.selected_incorrect) ShakeWidget(controller: controller, child: tileRender, intensity: 10),

            if (state == TileState.selected_correct)
              TileCheckmarkRender(
                  icon:
                      Icon(Icons.check_circle, color: COLOR_CORRECT, size: 40)),
            if (state == TileState.selected_incorrect)
              TileCheckmarkRender(
                  icon: Icon(Icons.remove_circle,
                      color: COLOR_INCORRECT, size: 40)),
          ],
        ),
      ),
    );
  }

  void _select(Game game) {
    if (state != TileState.unselected) {
      return;
    }

    setState(() {
      state = game.scoreTile(this.widget);
      controller.forward();
    });

    game.checkForEndGame();
  }
}

enum TileState {
  unselected,
  unselected_locked,
  selected_correct,
  selected_incorrect
}

class TileRender extends StatelessWidget {
  const TileRender({super.key, required this.drawBorder, required this.image});

  final bool drawBorder;
  final String image;

  @override
  Widget build(BuildContext context) {
    BoxBorder? border = null;

    if (drawBorder) {
      border = Border.all(
        width: 2,
        color: Color.fromARGB(255, 0, 0, 0),
      );
    }

    //Future<Uint8List?> imageData = ModuleResourceFactory.getImageBytes(image);

    String imageFileName = image.split('/').last;

    /// Updated the render method to use the new getImageBytes signature

    return Stack(
      children: [
        Positioned(
          child: FutureBuilder<Uint8List?>(
            future: ModuleResourceFactory.getImageBytes(imageFileName),
            builder:
                (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.memory(snapshot.data!).image),
                      border: border),
                );
              }

              return Text(AppConstants.noImageErrorMessage);
            },
          ),

          /*Container(
                decoration: BoxDecoration(
                image: DecorationImage(image: Image.memory(imageData).image),
                border: border
                ),
              ),*/
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        )
      ],
    );
  }
}

class TileCheckmarkRender extends StatelessWidget {
  const TileCheckmarkRender({super.key, required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: icon, //Image(image: Image.asset(image).image),
      left: 0, right: 60, top: 0, bottom: 60,
    );
  }
}

///Bubled Circle Style
class GameButton extends StatelessWidget {
  const GameButton({super.key, required this.text, required this.onTap});

  final String text;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: GestureDetector(
        child: Text(
          " ${text} ",
          textScaler: TextScaler.linear(GAME_FONT_SIZE),
        ),
        onTap: onTap,
      ),
    );
  }
}
