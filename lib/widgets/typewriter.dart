import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/core/verse.dart';
import 'package:npdart/widgets/painting/textpainter.dart';

///Отрисовка текста побуквенно
class TextTypewriter extends StatefulWidget {
  static const punctuation = ['.', ',', '!', '?', ';', ':'];
  final double width;

  const TextTypewriter({super.key, required this.width});

  @override
  State<TextTypewriter> createState() => _TextTypewriterState();
}

class _TextTypewriterState extends State<TextTypewriter> {
  Verse? verse;
  String displayedText = '';

  late StreamSubscription<String> subscription;

  @override
  Widget build(BuildContext context) {
    final headerStyle =
        Theme.of(context).textTheme.headlineSmall!.apply(color: verse?.color);

    final stringStyle = Theme.of(context).textTheme.titleLarge!;
    if (verse == null) return const SizedBox.shrink();
    return CustomPaint(
      painter: CustomTextPainter(
          widget.width,
          displayedText,
          verse?.header ?? '',
          headerStyle,
          stringStyle,
          InheritedNovelState.of(context).snapshot.preferences.textBoxHeight),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _setup();
  }

  Stream<String> typeStream(int milliseconds) async* {
    final text = verse!.string.characters;
    for (var i = 0; i < text.length; i++) {
      final s = text.elementAt(i);
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
    final verse_ = InheritedStage.of(context).notifier?.verse;
    if (verse == verse_ || verse_ == null) return;
    verse = verse_;
    displayedText = '';
    subscription = _subscribe();
  }

  StreamSubscription<String> _subscribe() {
    final milliseconds =
        InheritedNovelState.of(context).snapshot.preferences.typingDelay;
    return typeStream(milliseconds).listen((s) {
      if (mounted) {
        setState(() {
          displayedText += s;
        });
      } else {
        subscription.cancel();
      }
    });
  }
}
