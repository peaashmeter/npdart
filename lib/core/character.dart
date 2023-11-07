import 'package:flutter/material.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/core/verse.dart';

abstract class Character {
  final Stage stage;

  Offset _offset = const Offset(0, 0);

  double scale = 1;

  double _depth = 0;

  double get depth => _depth;

  set depth(double value) {
    assert(value >= 0 && value <= 1,
        'A value of depth must be between 0 and 1, inclusive');
    _depth = value;
  }

  Color color;

  String name;

  Widget widget;

  Character(
      {required this.stage,
      required this.color,
      required this.name,
      required this.widget});

  Offset get offset => _offset;

  enterStage() {
    stage.characters.add(this);
  }

  void leaveStage() {
    setWidget(const SizedBox.shrink());
  }

  void moveTo(Offset offset) {
    _offset = offset;
  }

  void say(String phrase) {
    final verse = Verse(name, phrase, color);
    stage.setVerse(verse);
  }

  void setWidget(Widget newWidget) {
    widget = newWidget;
  }
}
