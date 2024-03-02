import 'package:flutter/material.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/verse.dart';

///An abstract character of the novel.
///
///It's necessary to extend this class to create custom characters, as in the example:
///```dart
///class Megami extends Character {
///  Megami(Stage stage)
///      : super(
///            stage: stage,
///            color: Colors.orange,
///            name: 'megami',
///            widget: Image.asset('assets/sprites/fox.png'));
///}
///```
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

  ///A color of the header of every [Verse] created with [say].
  Color color;

  ///A text of the header of every [Verse] created with [say].
  String name;

  ///A visual of this [Character].
  Widget widget;

  Character(
      {required this.stage,
      required this.color,
      required this.name,
      required this.widget});

  Offset get offset => _offset;

  void enterStage() {
    stage.characters.add(this);
  }

  void leaveStage() {
    setWidget(const SizedBox.shrink());
  }

  void moveTo(Offset offset) {
    _offset = offset;
  }

  ///Set up a verse displayed in the text box.
  ///
  ///The header is [name] painted with [color].
  ///
  ///Also check [sayRich] to print an [InlineSpan].
  void say(String phrase) {
    final verse = Verse(header: name, string: phrase, color: color);
    stage.setVerse(verse);
  }

  ///Set up a verse displayed in the text box, with support of text formatting.
  ///
  ///The header is [name] painted with [color].
  void sayRich(InlineSpan phrase) {
    final verse = Verse(header: name, richString: phrase, color: color);
    stage.setVerse(verse);
  }

  void setWidget(Widget newWidget) {
    widget = newWidget;
  }
}
