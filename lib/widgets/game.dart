import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/widgets/background.dart';
import 'package:npdart/widgets/choices.dart';
import 'package:npdart/widgets/sprites.dart';
import 'package:npdart/widgets/textbox.dart';

class Game extends StatefulWidget {
  final Scene initialScene;
  const Game({super.key, required this.initialScene});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Set<Character> actors = {};
  Offset mousePos = Offset.zero;

  @override
  void initState() {
    widget.initialScene.script?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (Stage().choices.isNotEmpty) return;
        Stage().dispatchEvent(RequestNextEvent());
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        onHover: (event) => setState(() {
          mousePos = event.position;
        }),
        opaque: false,
        child: InheritedMouse(
          mousePos: mousePos,
          child: InheritedStage(
            notifier: Stage(),
            child: const Stack(
              children: [
                BackgroundLayer(),
                SpriteLayer(),
                OptionLayer(),
                TextLayer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
