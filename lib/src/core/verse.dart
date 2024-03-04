import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///A phrase that can be printed to the textbox of a scene.
///
///Note that a [color] will be applied to a [header], but not to a [string].
///It's possible to use [richString] instead of a [string]
///to access the features available to [RichText].
class Verse extends Equatable {
  final String header;
  final String? string;
  final InlineSpan? richString;
  final Color color;

  const Verse(
      {required this.header,
      required this.color,
      this.string,
      this.richString});

  @override
  List<Object?> get props => [header, string, color];
}
