import 'package:flutter/material.dart';

TextPainter getHeaderPainter(String header, TextStyle style) {
  final headerPainter = TextPainter()
    ..textDirection = TextDirection.ltr
    ..text = TextSpan(text: header, style: style);
  return headerPainter;
}
