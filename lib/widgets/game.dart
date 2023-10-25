import 'dart:math';

import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/core/singletons/state.dart';
import 'package:npdart/widgets/background.dart';
import 'package:npdart/widgets/choices.dart';
import 'package:npdart/widgets/sprites.dart';
import 'package:npdart/widgets/textbox.dart';
import 'package:npdart/widgets/ui.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  Set<Character> actors = {};
  Offset mousePos = Offset.zero;

  late AnimationController fakeMouseController;
  late Animation<double> fakeMouseAnimation;

  @override
  void initState() {
    fakeMouseController =
        AnimationController(duration: const Duration(seconds: 7), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: fakeMouseController,
      curve: Curves.easeInOutSine,
      reverseCurve: Curves.easeInOutSine,
    );
    fakeMouseAnimation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    fakeMouseController.repeat(
      reverse: true,
    );

    Stage().loadScene(NovelState().sceneId ?? 'root');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    mousePos = Offset(size.width * fakeMouseAnimation.value,
        size.height / 2 - sin(pi * fakeMouseAnimation.value) * size.height / 2);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (Stage().choices.isNotEmpty) return;
        Stage().dispatchEvent(RequestNextEvent());
      },
      child: MouseRegion(
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
                UiLayer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
