import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/singletons/stage.dart';

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

      await Stage().waitForInput();
      Stage().setBackground(background);

      sanya.enterScene();
      sanya.moveTo(const Offset(0.3, 0.5));

      oleg.enterScene();
      oleg.moveTo(const Offset(0, 0.5));
      oleg.scale = 1.2;

      await Stage().waitForInput();
      oleg.say('Hello, world!');
      oleg.scale = 1.2;
      oleg.depth = 0.5;
      await Stage().waitForInput();

      Stage().showChoices({
        Choice(
            label: 'Выбор 1', callback: () => oleg.say('Ты выбрал вариант 1')),
        Choice(
            label: 'Выбор 2', callback: () => sanya.say('Ты выбрал вариант 2')),
      });

      await Stage().waitForInput();
      oleg.leaveScene();
      await Stage().waitForInput();
      sanya.leaveScene();
      await Stage().waitForInput();
      Stage().loadScene('scene1');
    },
  ),
  'scene1': Scene(
      script: () async {
        await Stage().waitForInput();
        final background = Image.asset(
          'assets/backgrounds/scenery2.jpg',
          fit: BoxFit.cover,
        );
        Stage().setBackground(background);
        await Stage().waitForInput();
        Stage().loadScene('root');
      },
      description: "Поле")
};
