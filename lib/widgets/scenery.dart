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
            alignment: Alignment.center,
            child: OptionSpan(choices: scene!.choices),
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
              Director().getString(verse.headerId),
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
    header = Director().getString(widget.verse.headerId);
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

///Список выборов, которые есть на сцене
class OptionSpan extends StatelessWidget {
  final List<String>? choices;
  const OptionSpan({super.key, this.choices});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var c in choices ?? [])
          OptionContainer(
              size: size,
              text: Director().getString(c),
              callback: Director().getFunction(c)),
      ],
    );
  }
}

class OptionContainer extends StatefulWidget {
  final String text;
  final Function callback;

  const OptionContainer({
    Key? key,
    required this.size,
    required this.text,
    required this.callback,
  }) : super(key: key);

  final Size size;

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  final defaultStyle =
      TextStyle(fontSize: 24, color: Colors.yellow.shade100, shadows: const [
    Shadow(
      blurRadius: 2,
      offset: Offset(2, 2),
    ),
  ]);

  final onHoverStyle =
      const TextStyle(fontSize: 24, color: Colors.white, shadows: [
    Shadow(
      blurRadius: 2,
      offset: Offset(2, 2),
    ),
  ]);

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (event) => setState(() {
          hover = true;
        }),
        onExit: (event) => setState(() {
          hover = false;
        }),
        child: GestureDetector(
          onTap: () => widget.callback.call(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0),
              ], stops: const [
                0.1,
                0.25,
                0.75,
                0.9
              ]),
            ),
            height: 57,
            width: widget.size.width * 0.7,
            child: DefaultTextStyle(
                style: hover ? onHoverStyle : defaultStyle,
                child: Center(
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
