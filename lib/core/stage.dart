import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/verse.dart';

class InheritedStage extends InheritedNotifier<Stage> {
  const InheritedStage({super.key, super.notifier, required super.child});

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}

class Stage with ChangeNotifier {
  Stage();

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

  void dispatchEvent(NovelInputEvent event) {
    _eventStream.add(event);
  }

  void setBackground(Widget background) {
    _background = background;
  }

  void setVerse(Verse? verse) {
    _verse = verse;

    if (verse != null) {
      verseHistory.add(verse);
    }
  }

  void showChoices(Set<Choice> choices) {
    _choices.clear();
    _choices.addAll(choices);
  }

  ///Rebuilds the stage according to provided changes, then waits for user input (usually screen tap)
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
