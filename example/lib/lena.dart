import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/stage.dart';

class Lena extends Character {
  Lena(Stage stage)
      : super(
            stage: stage,
            color: Colors.red,
            name: 'Олег',
            widget: Image.asset('assets/sprites/lena.png'));
}
