import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final menuScene = Scene(script: (stage, state) async {
  final greenfield = Image.asset(
    'assets/backgrounds/greenfield.png',
    fit: BoxFit.cover,
  );

  final narrator = Narrator(stage);
  stage.setBackground(greenfield);
  narrator.say('menu_verse'.tr());

  bool newGame = false;

  stage.showChoices({
    Choice(
        label: 'new_game'.tr(),
        callback: () {
          newGame = true;
        }),
    Choice(label: 'continue'.tr(), callback: () {}),
  });

  await stage.waitForInput();

  if (newGame) {
    return state.loadScene('root');
  }

  final saveData = await getDefaultInitialSaveData(state.preferences);
  final sceneId = saveData.sceneId;

  return state.loadScene(sceneId);
});
