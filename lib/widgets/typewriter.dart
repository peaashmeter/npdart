import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/widgets/painting.dart';

///Отрисовка текста побуквенно
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
