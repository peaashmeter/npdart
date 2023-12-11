import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final day1Room = Scene(script: (stage, state) async {
  final bedroom = Image.asset(
    'assets/backgrounds/bedroom.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final me = Me(stage);

  stage.setBackground(bedroom);
  state.audio.playBackgroundSound('assets/ost/routine.mp3');
  narrator.say('awakening1'.tr());
  await stage.waitForInput();
  narrator.say('awakening2'.tr());
  await stage.waitForInput();
  me.say('awakening_thought1'.tr());
  await stage.waitForInput();
  me.say('awakening_thought2'.tr());
  await stage.waitForInput();
  narrator.say('awakening3'.tr()); //вышел на кухню
  await stage.waitForInput();
  stage.setBackground(Container(
    color: Colors.black,
  ));
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('kitchen1');
});

final day1Kitchen1 = Scene(script: (stage, state) async {
  final kitchen = Image.asset(
    'assets/backgrounds/kitchen.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final alex = Alexey(stage);
  final me = Me(stage);

  state.audio.playBackgroundSound('assets/ost/routine.mp3');

  stage.setBackground(kitchen);
  narrator.say('awakening4'.tr());
  alex.enterStage();
  await stage.waitForInput();
  narrator.say('awakening5'.tr());
  await stage.waitForInput();
  state.audio.playSound('assets/sounds/rampage.m4a', volume: 0.2);
  await stage.waitForInput();
  narrator.say('awakening6'.tr());
  await stage.waitForInput();
  me.say('d1_dialog1'.tr());
  await stage.waitForInput();
  alex.say('d1_dialog2'.tr());
  await stage.waitForInput();
  narrator.say('d1_dialog2_comment'.tr());
  await stage.waitForInput();
  me.say('d1_dialog3'.tr());
  await stage.waitForInput();
  alex.say('d1_dialog4'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('street1');
});

final day1Street1 = Scene(script: (stage, state) async {
  final street = Image.asset(
    'assets/backgrounds/street.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);

  state.audio.playBackgroundSound('assets/ost/street.mp3');

  await stage.waitForInput();
  stage.setBackground(street);
  narrator.say('street1'.tr());
  await stage.waitForInput();
  narrator.say('street2'.tr());
  await stage.waitForInput();
  narrator.say('street3'.tr());
  await stage.waitForInput();
  narrator.say('street4'.tr());
  await stage.waitForInput();
  narrator.say('street5'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('shawarma1');
});

final day1ShawarmaStore = Scene(script: (stage, state) async {
  final store = Image.asset(
    'assets/backgrounds/store.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final me = Me(stage);
  final aldiyar = Aldiyar(stage);

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/timeless.mp3');

  stage.setBackground(store);
  narrator.say('shawarma1'.tr());
  await stage.waitForInput();
  narrator.say('shawarma2'.tr());
  await stage.waitForInput();
  narrator.say('shawarma3'.tr());
  await stage.waitForInput();

  aldiyar.enterStage();
  aldiyar.say('shawarma_d1'.tr());
  await stage.waitForInput();

  int spicyCounter = 0;

  stage.showChoices({
    Choice(
        label: 'shawarma_d1_choice1'.tr(),
        callback: () async {
          narrator.say('shawarma_d1_choice1_reaction'.tr());
          await stage.waitForInput();
        }),
    Choice(
        label: 'shawarma_d1_choice2'.tr(),
        callback: () async {
          narrator.say('shawarma_d1_choice2_reaction'.tr());
          await stage.waitForInput();
        }),
    Choice(
        label: 'shawarma_d1_choice3'.tr(),
        callback: () async {
          narrator.say('shawarma_d1_choice3_reaction'.tr());
          spicyCounter = 1;
          await stage.waitForInput();
        }),
  });

  await stage.waitForInput();
  await stage.waitForInput();

  aldiyar.say('shawarma_d1_sad'.tr());
  await stage.waitForInput();

  me.say('shawarma_d1_sad_response'.tr());
  await stage.waitForInput();

  narrator.say('aldiyar_grins'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d1_payment'.tr());
  await stage.waitForInput();

  return state
      .logVerses(stage.verseHistory)
      .setData('spicyCounter', spicyCounter)
      .loadScene('street2');
});

final day1Street2 = Scene(script: (stage, state) async {
  final street = Image.asset(
    'assets/backgrounds/street.png',
    fit: BoxFit.cover,
  );

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/street.mp3');
  stage.setBackground(street);
  final narrator = Narrator(stage);
  narrator.say('going_back1'.tr());
  await stage.waitForInput();
  narrator.say('going_back2'.tr());
  await stage.waitForInput();
  narrator.say('going_back3'.tr());
  await stage.waitForInput();
  narrator.say('going_back4'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('kitchen2');
});

final day1Kitchen2 = Scene(script: (stage, state) async {
  final kitchen = Image.asset(
    'assets/backgrounds/kitchen.png',
    fit: BoxFit.cover,
  );

  state.audio.playBackgroundSound('assets/ost/routine.mp3');
  final narrator = Narrator(stage);
  final alex = Alexey(stage);
  final me = Me(stage);
  await stage.waitForInput();

  stage.setBackground(kitchen);
  alex.enterStage();
  await stage.waitForInput();

  narrator.say('d1_alexey1'.tr());
  await stage.waitForInput();

  me.say('d1_alexey2'.tr());
  await stage.waitForInput();

  alex.say('d1_alexey3'.tr());
  await stage.waitForInput();

  if (state.getData('spicyCounter') == 1) {
    narrator.say('d1_alexey4_wrong'.tr());
  } else {
    me.say('d1_alexey4_right'.tr());
  }
  await stage.waitForInput();

  alex.say('d1_alexey5'.tr());
  await stage.waitForInput();

  me.say('d1_alexey6'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey7'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey8'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('day1_end');
});

final day1Ending = Scene(script: (stage, state) async {
  await stage.waitForInput();
  final narrator = Narrator(stage);
  final shawarma = Image.asset(
    'assets/backgrounds/shawarma.png',
    fit: BoxFit.cover,
  );

  stage.setBackground(shawarma);
  narrator.say('d1_alexey9'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey10'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  stage.setBackground(Container(
    color: Colors.black,
  ));

  state.audio.smoothlyStopBackground(const Duration(milliseconds: 300));
  narrator.say('d1_ending1'.tr());
  await stage.waitForInput();

  narrator.say('d1_ending2'.tr());
  await stage.waitForInput();

  narrator.say('d1_ending3'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('dream2');
});
