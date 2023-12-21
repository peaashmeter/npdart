import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/widgets/game.dart';

class ParralaxHandler extends StatefulWidget {
  const ParralaxHandler({super.key});

  @override
  State<ParralaxHandler> createState() => _ParralaxHandlerState();
}

class _ParralaxHandlerState extends State<ParralaxHandler>
    with SingleTickerProviderStateMixin {
  Offset mousePos = Offset.zero;
  late AnimationController fakeMouseController;
  late Animation<double> fakeMouseAnimation;

  @override
  void initState() {
    fakeMouseController =
        AnimationController(duration: const Duration(seconds: 7), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: fakeMouseController,
      curve: Curves.easeInOutSine,
      reverseCurve: Curves.easeInOutSine,
    );
    fakeMouseAnimation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    fakeMouseController.repeat(
      reverse: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    mousePos = Offset(size.width * fakeMouseAnimation.value,
        size.height / 2 - sin(pi * fakeMouseAnimation.value) * size.height / 2);

    return InheritedMouse(mousePos: mousePos, child: const Game());
  }
}
