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
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/backgrounds/${scene!.background!}',
          fit: BoxFit.cover,
        ),
        if (scene!.text != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    assert(scene!.actionId != null);
                    Director.getInstance().runAction(scene!.actionId!);
                  },
                  child: TextSpan(
                    text: scene!.text ?? '',
                    header: scene!.header ?? '',
                  )),
            ),
          )
      ],
    );
  }
}

class TextSpan extends StatelessWidget {
  final String header;
  final String text;
  const TextSpan({super.key, required this.text, required this.header});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    child: Text(
                      header,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TypeText(text,
                            duration: const Duration(seconds: 3)),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
