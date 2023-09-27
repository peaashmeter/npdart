import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

class SpritePainter extends CustomPainter {
  final List<Image> images;
  final List<Offset> offsets;
  final double imageHeight;

  SpritePainter(this.images, this.offsets, this.imageHeight)
      : assert(images.length <= offsets.length);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < images.length; i++) {
      final img = images[i];
      final rect = Rect.fromCenter(
          center:
              Offset(offsets[i].dx * size.width, offsets[i].dy * size.height),
          width: img.width * size.height / imageHeight,
          height: img.height * size.height / imageHeight);
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
