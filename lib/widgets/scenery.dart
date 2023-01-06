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
  Scene? scene;
  //Абсолютное положение курсора в окне
  late ValueNotifier<Offset> mousePosNotifier;

  @override
  Widget build(BuildContext context) {
    assert(scene is Scene);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Director().runAction(scene!.onLeaveActionId, [scene]);
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        onHover: (event) => mousePosNotifier.value = event.position,
        opaque: false,
        child: Stack(
          children: [
            BackgroundImage(
                initialBackgroundId: scene!.background!,
                mousePosNotifier: mousePosNotifier),
            SpriteLayer(
              scene: scene!,
              mousePosNotifier: mousePosNotifier,
            ),
            Align(
              alignment: Alignment.center,
              child: OptionSpan(choices: scene!.choices),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: scene!.verse != null
                    ? TextBox(verse: scene!.verse!)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    scene = widget.initialScene;
    Director().runAction(Director().onLoadActionId, []);

    mousePosNotifier = ValueNotifier(Offset.zero);

    Director().sceneHandler.addListener(() {
      Director().runAction(Director().onLoadActionId, []);

      setState(() {
        scene = Director().sceneHandler.currentScene;
      });
    });
    super.initState();
  }
}
