import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/widgets/painting/spritepainter.dart';

class SpriteLayer extends StatefulWidget {
  const SpriteLayer({super.key});

  @override
  State<SpriteLayer> createState() => _SpriteLayerState();
}

class _SpriteLayerState extends State<SpriteLayer> {
  //Отношение перемещения фона к перемещению мыши
  final parallaxFactor = 0.005;

  //late Future<Map<Offset, Image>> imagesFuture;

  @override
  Widget build(BuildContext context) {
    // final mousePos = InheritedMouse.of(context).mousePos;
    // print(mousePos);

    final center = MediaQuery.of(context).size / 2;

    final stage = InheritedStage.of(context);
    final characters = stage.actors.map((c) => c.widget);

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: Transform.translate(
              offset: Offset.zero, // _calculateParallax(mousePos, center),
              child: child,
            ),
          );
        },
        child: Stack(
          children: [...characters],
        ));
  }

  Future<Map<Offset, Image>> loadImages(Map<String, String> sprites) async {
    final offsets = <Offset>[];
    final images = <Image>[];

    final root = Preferences.of(context).spritesRoot;

    for (var k in sprites.keys) {
      final offset = Preferences.of(context).spritePositions[k];
      assert(offset != null);
      offsets.add(offset!);
    }
    for (var v in sprites.values) {
      try {
        final bytes = await rootBundle.load('$root$v');
        final image = await decodeImageFromList(Uint8List.view(bytes.buffer));
        images.add(image);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return {};
      }
    }

    return Map.fromIterables(offsets, images);
  }

  Offset _calculateParallax(Offset mousePos, Size center) {
    //Рассматриваем это как вектор с измерениями вдвое меньше размеров экрана
    //(x, y) = (width, heigth)
    final center = MediaQuery.of(context).size / 2;

    final offsetX = (center.width - mousePos.dx) * parallaxFactor;
    final offsetY = (center.height - mousePos.dy) * parallaxFactor;

    return Offset(offsetX, offsetY);
  }
}
