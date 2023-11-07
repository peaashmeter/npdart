import 'package:flutter/material.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/audio.dart';

final scenes = {
  'root': Scene(
    description: 'Тестовая сцена',
    script: (stage, state) async {
      final background = Image.asset(
        'assets/backgrounds/scenery1.jpg',
        fit: BoxFit.cover,
      );

      final oleg = Lena(stage);
      final sanya = Lena(stage);

      await stage.waitForInput();
      stage.setBackground(background);

      sanya.enterStage();
      sanya.moveTo(const Offset(0.3, 0.5));

      oleg.enterStage();
      oleg.moveTo(const Offset(0, 0.5));
      oleg.scale = 1.2;

      await stage.waitForInput();
      oleg.say('Hello, world!');
      AudioManager().playSound('sounds/anal.mp3');
      oleg.scale = 1.2;
      oleg.depth = 0.5;
      await stage.waitForInput();

      stage.showChoices({
        Choice(
            label: 'Выбор 1', callback: () => oleg.say('Ты выбрал вариант 1')),
        Choice(
            label: 'Выбор 2', callback: () => sanya.say('Ты выбрал вариант 2')),
      });

      await stage.waitForInput();
      oleg.leaveStage();
      await stage.waitForInput();
      sanya.leaveStage();
      await stage.waitForInput();

      return state.logVerses(stage.verseHistory).loadScene('scene1');
    },
  ),
  'scene1': Scene(
      script: (stage, state) async {
        await stage.waitForInput();
        final background = Image.asset(
          'assets/backgrounds/scenery2.jpg',
          fit: BoxFit.cover,
        );
        final oleg = Lena(stage);
        oleg.say('test');
        stage.setBackground(background);
        await stage.waitForInput();

        await stage.waitForInput();

        return state.logVerses(stage.verseHistory).loadScene('root');
      },
      description: "Поле")
};
