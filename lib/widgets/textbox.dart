import 'package:flutter/material.dart';
import 'package:visual_novel/core/stage.dart';
import 'package:visual_novel/widgets/painting/textshape.dart';
import 'package:visual_novel/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //если на сцене нет текста, не нужно рисовать текстбокс

    return ValueListenableBuilder(
        valueListenable: Scene().verse,
        builder: (context, verse, child) {
          if (verse != null && verse.stringId != null) {
            return CustomPaint(
              painter: TextShape(
                  size.width,
                  Scene().getStringById(verse.headerId),
                  Theme.of(context).textTheme.headline5!),
              child: TextTypewriter(width: size.width, verse: verse),
            );
          }
          return const SizedBox.shrink();
        });
  }
}

class TextLayer extends StatelessWidget {
  const TextLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Padding(padding: EdgeInsets.all(16.0), child: TextBox()),
    );
  }
}
