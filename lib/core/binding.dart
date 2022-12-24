import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';

///Расширение класса [Director] для связываения идентификаторов с данными: строки, заголовки, действия
mixin Binding {
  //TODO: вынести загрузку идентификаторов в отдельный класс

  final Map<String, Color> _colors = {
    'pushkin': Colors.blue.shade300,
    'somebody': Colors.red.shade300
  };

  final Map<String, String> _strings = {
    'somebody': 'Какой-то чел',
    'pushkin': 'Александр Сергеевич',
    'onegin':
        '''​Мой дядя самых честных правил, 😂 когда не в шутку занемог, он уважать себя заставил и лучше выдумать не мог. Его пример другим наука; но, боже мой, какая скука с больным сидеть и день и ночь, не отходя ни шагу прочь! Какое низкое коварство полуживого забавлять, ему подушки поправлять, печально подносить лекарство, вздыхать и думать про себя: когда же черт возьмет тебя!''',
    's2': 'ы',
    'choice1': 'Питон – лучший язык программирования!',
    'choice2': 'Мое мнение полностью выражается следующим символом: 🖕',
  };

  ///Таблица функций, которые вызываются при совершении действия с некоторым айди
  final Map<String, Function> _functions = {
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

  ///Возвращает цвет заголовка из таблицы связывания по его айди.
  Color getColor(String? id) {
    if (id == null) return Colors.white;
    assert(_colors.containsKey(id),
        'Binding table does not contain color with id $id.');
    return (_colors[id] ?? Colors.white);
  }

  ///Возвращает строку из таблицы связывания по её айди.
  String getString(String? id) {
    if (id == null) return '';
    assert(_strings.containsKey(id),
        'Binding table does not contain string with id $id.');
    return (_strings[id] ?? '');
  }

  ///Возвращает функцию из таблицы связывания по её айди.
  Function getFunction(String? id) {
    if (id == null) return () {};
    assert(_functions.containsKey(id),
        'Binding table does not contain function with id $id.');
    return (_functions[id] ?? () {});
  }
}
