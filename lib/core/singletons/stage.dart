import 'dart:async';

import 'package:flutter/material.dart';
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
  Widget? background;
  Set<Character> characters = {};
  Set<Choice> choices = {};
  Verse? verse;
  // <----->

  final StreamController<NovelInputEvent> _eventStream =
      StreamController.broadcast();

  Future<NovelInputEvent> waitForInput() async {
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
    background = null;
    characters = {};
    choices = {};
    verse = null;

    final scene = Tree().getScene(id);
    scene.script?.call();
  }

  void setBackground(Widget background) {
    this.background = background;
    notifyListeners();
  }

  void rebuild() => notifyListeners();
}

class InheritedStage extends InheritedNotifier<Stage> {
  const InheritedStage({super.key, super.notifier, required super.child});

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}

class Character {
  void enterScene() {
    Stage().characters.add(this);
    Stage().rebuild();
  }

  void leaveScene() {
    Stage().characters.remove(this);
    Stage().rebuild();
  }

  Widget get widget => Container(
        color: Colors.red,
        width: 100,
        height: 100,
      );
}
