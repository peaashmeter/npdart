import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/verse.dart';

///Расширение класса [Director] для манипуляций с игровым состоянием
mixin GameState {
  ///Здесь хранятся все игровые переменные, идентификация по айди
  final Map<String, dynamic> _variables = {};

  final ValueNotifier<String?> _currentSceneId = ValueNotifier(null);

  ValueNotifier<String?> get currentSceneId => _currentSceneId;

  final ValueNotifier<String?> _background = ValueNotifier(null);

  ValueNotifier<String?> get background => _background;

  final ValueNotifier<String?> _music = ValueNotifier(null);

  ValueNotifier<String?> get music => _music;

  final ValueNotifier<Map<String, String>?> _sprites = ValueNotifier(null);

  ValueNotifier<Map<String, String>?> get sprites => _sprites;

  final ValueNotifier<String?> _nextScene = ValueNotifier(null);

  ValueNotifier<String?> get nextScene => _nextScene;

  final ValueNotifier<String?> _onLoadActionId = ValueNotifier(null);

  ValueNotifier<String?> get onLoadActionId => _onLoadActionId;

  final ValueNotifier<String?> _onLeaveActionId = ValueNotifier(null);

  ValueNotifier<String?> get onLeaveActionId => _onLeaveActionId;

  final ValueNotifier<List<String>?> _choices = ValueNotifier(null);

  ValueNotifier<List<String>?> get choices => _choices;

  final ValueNotifier<Verse?> _verse = ValueNotifier(null);

  ValueNotifier<Verse?> get verse => _verse;

  ///Возвращает игровую переменную по её айди.
  T getVariable<T>(String id) {
    assert(_variables.containsKey(id));
    return _variables[id]!;
  }

  ///Присваивает значение [value] переменной по её айди.
  ///Допустимые типы переменных: [int], [double], [bool], [String],
  ///[List]
  void setVariable<T>(String id, T value) {
    final List<Type> scalarTypes = [
      int,
      double,
      bool,
      String,
    ];
    if (value is! List) {
      assert(scalarTypes.contains(value.runtimeType),
          'Cannot set variable of type ${value.runtimeType}.');
    } else {
      assert(
          value.every((element) => scalarTypes.contains(element.runtimeType)),
          'Cannot set variable of type ${value.runtimeType}.');
    }

    _variables[id] = value;
  }

  String getJsonFromState() {
    final data = {
      'variables': _variables,
      'currentSceneId': _currentSceneId.value
    };

    return jsonEncode(data);
  }

  void loadStateFromJson(String json) {
    final data = jsonDecode(json);
    final id = data['currentSceneId'];
    Director().setScene(id);

    _variables.clear();
    _variables.addAll(data['variables']);
  }
}
