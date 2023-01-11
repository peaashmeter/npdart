import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/verse.dart';
import 'package:visual_novel/tudasuda/editor_game.dart';
import 'package:visual_novel/tudasuda/level.dart';

///Расширение класса [Director] для связывания идентификаторов с данными,
///которые не относятся к игровому состоянию
mixin Binding {
  //TODO: вынести загрузку идентификаторов в отдельный класс

  final _colors = <String, Color>{
    'pushkin': Colors.blue.shade300,
    'somebody': Colors.red.shade300
  };

  final _strings = <String, String>{
    'somebody': 'Какой-то чел',
    'pushkin': 'Александр Сергеевич',
    'onegin':
        '''​Мой дядя самых честных правил, 😂 когда не в шутку занемог, он уважать себя заставил и лучше выдумать не мог. Его пример другим наука; но, боже мой, какая скука с больным сидеть и день и ночь, не отходя ни шагу прочь! Какое низкое коварство полуживого забавлять, ему подушки поправлять, печально подносить лекарство, вздыхать и думать про себя: когда же черт возьмет тебя!''',
    's2': 'ы',
    'choice1': 'Питон – лучший язык программирования!',
    'choice2': 'Мое мнение полностью выражается следующим символом: 🖕',
  };

  ///Все игровые сцены; инициализируются при запуске игры
  final _scenes = <String, Scene>{
    'test_scene': Scene(verse: Verse(), nextScene: 'test_scene'),
    'scene1': Scene(
        verse: Verse(headerId: 'pushkin', stringId: 'onegin'),
        background: 'scenery1.jpg',
        sprites: {},
        choices: ['choice1', 'choice2']),
    'scene2': Scene(
      verse: Verse(headerId: 'somebody', stringId: 's2'),
      background: 'scenery1.jpg',
      nextScene: 'scene3',
      choices: [],
      sprites: {
        'left': 'catgirl_smiling.png',
      },
    ),
    'scene3': Scene(
      verse: Verse(headerId: 'somebody', stringId: 's2'),
      background: 'tudasuda',
      nextScene: 'scene1',
      sprites: {
        'left': 'catgirl_surprised.png',
      },
    )
  };

  ///Таблица функций, которые вызываются при совершении действия с некоторым айди
  final _functions = <String, Function>{
    'next_scene': (Scene? caller) {
      assert(caller != null);
      assert(caller!.nextScene != null);
      Director().setScene(caller!.nextScene!);
    },
    'choice1': () {
      Director().setScene('scene2');
    },
    'choice2': () {}
  };

  ///A table of backgrounds, except plain images.
  ///Every request for a background should at first trying finding one here.
  final _backgrounds = <String, Widget>{
    'blank': Container(
      color: Colors.black,
      key: UniqueKey(),
    ),
    //TODO: убрать эти приколы
    'tudasuda': const EditorGame(
        level: Level(
            width: 4,
            height: 4,
            playerPos: Point(0, 0),
            mobs: [],
            title: 'Бесконечное лето'))
  };

  ///Возвращает цвет заголовка из таблицы связывания по его айди.
  Color getColorById(String? id) {
    if (id == null) return Colors.white;
    assert(_colors.containsKey(id),
        'Binding table does not contain color with id $id.');
    return (_colors[id] ?? Colors.white);
  }

  ///Возвращает строку из таблицы связывания по её айди.
  String getStringById(String? id) {
    if (id == null) return '';
    assert(_strings.containsKey(id),
        'Binding table does not contain string with id $id.');
    return (_strings[id] ?? '');
  }

  ///Возвращает сцену из таблицы связывания по её айди.
  Scene getSceneById(String? id) {
    assert(_scenes.containsKey(id));
    return _scenes[id]!;
  }

  ///Возвращает функцию из таблицы связывания по её айди.
  Function getFunctionById(String? id) {
    if (id == null) return () {};
    assert(_functions.containsKey(id),
        'Binding table does not contain function with id $id.');
    return (_functions[id] ?? () {});
  }

  ///Tries to find a request background in the binding table.
  ///If fails, tries to load an image from assets.
  ///Returns a black container if [id] is null.
  Widget getBackgroundById(String? id) {
    if (id == null) return _backgrounds['blank']!;
    if (_backgrounds.containsKey(id)) return _backgrounds[id]!;
    return Image.asset(
      '${Director().preferences.backgroundsRoot}$id',
      key: ValueKey(id),
      fit: BoxFit.cover,
    );
  }
}
