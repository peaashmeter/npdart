import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/singletons/state.dart';
import 'package:npdart/core/singletons/tree.dart';
import 'package:npdart/core/verse.dart';

class InheritedStage extends InheritedNotifier<Stage> {
  const InheritedStage({super.key, super.notifier, required super.child});

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}

class Stage with ChangeNotifier {
  static Stage? instance;

  Widget? _background;

  Set<Character> _characters = {};

  Set<Choice> _choices = {};

  Verse? _verse;

  final _history = Queue<Verse>();

  final StreamController<NovelInputEvent> _eventStream =
      StreamController.broadcast();

  factory Stage() {
    instance ??= Stage._();
    return instance!;
  }

  Stage._();

  Widget? get background => _background;

  Set<Character> get characters => _characters;

  Set<Choice> get choices => _choices;

  List<Verse> get history => List.unmodifiable(_history);

  Verse? get verse => _verse;

  void dispatchEvent(NovelInputEvent event) {
    _eventStream.add(event);
  }

  void loadScene(String id) {
    _background = null;
    _characters = {};
    _choices = {};
    _verse = null;

    final scene = Tree().getScene(id);
    scene.script?.call();

    NovelState().sceneId = id;
    NovelState().save();
  }

  void setBackground(Widget background) {
    _background = background;
  }

  void setVerse(Verse? verse) {
    _verse = verse;

    if (verse != null) {
      _logVerse(verse);
    }
  }

  void showChoices(Set<Choice> choices) {
    _choices = choices;
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

  void _logVerse(Verse verse) {
    if (_history.length > 100) {
      _history.removeLast();
    }
    _history.addFirst(verse);
  }
}
