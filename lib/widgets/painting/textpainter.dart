import 'package:flutter/material.dart';

TextPainter getHeaderPainter(String header, TextStyle style) {
  final headerPainter = TextPainter()
    ..textDirection = TextDirection.ltr
    ..text = TextSpan(text: header, style: style);
  return headerPainter;
}

///Отрисовщик текста в форме
class CustomTextPainter extends CustomPainter {
  ///размер экрана
  final double _width;

  final String _text;
  final String _header;

  final TextStyle _headerStyle;
  final TextStyle _stringStyle;

  final double textBoxHeight;

  CustomTextPainter(this._width, this._text, this._header, this._headerStyle,
      this._stringStyle, this.textBoxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final width = _width * 0.7;

    //расчет текста
    final textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(text: _text, style: _stringStyle);

    textPainter.layout(maxWidth: width - 16);
    final textPosition =
        Offset(-width * 0.5, -textBoxHeight) + const Offset(8, 8);

    final headerPainter = getHeaderPainter(_header, _headerStyle);
    headerPainter.layout();

    final headerHeight = headerPainter.height + 8;
    final headerPosition =
        Offset(-width * 0.5, -textBoxHeight) + Offset(8, 8 - headerHeight);

    headerPainter.paint(canvas, headerPosition);
    textPainter.paint(canvas, textPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
