import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npdart/src/core/character.dart';
import 'package:npdart/src/core/choice.dart';
import 'package:npdart/src/core/event.dart';
import 'package:npdart/src/core/audio.dart';
import 'package:npdart/src/core/verse.dart';

class InheritedStage extends InheritedNotifier<Stage> {
  const InheritedStage({super.key, super.notifier, required super.child});

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}



class Stage with ChangeNotifier {
  final AudioManager audio;
  Stage({required this.audio});

  final List<Verse> verseHistory = [];

  Widget? _background;

  final Set<Character> _characters = {};

  final Set<Choice> _choices = {};

  Verse? _verse;

  final StreamController<NovelInputEvent> _eventStream =
      StreamController.broadcast();

  Widget? get background => _background;

  Set<Character> get characters => _characters;

  Set<Choice> get choices => _choices;

  Verse? get verse => _verse;

  /// When verse is still being typed,
  /// we should show full text instead of changing scenes.
  bool isFullTextShown = true;

  void dispatchEvent(NovelInputEvent event) {
    switch (event) {
      case RequestNextEvent():
        if (!isFullTextShown) {
          isFullTextShown = true;
          return;
        }
        if (choices.isNotEmpty) return;
        break;
      case DialogOptionEvent():
        _choices.clear();
        break;
    }

    _eventStream.add(event);
  }

  void setBackground(Widget background) {
    _background = background;
  }

  void setVerse(Verse? verse) {
    _verse = verse;

    if (verse != null) {
      verseHistory.add(verse);
      isFullTextShown = false;
    } else {
      isFullTextShown = true;
    }
  }

  void showChoices(Set<Choice> choices) {
    _choices.clear();
    _choices.addAll(choices);
  }

  ///Rebuilds the stage according to provided changes, then waits for user input (usually screen tap).
  ///If the user input is a choice, returns a [DialogOptionEvent] so you can read the result.
  Future<NovelInputEvent> waitForInput() async {
    notifyListeners();

    Completer<NovelInputEvent> result = Completer();

    final subscription = _eventStream.stream.listen(null);
    subscription.onData((data) {
      result.complete(data);
      subscription.cancel();
    });

    return result.future;
  }
}
