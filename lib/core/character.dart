import 'package:flutter/material.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/core/verse.dart';

abstract class Character {
  Offset _offset = const Offset(0, 0);

  double _scale = 1;

  Color color;

  String name;

  Widget widget;

  Character({required this.color, required this.name, required this.widget});

  Offset get offset => _offset;

  double get scale => _scale;

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

  void setScale(double scale) {
    _scale = scale;
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
