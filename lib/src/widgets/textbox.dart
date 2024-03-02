import 'package:flutter/material.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';
import 'package:npdart/src/widgets/painting/textshape.dart';
import 'package:npdart/src/widgets/typewriter.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final verse = InheritedStage.of(context).notifier?.verse;
    final width = MediaQuery.of(context).size.width * 0.7;
    final height =
        InheritedNovelState.of(context).snapshot.preferences.textBoxHeight;

    if (verse != null) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            painter: TextShape(
                width,
                verse.header,
                Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: verse.color),
                height),
          ),
          Container(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextTypewriter(width: width),
              ))
        ],
      );
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
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(padding: EdgeInsets.all(16.0), child: TextBox()));
  }
}
