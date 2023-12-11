import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final day3Room = Scene(script: (stage, state) async {
  final bedroom = Image.asset(
    'assets/backgrounds/bedroom.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final me = Me(stage);
  final alex = Alexey(stage);

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/routine.mp3');
  stage.setBackground(bedroom);
  narrator.say('awakening3_1'.tr());
  await stage.waitForInput();
  narrator.say('awakening3_2'.tr());
  await stage.waitForInput();

  me.say('awakening3_3'.tr());
  await stage.waitForInput();

  alex.say('awakening3_4'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('awakening3_5'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('day3_street1');
});

final day3Street1 = Scene(script: (stage, state) async {
  final street = Image.asset(
    'assets/backgrounds/street.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/street.mp3');
  stage.setBackground(street);

  narrator.say('awakening3_6'.tr());
  await stage.waitForInput();

  narrator.say('awakening3_7'.tr());
  await stage.waitForInput();

  narrator.say('awakening3_8'.tr());
  await stage.waitForInput();

  narrator.say('awakening3_9'.tr());
  await stage.waitForInput();

  narrator.say('awakening3_10'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('day3_shawarma');
});

final day3Shawarma = Scene(script: (stage, state) async {
  final store = Image.asset(
    'assets/backgrounds/store.png',
    fit: BoxFit.cover,
  );

  final aldiyar = Aldiyar(stage);
  final me = Me(stage);

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/timeless.mp3');
  aldiyar.enterStage();
  stage.setBackground(store);
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_1'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_2'.tr());
  await stage.waitForInput();

  final spicyCounter = state.getData('spicyCounter');
  if (spicyCounter == 2) {
    aldiyar.say('shawarma_d3_alexey1'.tr());
    await stage.waitForInput();

    aldiyar.say('shawarma_d3_alexey2'.tr());
    await stage.waitForInput();

    stage.setVerse(null);

    bool trueEnding = false;

    stage.showChoices({
      Choice(label: 'aldiyar_accept'.tr(), callback: () {}),
      Choice(
          label: 'aldiyar_decline'.tr(),
          callback: () {
            trueEnding = true;
          }),
    });
    await stage.waitForInput();

    if (trueEnding) {
      me.say('true_ending1'.tr());
      await stage.waitForInput();

      me.say('true_ending2'.tr());
      await stage.waitForInput();

      return state.logVerses(stage.verseHistory).loadScene('true_ending');
    }
  }

  aldiyar.say('shawarma_d3_3'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_4'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_5'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('obliteration');
});

final trueEnding = Scene(script: (stage, state) async {
  final kitchen = Image.asset(
    'assets/backgrounds/kitchen.png',
    fit: BoxFit.cover,
  );

  final narrator = Narrator(stage);
  final me = Me(stage);
  final alex = Alexey(stage);
  final dev = Developer(stage);

  await stage.waitForInput();

  state.audio.smoothlyStopBackground(const Duration(milliseconds: 1000));

  narrator.say('true_ending3'.tr());
  await stage.waitForInput();

  stage.setBackground(kitchen);
  alex.enterStage();
  narrator.say('true_ending4'.tr());
  await stage.waitForInput();

  narrator.say('true_ending5'.tr());
  await stage.waitForInput();

  me.say('true_ending6'.tr());
  await stage.waitForInput();

  alex.say('true_ending7'.tr());
  await stage.waitForInput();

  narrator.say('true_ending8'.tr());
  await stage.waitForInput();

  alex.say('true_ending9'.tr());
  await stage.waitForInput();

  alex.say('true_ending10'.tr());
  await stage.waitForInput();

  me.say('true_ending11'.tr());
  await stage.waitForInput();

  alex.say('true_ending12'.tr());
  await stage.waitForInput();

  me.say('true_ending13'.tr());
  await stage.waitForInput();

  alex.say('true_ending14'.tr());
  await stage.waitForInput();

  stage.setBackground(Container(
    color: Colors.black,
  ));
  await stage.waitForInput();

  alex.leaveStage();
  await stage.waitForInput();

  dev.say('dev_comment6'.tr());
  await stage.waitForInput();
  exit(0);
});

final obliteration = Scene(script: (stage, state) async {
  final me = Me(stage);
  final aldiyar = Aldiyar(stage);
  final narrator = Narrator(stage);

  final library = Image.asset(
    'assets/backgrounds/library.png',
    fit: BoxFit.cover,
  );

  await stage.waitForInput();
  state.audio.smoothlyStopBackground(const Duration(milliseconds: 1000));

  narrator.say('shawarma_d3_6'.tr());
  await stage.waitForInput();

  aldiyar.enterStage();
  narrator.say('shawarma_d3_7'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_8'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  stage.setBackground(library);
  state.audio.playBackgroundSound('assets/ost/timeless.mp3');
  await stage.waitForInput();

  narrator.say('shawarma_d3_9'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_10'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_11'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_12'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_13'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_14'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_15'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_16'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_17'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_18'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_19'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_20'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_21'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_22'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_23'.tr());
  await stage.waitForInput();

  me.say('shawarma_d3_24'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_25'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_26'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_27'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_28'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_29'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_30'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d3_31'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d3_32'.tr());
  await stage.waitForInput();

  exit(0);
});
