import 'package:flutter/material.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';
import 'package:npdart/src/core/verse.dart';
import 'package:rich_typewriter/rich_typewriter.dart';

///Отрисовка текста побуквенно
class TextTypewriter extends StatefulWidget {
  final double width;

  const TextTypewriter({super.key, required this.width});

  @override
  State<TextTypewriter> createState() => _TextTypewriterState();
}

class _TextTypewriterState extends State<TextTypewriter> {
  final punctuation = {'.', ',', '!', '?', ';', ':'};

  @override
  Widget build(BuildContext context) {
    final stage = InheritedStage.of(context).notifier!;
    final verse = stage.verse;

    final stringStyle = Theme.of(context).textTheme.titleLarge!;

    final baseDelay =
        InheritedNovelState.of(context).snapshot.preferences.typingDelay;

    final text = switch (verse) {
      Verse(string: String s) =>
        Text.rich(TextSpan(text: s, style: stringStyle)),
      Verse(richString: InlineSpan s) => Text.rich(s),
      _ => SizedBox.shrink()
    };

    return RichTypewriter(
        key: ValueKey(verse),
        symbolDelay: (symbol) {
          if (stage.typewritingState case TypewritingStates.fast) {
            return 10;
          }

          return switch (symbol) {
            TextSpan(text: var s) when punctuation.contains(s) => baseDelay * 5,
            _ => baseDelay
          };
        },
        onCompleted: () => stage.typewritingState = TypewritingStates.finished,
        child: text);
  }
}
