import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;
import 'package:visual_novel/core/director.dart';

class SpritePainter extends CustomPainter {
  final List<Image> images;
  final List<Offset> offsets;

  SpritePainter(this.images, this.offsets)
      : assert(images.length <= offsets.length);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < images.length; i++) {
      final img = images[i];
      final rect = Rect.fromCenter(
          center:
              Offset(offsets[i].dx * size.width, offsets[i].dy * size.height),
          width: img.width * size.height / Director().preferences.imageHeight,
          height:
              img.height * size.height / Director().preferences.imageHeight);
      paintImage(
          canvas: canvas,
          rect: rect,
          image: images[i],
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
