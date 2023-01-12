import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/widgets/painting/textshape.dart';
import 'package:visual_novel/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //если на сцене нет текста, не нужно рисовать текстбокс

    return ValueListenableBuilder(
        valueListenable: Director().verse,
        builder: (context, verse, child) {
          if (verse != null && verse.stringId != null) {
            return CustomPaint(
              painter: TextShape(
                  size.width,
                  Director().getStringById(verse.headerId),
                  Theme.of(context).textTheme.headline5!),
              child: TextTypewriter(width: size.width, verse: verse),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
