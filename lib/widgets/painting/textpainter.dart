import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';

TextPainter getHeaderPainter(String header, [Color color = Colors.white]) {
  final headerPainter = TextPainter()
    ..textDirection = TextDirection.ltr
    ..text = TextSpan(
        text: header,
        style: TextStyle(fontSize: 20, color: color, shadows: const [
          Shadow(
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ]));
  return headerPainter;
}

///Отрисовщик текста в форме
class CustomTextPainter extends CustomPainter {
  ///размер экрана
  final double _width;

  final String _text;
  final String _header;

  final Color _headerColor;

  late final height = Director().preferences.textBoxHeight;

  CustomTextPainter(
    this._width,
    this._text,
    this._header,
    this._headerColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final width = _width * 0.7;

    //расчет текста
    final textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
          text: _text,
          style: TextStyle(
              fontSize: 20,
              color: Colors.yellow[100],
              shadows: const [
                Shadow(
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ]));

    textPainter.layout(maxWidth: width - 16);
    final textPosition = Offset(-width * 0.5, -height) + const Offset(8, 8);

    final headerPainter = getHeaderPainter(_header, _headerColor);
    headerPainter.layout();

    final headerHeight = headerPainter.height + 8;
    final headerPosition =
        Offset(-width * 0.5, -height) + Offset(8, 8 - headerHeight);

    headerPainter.paint(canvas, headerPosition);
    textPainter.paint(canvas, textPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
