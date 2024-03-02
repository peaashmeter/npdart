import 'package:flutter/material.dart';
import 'textpainter.dart';

///Painter for the verse box and the header
class TextShape extends CustomPainter {
  final double _width;

  final String _header;

  final TextStyle _headerStyle;

  final double textBoxHeight;

  TextShape(this._width, this._header, this._headerStyle, this.textBoxHeight);

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

    //text box
    final Path textBox = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
              center: Offset(0, -textBoxHeight * 0.5),
              width: _width,
              height: textBoxHeight),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
          topRight: const Radius.circular(8),
        ),
      )
      ..close();

    var path = textBox;
    if (_header.isNotEmpty) {
      //header box
      final headerBox = _getHeaderPath(_width);
      path = Path.combine(PathOperation.union, textBox, headerBox);
    }

    canvas.drawPath(path, fill);
    canvas.drawPath(path, outerStroke);
    canvas.drawPath(path, stroke);

    if (_header.isNotEmpty) {
      final headerPainter = getHeaderPainter(_header, _headerStyle);
      headerPainter.layout();

      final headerHeight = headerPainter.height + 8;
      final headerPosition =
          Offset(-_width * 0.5, -textBoxHeight) + Offset(8, 8 - headerHeight);

      headerPainter.paint(canvas, headerPosition);
    }
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
        Rect.fromLTWH(-width * 0.5, -textBoxHeight - headerHeight, headerWidth,
            headerHeight),
        topLeft: const Radius.circular(8),
      ))
      ..close();

    return headerBox;
  }
}
