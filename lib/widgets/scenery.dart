import 'dart:async';

import 'package:flutter/material.dart';

import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/verse.dart';
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
        assert(scene!.actionId != null);
        Director().runAction(scene!.actionId!, [scene]);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/${scene!.background!}',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextSpan(
                verse: scene!.verse,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextSpan extends StatelessWidget {
  final Verse verse;
  const TextSpan({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //если на сцене нет текста, не нужно рисовать текстбокс
    return verse.stringId != null
        ? CustomPaint(
            painter: TextShape(
              size.width,
              Director().getHeader(verse.headerId),
            ),
            child: TextTypewriter(
              width: size.width,
              verse: verse,
            ),
          )
        : const SizedBox.shrink();
  }
}

class TextTypewriter extends StatefulWidget {
  final double width;
  final Verse verse;
  const TextTypewriter({super.key, required this.width, required this.verse});

  static const punctuation = ['.', ',', '!', '?', ';', ':'];

  @override
  State<TextTypewriter> createState() => _TextTypewriterState();
}

class _TextTypewriterState extends State<TextTypewriter> {
  final milliseconds = 30;

  late String text;
  late String displayedText;

  late String header;

  late Color headerColor;

  late StreamSubscription<String> subscription;

  Stream<String> typeStream(int milliseconds) async* {
    for (var i = 0; i < text.characters.length; i++) {
      final s = text.characters.elementAt(i);
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

  void _setup() {
    assert(widget.verse.stringId != null);
    text = Director().getString(widget.verse.stringId);
    header = Director().getHeader(widget.verse.headerId);
    headerColor = Director().getColor(widget.verse.headerId);

    displayedText = '';

    subscription = _subscribe();
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextTypewriter oldWidget) {
    subscription.cancel();
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          CustomTextPainter(widget.width, displayedText, header, headerColor),
    );
  }
}
