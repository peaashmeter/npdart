import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';

import 'textpainter.dart';

///Отрисовщик формы для текста
class TextShape extends CustomPainter {
  ///размер экрана
  final double _width;

  final String _header;

  final TextStyle _headerStyle;

  //ширина окошка с текстом
  late final width = _width * 0.7;

  late final height = Director().preferences.textBoxHeight;

  TextShape(this._width, this._header, this._headerStyle);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = Colors.black.withOpacity(0.8);
    final Paint stroke = Paint()
      ..color = Colors.white10.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint outerStroke = Paint()
      ..color = Colors.white30.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    //окошко текста
    final Path textBox = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
              center: Offset(0, -height * 0.5), width: width, height: height),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
          topRight: const Radius.circular(8),
        ),
      )
      ..close();

    //окошко заголовка
    final headerBox = _getHeaderPath(width);

    final path = Path.combine(PathOperation.union, textBox, headerBox);

    canvas.drawPath(path, fill);
    canvas.drawPath(path, outerStroke);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Path _getHeaderPath(double width) {
    //расчет заголовка
    TextPainter headerPainter = getHeaderPainter(_header, _headerStyle);

    headerPainter.layout();

    final headerWidth = headerPainter.width + 16;
    final headerHeight = headerPainter.height + 8;

    //окошко заголовка
    final Path headerBox = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(
            -width * 0.5, -height - headerHeight, headerWidth, headerHeight),
        topLeft: const Radius.circular(8),
      ))
      ..close();

    return headerBox;
  }
}
