import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final nothing = Scene(
  script: (stage, state) async {
    final narrator = Narrator(stage);

    await stage.waitForInput();
    narrator.say('ellipsis'.tr());
    state.audio.playBackgroundSound('assets/ost/dream.mp3');
    await stage.waitForInput();
    narrator.say('dream1'.tr());
    await stage.waitForInput();
    narrator.say('dream2'.tr());
    await stage.waitForInput();
    narrator.say('dream3'.tr());
    await stage.waitForInput();
    narrator.say('dream4'.tr());
    await stage.waitForInput();
    narrator.say('dream5'.tr());
    await stage.waitForInput();
    narrator.say('dream6'.tr());
    await stage.waitForInput();
    narrator.say('dream7'.tr());
    await stage.waitForInput();
    narrator.say('ellipsis'.tr());
    await stage.waitForInput();
    narrator.say('dream8'.tr());
    await stage.waitForInput();
    narrator.say('dream9'.tr());
    await stage.waitForInput();

    return state.logVerses(stage.verseHistory).loadScene('planet');
  },
);

final planetDream = Scene(script: (stage, state) async {
  final planet = Image.asset(
    'assets/backgrounds/planet.png',
    fit: BoxFit.cover,
  );
  stage.setBackground(planet);

  final narrator = Narrator(stage);
  narrator.say('d1s1'.tr());
  await stage.waitForInput();
  narrator.say('d1s2'.tr());
  await stage.waitForInput();
  narrator.say('d1s3'.tr());
  await stage.waitForInput();
  narrator.say('d1s4'.tr());
  await stage.waitForInput();
  narrator.say('d1s5'.tr());
  await stage.waitForInput();
  narrator.say('d1s6'.tr());
  await stage.waitForInput();
  narrator.say('d1s7'.tr());
  await stage.waitForInput();
  narrator.say('d1s8'.tr());
  await stage.waitForInput();
  narrator.say('d1s9'.tr());
  await stage.waitForInput();
  stage.setBackground(Container(
    color: Colors.black,
  ));
  narrator.say('d1s10'.tr());
  await stage.waitForInput();
  narrator.say('d1s11'.tr());
  await stage.waitForInput();
  narrator.say('d1s12'.tr());
  await stage.waitForInput();
  narrator.say('ellipsis'.tr());
  state.audio.playSound('assets/sounds/drill.mp3', volume: 0.5);
  await stage.waitForInput();
  narrator.say('eyes_opened'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('awakening1');
});
