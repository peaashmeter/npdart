import 'package:flutter/material.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/widgets/background.dart';
import 'package:npdart/widgets/choices.dart';
import 'package:npdart/widgets/sprites.dart';
import 'package:npdart/widgets/textbox.dart';

class Stage extends StatefulWidget {
  const Stage({super.key});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> {
  Set<Character> actors = {};
  Offset mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          actors = {Character()};
        });
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        // onHover: (event) => setState(() {
        //   mousePos = event.position;
        // }),
        opaque: false,
        child: InheritedStage(
          actors: actors,
          background: null,
          choices: {},
          verse: null,
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
    );
  }
}
