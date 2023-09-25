import 'package:flutter/material.dart';
import 'package:visual_novel/core/verse.dart';

class InheritedStage extends InheritedWidget {
  final Widget? background;
  final Set<Widget>? actors;
  final Verse? verse;
  const InheritedStage(
      {super.key,
      required this.background,
      required this.actors,
      required this.verse,
      required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static InheritedStage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStage>()!;
}
