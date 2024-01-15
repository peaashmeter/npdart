import 'package:easy_localization/easy_localization.dart';
import 'package:oneday/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuOptions { newGame, lastSave, support }

final menuScene = Scene(script: (stage, state) async {
  final greenfield = Image.asset(
    'assets/backgrounds/greenfield.png',
    fit: BoxFit.cover,
  );

  final narrator = Narrator(stage);
  stage.setBackground(greenfield);
  narrator.say('menu_verse'.tr());

  await stage.waitForInput();
  stage.setVerse(null);

  stage.showChoices({
    Choice(label: 'new_game'.tr(), callback: () => MenuOptions.newGame),
    Choice(label: 'continue'.tr(), callback: () => MenuOptions.lastSave),
    Choice(
        label: 'support'.tr(),
        callback: () {
          launchUrl(Uri.parse('https://boosty.to/peaashmeter'));
          return MenuOptions.support;
        }),
  });

  final result = ((await stage.waitForInput()) as DialogOptionEvent).result;

  if (result == MenuOptions.newGame) {
    return state.loadScene('root').doNotSave().doNotMarkVisited();
  } else if (result == MenuOptions.support) {
    return state.loadScene('menu').doNotSave().doNotMarkVisited();
  }

  final saveData = await getDefaultInitialSaveData(state.preferences);
  final sceneId = saveData.sceneId;

  return state.loadScene(sceneId).doNotSave().doNotMarkVisited();
});
