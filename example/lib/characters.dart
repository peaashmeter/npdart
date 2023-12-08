import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/stage.dart';

class Alexey extends Character {
  Alexey(Stage stage)
      : super(
            stage: stage,
            color: Colors.blueGrey,
            name: 'alexey'.tr(),
            widget: Image.asset('assets/sprites/alexey.png'));
}

class Megami extends Character {
  Megami(Stage stage)
      : super(
            stage: stage,
            color: Colors.orange,
            name: 'megami'.tr(),
            widget: Image.asset('assets/sprites/fox.png'));
}

class Aldiyar extends Character {
  Aldiyar(Stage stage)
      : super(
            stage: stage,
            color: Colors.blue,
            name: 'aldiyar'.tr(),
            widget: Image.asset('assets/sprites/merchant.png'));
}

class Me extends Character {
  Me(Stage stage)
      : super(
            stage: stage,
            color: Colors.red,
            name: 'me'.tr(),
            widget: const SizedBox.shrink());
}

class Narrator extends Character {
  Narrator(Stage stage)
      : super(
            stage: stage,
            color: Colors.red,
            name: '',
            widget: const SizedBox.shrink());
}

class Developer extends Character {
  Developer(Stage stage)
      : super(
            stage: stage,
            color: Colors.red,
            name: 'dev'.tr(),
            widget: const SizedBox.shrink());
}
