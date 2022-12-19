import 'package:flutter/material.dart';
import 'package:type_text/type_text.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';

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
    Director.getInstance().sceneHandler.addListener(() {
      setState(() {
        scene = Director.getInstance().currentScene as GenericScene;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(scene is GenericScene);

    return Stack(
      children: [
        Image.asset('assets/backgrounds/${scene!.background!}'),
        if (scene!.text != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                  onTap: () {
                    //TODO
                    assert(scene is SimpleScene);
                    Director.getInstance()
                        .setScene((scene as SimpleScene).nextScene);
                  },
                  child: TextSpan(text: scene!.text ?? '')),
            ),
          )
      ],
    );
  }
}

class TextSpan extends StatelessWidget {
  final String text;
  const TextSpan({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      width: size.width * 0.67,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8)),
      child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeText(text, duration: const Duration(seconds: 3)),
          )),
    );
  }
}
