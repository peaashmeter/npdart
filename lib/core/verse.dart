import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///Информация, выводимая в текстовом блоке сцены
class Verse extends Equatable {
  final String header;
  final String string;
  final Color color;

  const Verse(this.header, this.string, this.color);

  @override
  List<Object?> get props => [header, string, color];
}
