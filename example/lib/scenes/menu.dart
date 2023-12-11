import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
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
  var choice = MenuOptions.lastSave;

  stage.showChoices({
    Choice(
        label: 'new_game'.tr(),
        callback: () {
          choice = MenuOptions.newGame;
        }),
    Choice(label: 'continue'.tr(), callback: () {}),
    Choice(
        label: 'support'.tr(),
        callback: () {
          launchUrl(Uri.parse('https://boosty.to/peaashmeter'));
          choice = MenuOptions.support;
        }),
  });

  await stage.waitForInput();

  if (choice == MenuOptions.newGame) {
    return state.loadScene('root').doNotSave();
  } else if (choice == MenuOptions.support) {
    return state.loadScene('menu').doNotSave();
  }

  final saveData = await getDefaultInitialSaveData(state.preferences);
  final sceneId = saveData.sceneId;

  return state.loadScene(sceneId).doNotSave();
});
