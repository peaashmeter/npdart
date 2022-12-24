import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/widgets/painting.dart';
import 'package:visual_novel/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  final Verse verse;
  const TextBox({super.key, required this.verse});

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
