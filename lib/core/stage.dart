import 'package:flutter/material.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/verse.dart';

class InheritedStage extends InheritedWidget {
  final Widget? background;
  final Set<Character> actors;
  final Set<Choice> choices;
  final Verse? verse;
  const InheritedStage(
      {super.key,
      required this.background,
      required this.actors,
      required this.verse,
      required this.choices,
      required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}

class Character {
  Widget get widget => Container(
        color: Colors.red,
        width: 100,
        height: 100,
      );
}
