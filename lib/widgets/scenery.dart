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

  @override
  void initState() {
    scene = widget.initialScene;

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundImage(initialImage: scene!.background!),
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
    );
  }
}
