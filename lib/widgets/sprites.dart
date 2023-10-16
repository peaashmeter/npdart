import 'package:flutter/material.dart' hide Image;
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/singletons/stage.dart';

class SpriteLayer extends StatefulWidget {
  const SpriteLayer({super.key});

  @override
  State<SpriteLayer> createState() => _SpriteLayerState();
}

class _SpriteLayerState extends State<SpriteLayer> {
  //Отношение перемещения фона к перемещению мыши
  final parallaxFactor = 0.01;

  //late Future<Map<Offset, Image>> imagesFuture;

  @override
  Widget build(BuildContext context) {
    final mousePos = InheritedMouse.of(context).mousePos;
    final size = MediaQuery.of(context).size;
    final center = size / 2;
    final stage = InheritedStage.of(context);

    final characters = stage.notifier?.characters.map((c) => AnimatedScale(
          scale: c.scale,
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
                    offset: _calculateParallax(mousePos, center, c.scale),
                    child: c.widget,
                  ),
                ),
              )),
        ));

    return Stack(
      children: [...characters!],
    );
  }

  Offset _calculateParallax(Offset mousePos, Size center, double scale) {
    final offsetX = (center.width - mousePos.dx) * parallaxFactor * scale;
    final offsetY = (center.height - mousePos.dy) * parallaxFactor * scale;

    return Offset(offsetX, offsetY);
  }
}
