import 'package:easy_localization/easy_localization.dart';
import 'package:example/characters.dart';
import 'package:flutter/material.dart';
import 'package:npdart/npdart.dart';

final day2Room = Scene(script: (stage, state) async {
  final bedroom = Image.asset(
    'assets/backgrounds/bedroom.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final me = Me(stage);

  await stage.waitForInput();

  state.audio.playBackgroundSound('assets/ost/routine.mp3');

  stage.setBackground(bedroom);
  narrator.say('awakening1'.tr());
  await stage.waitForInput();
  narrator.say('awakening2'.tr());
  await stage.waitForInput();
  me.say('awakening_thought1'.tr());
  await stage.waitForInput();
  me.say('awakening_thought2'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_1'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_2'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_3'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_4'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_5'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_6'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_7'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_8'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_9'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('kitchen3');
});

final day2Kitchen1 = Scene(script: (stage, state) async {
  final kitchen = Image.asset(
    'assets/backgrounds/kitchen.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  final me = Me(stage);
  final alex = Alexey(stage);

  await stage.waitForInput();

  state.audio.playBackgroundSound('assets/ost/routine.mp3');

  stage.setBackground(kitchen);
  alex.enterStage();
  narrator.say('awakening2_10'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_11'.tr());
  await stage.waitForInput();

  me.say('awakening2_12'.tr());
  await stage.waitForInput();

  alex.say('awakening2_13'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  state.audio.playSound('assets/sounds/rampage.wav', volume: 0.2);
  await stage.waitForInput();

  narrator.say('awakening2_14'.tr());
  await stage.waitForInput();

  me.say('awakening2_15'.tr());
  await stage.waitForInput();

  narrator.say('awakening2_16'.tr());
  await stage.waitForInput();

  alex.say('awakening2_17'.tr());
  await stage.waitForInput();

  me.say('awakening2_18'.tr());
  await stage.waitForInput();

  alex.say('awakening2_19'.tr());
  await stage.waitForInput();

  me.say('awakening2_20'.tr());
  await stage.waitForInput();

  alex.say('awakening2_21'.tr());
  await stage.waitForInput();

  alex.say('awakening2_22'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('street3');
});

final day2Street1 = Scene(script: (stage, state) async {
  final street = Image.asset(
    'assets/backgrounds/street.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);

  await stage.waitForInput();
  state.audio.playBackgroundSound('assets/ost/street.mp3');
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
  narrator.say('godlike1'.tr());
  await stage.waitForInput();
  narrator.say('godlike2'.tr());
  await stage.waitForInput();
  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('shawarma2');
});

final day2ShawarmaStore = Scene(script: (stage, state) async {
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
  aldiyar.say('shawarma_d2_question'.tr());
  await stage.waitForInput();

  var spicyCounter = state.getData('spicyCounter');

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
          if (spicyCounter is int) {
            spicyCounter = (spicyCounter as int) + 1;
          }
          await stage.waitForInput();
        }),
  });

  await stage.waitForInput();
  await stage.waitForInput();

  me.say('shawarma_d2_sad'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d2_aldiyar1'.tr());
  await stage.waitForInput();

  narrator.say('shawarma_d2_aldiyar2'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_d2_payment'.tr());
  await stage.waitForInput();

  me.say('shawarma_d2_terminal'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_knowledge1'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_knowledge2'.tr());
  await stage.waitForInput();

  aldiyar.say('shawarma_knowledge3'.tr());
  await stage.waitForInput();

  return state
      .logVerses(stage.verseHistory)
      .setData('spicyCounter', spicyCounter ?? 0)
      .loadScene('street4');
});

final day2Street2 = Scene(script: (stage, state) async {
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

  return state.logVerses(stage.verseHistory).loadScene('kitchen4');
});

final day2Kitchen2 = Scene(script: (stage, state) async {
  final kitchen = Image.asset(
    'assets/backgrounds/kitchen.png',
    fit: BoxFit.cover,
  );

  final narrator = Narrator(stage);
  final alex = Alexey(stage);
  final me = Me(stage);
  await stage.waitForInput();

  state.audio.playBackgroundSound('assets/ost/routine.mp3');

  stage.setBackground(kitchen);
  await stage.waitForInput();

  me.say('d2_alexey1'.tr());
  await stage.waitForInput();

  alex.enterStage();
  narrator.say('d2_alexey2'.tr());
  await stage.waitForInput();

  me.say('d2_alexey3'.tr());
  await stage.waitForInput();

  alex.say('d2_alexey4'.tr());
  await stage.waitForInput();

  me.say('d2_alexey5'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey7'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey8'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('day2_end');
});

final day2Ending = Scene(script: (stage, state) async {
  final shawarma = Image.asset(
    'assets/backgrounds/shawarma.png',
    fit: BoxFit.cover,
  );
  final narrator = Narrator(stage);
  await stage.waitForInput();

  stage.setBackground(shawarma);

  narrator.say('d1_alexey9'.tr());
  await stage.waitForInput();

  narrator.say('d1_alexey10'.tr());
  await stage.waitForInput();

  narrator.say('ellipsis'.tr());
  state.audio.smoothlyStopBackground(const Duration(milliseconds: 500));
  stage.setBackground(Container(
    color: Colors.black,
  ));
  await stage.waitForInput();

  narrator.say('d2_ending'.tr());
  await stage.waitForInput();

  return state.logVerses(stage.verseHistory).loadScene('dream3');
});
