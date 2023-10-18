import 'package:flutter/material.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/core/verse.dart';

abstract class Character {
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

  Character({required this.color, required this.name, required this.widget});

  Offset get offset => _offset;

  void enterScene() {
    Stage().characters.add(this);
  }

  void leaveScene() {
    setWidget(const SizedBox.shrink());
  }

  void moveTo(Offset offset) {
    _offset = offset;
  }

  void say(String phrase) {
    final verse = Verse(name, phrase, color);
    Stage().setVerse(verse);
  }

  void setWidget(Widget newWidget) {
    widget = newWidget;
  }
}

class Lena extends Character {
  Lena()
      : super(
            color: Colors.red,
            name: 'Олег',
            widget: Image.asset('assets/sprites/lena.png'));
}
