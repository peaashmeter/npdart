import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final dream2Beginning = Scene(script: (stage, state) async {
  final narrator = Narrator(stage);

  await stage.waitForInput();
  narrator.say('ellipsis'.tr());

  state.audio.playBackgroundSound('assets/ost/dream.mp3');

  await stage.waitForInput();
  narrator.say('dream1'.tr());
  await stage.waitForInput();
  narrator.say('dream2'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('dream3v2'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('dream4v2'.tr());
  await stage.waitForInput();

  narrator.say('dream5v2'.tr());
  await stage.waitForInput();

  narrator.say('dream6v2'.tr());
  await stage.waitForInput();

  narrator.say('dream7v2'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();
  narrator.say('dream8'.tr());
  await stage.waitForInput();
  narrator.say('dream9'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('fox1');
});

final dream2FoxDialog = Scene(script: (stage, state) async {
  final greenfield = Image.asset(
    'assets/backgrounds/greenfield.png',
    fit: BoxFit.cover,
  );
  final autumn = Image.asset(
    'assets/backgrounds/autumn.png',
    fit: BoxFit.cover,
  );

  final me = Me(stage);
  var fox = Megami(stage);
  final narrator = Narrator(stage);

  await stage.waitForInput();

  state.audio.playBackgroundSound('assets/ost/megami.mp3');

  stage.setBackground(greenfield);
  narrator.say('d2s1'.tr());
  await stage.waitForInput();

  narrator.say('d2s2'.tr());
  fox.enterStage();
  await stage.waitForInput();

  narrator.say('d2s3'.tr());
  await stage.waitForInput();

  narrator.say('d2s4'.tr());
  await stage.waitForInput();

  narrator.say('d2s5'.tr());
  await stage.waitForInput();

  narrator.say('d2s6'.tr());
  await stage.waitForInput();

  fox.say('fox1'.tr());
  await stage.waitForInput();

  me.say('fox2'.tr());
  await stage.waitForInput();

  narrator.say('fox3'.tr());
  await stage.waitForInput();

  fox.say('fox4'.tr());
  await stage.waitForInput();

  me.say('fox5'.tr());
  await stage.waitForInput();

  fox.say('fox6'.tr());
  await stage.waitForInput();

  stage.setBackground(Container(
    color: Colors.black,
  ));
  fox.leaveStage();
  await stage.waitForInput();

  fox.say('fox7'.tr());
  await stage.waitForInput();

  fox.say('fox8'.tr());
  await stage.waitForInput();

  stage.setBackground(autumn);
  fox = Megami(stage);
  fox.enterStage();
  await stage.waitForInput();

  narrator.say('fox9'.tr());
  await stage.waitForInput();

  me.say('fox10'.tr());
  await stage.waitForInput();

  fox.say('fox11'.tr());
  await stage.waitForInput();

  narrator.say('fox12'.tr());
  await stage.waitForInput();

  me.say('fox13'.tr());
  await stage.waitForInput();

  fox.say('fox14'.tr());
  await stage.waitForInput();

  me.say('fox15'.tr());
  await stage.waitForInput();

  narrator.say('fox16'.tr());
  await stage.waitForInput();

  fox.say('fox17'.tr());
  await stage.waitForInput();

  narrator.say('fox18'.tr());
  await stage.waitForInput();

  me.say('fox19'.tr());
  await stage.waitForInput();

  fox.say('fox20'.tr());
  await stage.waitForInput();

  narrator.say('fox21'.tr());
  await stage.waitForInput();

  fox.say('fox22'.tr());
  await stage.waitForInput();

  narrator.say('fox23'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('awakening2');
});
