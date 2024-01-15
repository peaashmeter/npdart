import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///A phrase that can be printed to the textbox of a scene.
///
///Note that a [color] will be applied to a [header], but not to a [string].
class Verse extends Equatable {
  final String header;
  final String string;
  final Color color;

  const Verse(this.header, this.string, this.color);

  @override
  List<Object?> get props => [header, string, color];
}
