import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/singletons/stage.dart';
import 'package:npdart/core/utils/step.dart';

final scenes = {
  'root': Scene(
    description: 'Тестовая сцена',
    script: () async {
      final background = Image.asset(
        'assets/backgrounds/scenery1.jpg',
        fit: BoxFit.cover,
      );

      final oleg = Lena();
      final sanya = Lena();

      if (!await step()) return;
      Stage().setBackground(background);

      sanya.enterStage();
      sanya.moveTo(const Offset(0.3, 0.5));

      oleg.enterStage();
      oleg.moveTo(const Offset(0, 0.5));
      oleg.scale = 1.2;

      if (!await step()) return;
      oleg.say('Hello, world!');
      oleg.scale = 1.2;
      oleg.depth = 0.5;
      if (!await step()) return;

      Stage().showChoices({
        Choice(
            label: 'Выбор 1', callback: () => oleg.say('Ты выбрал вариант 1')),
        Choice(
            label: 'Выбор 2', callback: () => sanya.say('Ты выбрал вариант 2')),
      });

      if (!await step()) return;
      oleg.leaveScene();
      if (!await step()) return;
      sanya.leaveScene();
      if (!await step()) return;
      Stage().loadScene('scene1');
    },
  ),
  'scene1': Scene(
      script: () async {
        if (!await step()) return;
        final background = Image.asset(
          'assets/backgrounds/scenery2.jpg',
          fit: BoxFit.cover,
        );
        final oleg = Lena();
        oleg.say('test');
        Stage().setBackground(background);
        if (!await step()) return;
        Stage().loadScene('root');

        if (!await step()) return;
      },
      description: "Поле")
};
