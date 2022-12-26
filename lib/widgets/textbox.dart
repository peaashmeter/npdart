import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/widgets/painting/textshape.dart';
import 'package:visual_novel/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  final Verse verse;
  const TextBox({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //если на сцене нет текста, не нужно рисовать текстбокс
    if (verse.stringId != null) {
      return CustomPaint(
        painter: TextShape(
          size.width,
          Director().getStringById(verse.headerId),
        ),
        child: TextTypewriter(
          width: size.width,
          verse: verse,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}