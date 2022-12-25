import 'package:flutter/material.dart';

import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/widgets/background.dart';
import 'package:visual_novel/widgets/textbox.dart';
import 'package:visual_novel/widgets/options.dart';

class Scenery extends StatefulWidget {
  final GenericScene initialScene;
  const Scenery({super.key, required this.initialScene});

  @override
  State<Scenery> createState() => _SceneryState();
}

class _SceneryState extends State<Scenery> {
  GenericScene? scene;
  //Абсолютное положение курсора в окне
  late ValueNotifier<Offset> mousePosNotifier;

  @override
  void initState() {
    scene = widget.initialScene;

    mousePosNotifier = ValueNotifier(Offset.zero);

    Director().sceneHandler.addListener(() {
      setState(() {
        scene = Director().currentScene as GenericScene;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(scene is GenericScene);

    return GestureDetector(
      onTap: () {
        Director().runAction(scene!.actionId, [scene]);
      },
      child: MouseRegion(
        //Необходимо захватывать положение курсора здесь для того, чтобы
        //параллакс работал при наведении на любой виджет.
        onHover: (event) => mousePosNotifier.value = event.position,
        opaque: false,
        child: Stack(
          children: [
            BackgroundImage(
                initialImage: scene!.background!,
                mousePosNotifier: mousePosNotifier),
            Align(
              alignment: Alignment.center,
              child: OptionSpan(choices: scene!.choices),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextBox(
                  verse: scene!.verse,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
