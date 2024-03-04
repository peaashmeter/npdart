import 'package:flutter/widgets.dart';

class InheritedMouse extends InheritedWidget {
  final Offset mousePos;

  const InheritedMouse(
      {super.key, required super.child, required this.mousePos});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static InheritedMouse of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMouse>()!;
}
