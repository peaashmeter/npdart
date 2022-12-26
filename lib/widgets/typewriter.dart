import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/widgets/painting/textpainter.dart';

///Отрисовка текста побуквенно
class TextTypewriter extends StatefulWidget {
  static const punctuation = ['.', ',', '!', '?', ';', ':'];
  final double width;
  final Verse verse;

  const TextTypewriter({super.key, required this.width, required this.verse});

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

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          CustomTextPainter(widget.width, displayedText, header, headerColor),
    );
  }

  @override
  void didUpdateWidget(covariant TextTypewriter oldWidget) {
    subscription.cancel();
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

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

  void _setup() {
    assert(widget.verse.stringId != null);
    text = Director().getStringById(widget.verse.stringId);
    header = Director().getStringById(widget.verse.headerId);
    headerColor = Director().getColorById(widget.verse.headerId);

    displayedText = '';

    subscription = _subscribe();
  }

  StreamSubscription<String> _subscribe() {
    return typeStream(milliseconds).listen((s) {
      setState(() {
        displayedText += s;
      });
    });
  }
}
