import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/singletons/tree.dart';
import 'package:npdart/core/verse.dart';

class Stage with ChangeNotifier {
  static Stage? instance;

  factory Stage() {
    instance ??= Stage._();
    return instance!;
  }

  Stage._();

  // <----->
  Widget? _background;

  Widget? get background => _background;

  Set<Character> _characters = {};

  Set<Character> get characters => _characters;

  Set<Choice> _choices = {};

  Set<Choice> get choices => _choices;

  Verse? _verse;

  Verse? get verse => _verse;

  // <----->

  final StreamController<NovelInputEvent> _eventStream =
      StreamController.broadcast();

  ///
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
  }

  void setBackground(Widget background) {
    _background = background;
  }

  void setVerse(Verse? verse) {
    _verse = verse;
  }

  void showChoices(Set<Choice> choices) {
    _choices = choices;
  }
}

class InheritedStage extends InheritedNotifier<Stage> {
  const InheritedStage({super.key, super.notifier, required super.child});

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}
