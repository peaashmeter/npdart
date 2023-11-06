import 'package:flutter/material.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/painting/textshape.dart';
import 'package:npdart/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verse = InheritedStage.of(context).notifier?.verse;

    if (verse != null) {
      return CustomPaint(
          painter: TextShape(
              size.width,
              verse.header,
              Theme.of(context).textTheme.headlineSmall!,
              InheritedNovelState.of(context)
                  .snapshot
                  .preferences
                  .textBoxHeight),
          child: TextTypewriter(width: size.width));
    }
    return const SizedBox.shrink();
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
