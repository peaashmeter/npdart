import 'package:flutter/material.dart';

//3 сантиметра
const height = 114.0;

class TextShape extends CustomPainter {
  ///размер экрана
  final double _width;

  final String header;

  TextShape(this._width, this.header);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = Colors.black.withOpacity(0.8);
    final Paint stroke = Paint()
      ..color = Colors.teal.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint outerStroke = Paint()
      ..color = Colors.teal.shade900.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    //размеры самого окошка для текста
    final width = _width * 0.7;

    //расчет заголовка
    final headerPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
          text: header,
          style: const TextStyle(fontSize: 18, shadows: [
            Shadow(
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ]));

    headerPainter.layout();

    final headerWidth = headerPainter.width + 16;
    final headerHeight = headerPainter.height + 8;

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
    final Path headerBox = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(
            -width * 0.5, -height - headerHeight, headerWidth, headerHeight),
        topLeft: const Radius.circular(8),
      ))
      ..close();

    final path = Path.combine(PathOperation.union, textBox, headerBox);

    canvas.drawPath(path, fill);
    canvas.drawPath(path, outerStroke);
    canvas.drawPath(path, stroke);

    // //разделитель между заголовком и текстом
    // final Paint dividerStroke = Paint()
    //   ..color = Colors.white.withOpacity(0.8)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1;

    // final Path divider = Path()
    //   ..moveTo(-width * 0.5 + 8, -height)
    //   ..lineTo(-width * 0.5 + headerWidth - 8, -height)
    //   ..close();
    // canvas.drawPath(divider, dividerStroke);

    final headerPosition =
        Offset(-width * 0.5, -height) + Offset(8, 8 - headerHeight);

    headerPainter.paint(canvas, headerPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomTextPainter extends CustomPainter {
  ///размер экрана
  final double _width;

  final String text;

  CustomTextPainter(this._width, this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final width = _width * 0.7;

    //расчет текста
    final textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 18,
              color: Colors.yellow[100],
              shadows: const [
                Shadow(
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ]));

    textPainter.layout(maxWidth: width - 16);

    final textPosition = Offset(-width * 0.5, -height) + const Offset(8, 8);

    textPainter.paint(canvas, textPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
