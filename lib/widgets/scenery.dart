import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/widgets/background.dart';
import 'package:visual_novel/widgets/choices.dart';
import 'package:visual_novel/widgets/sprites.dart';
import 'package:visual_novel/widgets/textbox.dart';

class Scenery extends StatefulWidget {
  final Scene initialScene;
  const Scenery({super.key, required this.initialScene});

  @override
  State<Scenery> createState() => _SceneryState();
}

class _SceneryState extends State<Scenery> {
  final ValueNotifier<Offset> mousePosNotifier = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Director().runAction(Director().onLeaveActionId.value, []);
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        onHover: (event) => mousePosNotifier.value = event.position,
        opaque: false,
        child: Stack(
          children: [
            BackgroundImage(mousePosNotifier: mousePosNotifier),
            SpriteLayer(
              mousePosNotifier: mousePosNotifier,
            ),
            const Align(
              alignment: Alignment.center,
              child: OptionSpan(),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(padding: EdgeInsets.all(16.0), child: TextBox()),
            ),
          ],
        ),
      ),
    );
  }
}
