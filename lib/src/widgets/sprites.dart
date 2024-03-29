import 'package:flutter/material.dart' hide Image;
import 'package:npdart/src/core/mouse.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';

class SpriteLayer extends StatefulWidget {
  const SpriteLayer({super.key});

  @override
  State<SpriteLayer> createState() => _SpriteLayerState();
}

class _SpriteLayerState extends State<SpriteLayer> {
  @override
  Widget build(BuildContext context) {
    final mousePos = InheritedMouse.of(context).mousePos;
    final size = MediaQuery.of(context).size;
    final center = size / 2;
    final stage = InheritedStage.of(context);

    final characters = stage.notifier?.characters.map((c) => AnimatedScale(
          scale: c.scale * (1 - c.depth),
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
          child: AnimatedSlide(
              offset: c.offset.scale(0.5, 0.5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  child: Transform.translate(
                    key: ValueKey(c.widget),
                    offset: _calculateParallax(mousePos, center, c.depth),
                    child: c.widget,
                  ),
                ),
              )),
        ));

    return Stack(
      children: [...characters!],
    );
  }

  Offset _calculateParallax(Offset mousePos, Size center, double depth) {
    final backgroundParallax =
        InheritedNovelState.of(context).snapshot.preferences.backgroundParallax;
    final parallaxFactor =
        backgroundParallax + backgroundParallax * (1 - depth);

    final offsetX = (center.width - mousePos.dx) * parallaxFactor;
    final offsetY = (center.height - mousePos.dy) * parallaxFactor;

    return Offset(offsetX, offsetY);
  }
}
