import 'package:flutter/material.dart';

///3 сантиметра
const height = 114.0;

TextPainter _getHeaderPainter(String header, [Color color = Colors.white]) {
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

    final headerPainter = _getHeaderPainter(_header, _headerColor);
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

///Отрисовщик формы для текста
class TextShape extends CustomPainter {
  ///размер экрана
  final double _width;

  final String _header;

  //ширина окошка с текстом
  late final width = _width * 0.7;

  TextShape(this._width, this._header);

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
              center: const Offset(0, -height * 0.5),
              width: width,
              height: height),
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
    TextPainter headerPainter = _getHeaderPainter(_header);

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
