import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/singletons/stage.dart';
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
  late String text;
  late String displayedText;

  late String header;

  late Color headerColor;

  late StreamSubscription<String> subscription;

  @override
  Widget build(BuildContext context) {
    final headerStyle =
        Theme.of(context).textTheme.headline5!.apply(color: headerColor);

    final stringStyle = Theme.of(context).textTheme.headline6!;
    return CustomPaint(
      painter: CustomTextPainter(widget.width, displayedText, header,
          headerStyle, stringStyle, Preferences.of(context).textBoxHeight),
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
    text = InheritedStage.of(context).notifier?.verse?.string ?? '';
    header = InheritedStage.of(context).notifier?.verse?.header ?? '';
    headerColor = Colors.pink;

    displayedText = '';

    subscription = _subscribe();
  }

  StreamSubscription<String> _subscribe() {
    final milliseconds = Preferences.of(context).milliseconds;
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
