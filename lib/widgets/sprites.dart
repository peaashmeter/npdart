import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/widgets/painting/spritepainter.dart';
import '../core/scene.dart';

class SpriteLayer extends StatefulWidget {
  final Scene scene;
  final ValueNotifier<Offset> mousePosNotifier;
  const SpriteLayer(
      {super.key, required this.scene, required this.mousePosNotifier});

  @override
  State<SpriteLayer> createState() => _SpriteLayerState();
}

class _SpriteLayerState extends State<SpriteLayer> {
  //Отношение перемещения фона к перемещению мыши
  final parallaxFactor = 0.005;

  late Future<Map<Offset, Image>> imagesFuture;

  @override
  void initState() {
    imagesFuture = loadImages(widget.scene.sprites ?? {});
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SpriteLayer oldWidget) {
    imagesFuture = loadImages(widget.scene.sprites ?? {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final center = MediaQuery.of(context).size / 2;

    return FutureBuilder(
      future: imagesFuture,
      builder: (context, snapshot) {
        final images = snapshot.data?.values.toList() ?? [];
        final offsets = snapshot.data?.keys.toList() ?? [];
        return ValueListenableBuilder(
          valueListenable: widget.mousePosNotifier,
          builder: (context, mousePos, _) {
            return Transform.translate(
              offset: _calculateParallax(mousePos, center),
              child: CustomPaint(
                painter: SpritePainter(images, offsets),
                child: Container(),
              ),
            );
          },
        );
      },
    );
  }

  //TODO: вынести загрузку изображений в биндинг
  Future<Map<Offset, Image>> loadImages(Map<String, String> sprites) async {
    final offsets = <Offset>[];
    final images = <Image>[];

    for (var k in sprites.keys) {
      final offset = Director().preferences.spritePositions[k];
      assert(offset != null);
      offsets.add(offset!);
    }
    for (var v in sprites.values) {
      try {
        final bytes = await rootBundle.load(v);
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
