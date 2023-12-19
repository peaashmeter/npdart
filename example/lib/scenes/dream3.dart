import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:oneday/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final dream3Beginning = Scene(
  script: (stage, state) async {
    final narrator = Narrator(stage);

    final me = Me(stage);

    await stage.waitForInput();
    narrator.say('ellipsis'.tr());

    state.audio.playBackgroundSound('assets/ost/dream.mp3');
    await stage.waitForInput();
    narrator.say('dream1'.tr());
    await stage.waitForInput();
    narrator.say('dream2'.tr());
    await stage.waitForInput();

    narrator.say('dream3v3'.tr());
    await stage.waitForInput();

    narrator.say('dream4v3'.tr());
    await stage.waitForInput();

    narrator.say('dream5v3'.tr());
    await stage.waitForInput();

    narrator.say('dream6v3'.tr());
    await stage.waitForInput();

    narrator.say('dream7v3'.tr());
    await stage.waitForInput();

    narrator.say('dream8v3'.tr());
    await stage.waitForInput();

    narrator.say('dream9v3'.tr());
    await stage.waitForInput();

    narrator.say('dream10v3'.tr());
    await stage.waitForInput();

    narrator.say('ellipsis'.tr());
    await stage.waitForInput();

    me.say('dream11v3'.tr());
    await stage.waitForInput();

    narrator.say('dream12v3'.tr());
    await stage.waitForInput();

    narrator.say('dream9'.tr());
    await stage.waitForInput();

    return state.logVerses(stage.verseHistory).loadScene('dream3_snow');
  },
);

final dream3Snow = Scene(
  script: (stage, state) async {
    final snowfield = Image.asset(
      'assets/backgrounds/snowfield.png',
      fit: BoxFit.cover,
    );
    final narrator = Narrator(stage);
    final me = Me(stage);
    await stage.waitForInput();
    stage.setBackground(snowfield);
    state.audio.playBackgroundSound('assets/ost/dream.mp3');
    await stage.waitForInput();

    narrator.say('d3s1'.tr());
    await stage.waitForInput();

    narrator.say('d3s2'.tr());
    await stage.waitForInput();

    narrator.say('d3s3'.tr());
    await stage.waitForInput();

    narrator.say('ellipsis'.tr());
    await stage.waitForInput();

    me.say('d3s4'.tr());
    await stage.waitForInput();

    narrator.say('ellipsis'.tr());
    await stage.waitForInput();

    narrator.say('d3s5'.tr());
    await stage.waitForInput();

    narrator.say('ellipsis'.tr());
    await stage.waitForInput();

    narrator.say('d3s6'.tr());
    await stage.waitForInput();

    me.say('d3s7'.tr());
    await stage.waitForInput();

    me.say('ellipsis'.tr());
    await stage.waitForInput();

    me.say('d3s8'.tr());
    await stage.waitForInput();

    narrator.say('d3s9'.tr());
    await stage.waitForInput();

    return state.logVerses(stage.verseHistory).loadScene('dream3_fox');
  },
);

final dream3FoxDialog = Scene(script: (stage, state) async {
  final greenfield = Image.asset(
    'assets/backgrounds/greenfield.png',
    fit: BoxFit.cover,
  );

  final me = Me(stage);
  var fox = Megami(stage);
  final narrator = Narrator(stage);

  await stage.waitForInput();
  for (var i = 0; i < 3; i++) {
    narrator.say('ellipsis'.tr());
    await stage.waitForInput();
    narrator.say('');
    await stage.waitForInput();
  }

  fox.say('d3s10'.tr());
  await stage.waitForInput();

  state.audio.playBackgroundSound('assets/ost/megami.mp3');
  stage.setBackground(greenfield);
  narrator.say('d3s11'.tr());
  await stage.waitForInput();

  fox.enterStage();
  narrator.say('d3s12'.tr());
  await stage.waitForInput();

  me.say('d3s13'.tr());
  await stage.waitForInput();

  fox.say('d3s14'.tr());
  await stage.waitForInput();

  me.say('d3s15'.tr());
  await stage.waitForInput();

  fox.say('d3s16'.tr());
  await stage.waitForInput();

  fox.say('d3s17'.tr());
  await stage.waitForInput();

  narrator.say('d3s18'.tr());
  await stage.waitForInput();

  fox.say('d3s19'.tr());
  await stage.waitForInput();

  narrator.say('d3s20'.tr());
  await stage.waitForInput();

  fox.say('d3s21'.tr());
  await stage.waitForInput();

  me.say('d3s211'.tr());
  await stage.waitForInput();

  fox.say('d3s22'.tr());
  await stage.waitForInput();

  bool foxEnding = false;
  stage.showChoices({
    Choice(label: 'fox_accept'.tr(), callback: () => foxEnding = true),
    Choice(label: 'fox_decline'.tr(), callback: () {})
  });

  await stage.waitForInput();

  if (foxEnding) {
    return state
        .logVerses(stage.verseHistory)
        .loadScene('fox_ending')
        .updatePreferences(state.preferences.copyWith(typingDelay: 70));
  }

  narrator.say('d3s23'.tr());
  await stage.waitForInput();

  narrator.say('d3s24'.tr());
  await stage.waitForInput();

  me.say('d3s25'.tr());
  await stage.waitForInput();

  fox.say('d3s26'.tr());
  await stage.waitForInput();

  me.say('d3s27'.tr());
  await stage.waitForInput();

  fox.say('d3s28'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('day3_room');
});

final foxEnding = Scene(script: (stage, state) async {
  final greenfield = Image.asset(
    'assets/backgrounds/greenfield.png',
    fit: BoxFit.cover,
  );

  final me = Me(stage);
  final narrator = Narrator(stage);

  await stage.waitForInput();

  me.say('fox_ending1'.tr());
  await stage.waitForInput();

  me.say('fox_ending2'.tr());
  stage.setBackground(greenfield);
  await stage.waitForInput();

  me.say('fox_ending3'.tr());
  await stage.waitForInput();

  me.say('fox_ending4'.tr());
  await stage.waitForInput();

  narrator.say('fox_ending5'.tr());
  await stage.waitForInput();

  narrator.say('fox_ending6'.tr());
  await stage.waitForInput();

  return state
      .logVerses(stage.verseHistory)
      .loadScene('fox_ending_comment')
      .updatePreferences(state.preferences.copyWith(typingDelay: 35));
});

final foxEndingComment = Scene(script: (stage, state) async {
  final dev = Developer(stage);
  await stage.waitForInput();

  dev.say('dev_comment1'.tr());
  await stage.waitForInput();

  dev.say('dev_comment2'.tr());
  await stage.waitForInput();

  dev.say('dev_comment3'.tr());
  await stage.waitForInput();

  dev.say('dev_comment4'.tr());
  await stage.waitForInput();

  dev.say('dev_comment5'.tr());
  await stage.waitForInput();

  dev.say('dev_comment6'.tr());
  await stage.waitForInput();

  exit(0);
});
