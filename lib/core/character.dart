import 'package:flutter/material.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/core/verse.dart';

abstract class Character {
  void enterScene() {
    Stage().characters.add(this);
  }

  void leaveScene() {
    Stage().characters.remove(this);
  }

  void say(String phrase) {
    final verse = Verse(name, phrase, color);
    Stage().setVerse(verse);
  }

  Color get color;
  String get name;

  Widget get widget;
}

class RedSquare extends Character {
  @override
  Color get color => Colors.red;

  @override
  String get name => 'Красный квадрат';

  @override
  Widget get widget => Container(
        width: 100,
        height: 100,
        color: Colors.red,
      );
}
