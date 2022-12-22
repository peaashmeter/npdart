import 'dart:async';

import 'package:flutter/material.dart';

import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/widgets/painting.dart';

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

    return GestureDetector(
      onTap: () {
        assert(scene!.actionId != null);
        Director.getInstance().runAction(scene!.actionId!);
      },
      child: Stack(
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
                child: TextSpan(
                  text: scene!.text ?? '',
                  header: scene!.header ?? '',
                ),
              ),
            ),
        ],
      ),
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

    return CustomPaint(
      painter: TextShape(
        size.width,
        size.height,
        header,
      ),
      child: TextTypewriter(width: size.width, height: size.height, text: text),
    );
  }
}

class TextTypewriter extends StatefulWidget {
  final double width;
  final double height;
  final String text;
  const TextTypewriter(
      {super.key,
      required this.width,
      required this.height,
      required this.text});

  static const punctuation = ['.', ',', '!', '?', ';', ':'];

  @override
  State<TextTypewriter> createState() => _TextTypewriterState();
}

class _TextTypewriterState extends State<TextTypewriter> {
  final milliseconds = 30;
  late String displayedText;
  late StreamSubscription<String> subscription;

  Stream<String> typeStream(int milliseconds) async* {
    for (var i = 0; i < widget.text.length; i++) {
      final s = widget.text.characters.elementAt(i);
      yield s;

      //повышение читабельности текста
      if (TextTypewriter.punctuation.contains(s)) {
        await Future.delayed(Duration(milliseconds: 5 * milliseconds));
      } else {
        await Future.delayed(Duration(milliseconds: milliseconds));
      }
    }
  }

  StreamSubscription<String> _subscribe() {
    return typeStream(milliseconds).listen((s) {
      setState(() {
        displayedText += s;
      });
    });
  }

  @override
  void initState() {
    displayedText = '';

    subscription = _subscribe();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextTypewriter oldWidget) {
    displayedText = '';

    subscription.cancel();
    subscription = _subscribe();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomTextPainter(widget.width, widget.height, displayedText),
    );
  }
}
