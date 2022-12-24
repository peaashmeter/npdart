import 'package:flutter/material.dart';

///Расширение класса [Director] для связываения идентификаторов с данными: строки, заголовки, действия
mixin Binding {
  //TODO: вынести загрузку идентификаторов в отдельный класс

  final Map<String, Color> _colors = {
    'pushkin': Colors.blue,
    'somebody': Colors.red
  };

  final Map<String, String> _headers = {
    'somebody': 'Какой-то чел',
    'pushkin': 'Александр Сергеевич'
  };

  final Map<String, String> _strings = {
    'onegin':
        '''​Мой дядя самых честных правил, 😂 когда не в шутку занемог, он уважать себя заставил и лучше выдумать не мог. Его пример другим наука; но, боже мой, какая скука с больным сидеть и день и ночь, не отходя ни шагу прочь! Какое низкое коварство полуживого забавлять, ему подушки поправлять, печально подносить лекарство, вздыхать и думать про себя: когда же черт возьмет тебя!''',
    's2': 'ы',
  };

  ///Возвращает цвет заголовка по его айди.
  Color getColor(String? id) {
    if (id == null) return Colors.white;
    assert(_colors.containsKey(id),
        'Binding table does not contain color with id $id.');
    return (_colors[id] ?? Colors.white);
  }

  ///Возвращает заголовок по его айди.
  String getHeader(String? id) {
    if (id == null) return '';
    assert(_headers.containsKey(id),
        'Binding table does not contain header with id $id.');
    return (_headers[id] ?? '');
  }

  ///Возвращает строку по её айди.
  String getString(String? id) {
    if (id == null) return '';
    assert(_strings.containsKey(id),
        'Binding table does not contain string with id $id.');
    return (_strings[id] ?? '');
  }
}
