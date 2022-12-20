import 'dart:math';

import 'package:flutter/material.dart';

class TextShape extends CustomPainter {
  ///размер экрана
  final double _width;
  final double _height;

  final String header;

  TextShape(this._width, this._height, this.header);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = Colors.black.withOpacity(0.8);
    final Paint stroke = Paint()
      ..color = Colors.teal.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    //размеры самого окошка для текста
    final width = _width * 0.7;
    final height = min(_height * 0.15, 120.0);

    //расчет заголовка

    final headerPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(text: header, style: const TextStyle(fontSize: 16));

    headerPainter.layout();

    final headerWidth = headerPainter.width + 16;
    final headerHeight = headerPainter.height + 16;

    final Path textBox = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(center: Offset.zero, width: width, height: height),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
          topRight: const Radius.circular(8),
        ),
      )
      ..close();
    final Path headerBox = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(-width * 0.5, -height * 0.5 - headerHeight, headerWidth,
            headerHeight),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      ))
      ..close();

    final path = Path.combine(PathOperation.union, textBox, headerBox);

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    final headerPosition = Offset(-width * 0.5 + 8, -height * 0.5 - 40 + 8);

    headerPainter.paint(canvas, headerPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
