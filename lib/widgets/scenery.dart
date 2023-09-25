import 'package:flutter/material.dart';
import 'package:visual_novel/widgets/background.dart';
import 'package:visual_novel/widgets/choices.dart';
import 'package:visual_novel/widgets/sprites.dart';
import 'package:visual_novel/widgets/textbox.dart';

class Stage extends StatefulWidget {
  const Stage({super.key});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> {
  final ValueNotifier<Offset> mousePosNotifier = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //next action
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        onHover: (event) => mousePosNotifier.value = event.position,
        opaque: false,
        child: Stack(
          children: [
            BackgroundLayer(mousePosNotifier: mousePosNotifier),
            SpriteLayer(
              mousePosNotifier: mousePosNotifier,
            ),
            const OptionLayer(),
            const TextLayer(),
          ],
        ),
      ),
    );
  }
}
