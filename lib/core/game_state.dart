import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/verse.dart';

///Расширение класса [Director] для манипуляций с игровым состоянием
mixin GameState {
  ///Здесь хранятся все игровые переменные, идентификация по айди
  final Map<String, dynamic> _variables = {};

  String? currentSceneId = 'scene1';

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

  //TODO: вообще убрать пересылку сцены в отрисовку, сделать так, чтобы виджеты зависели только от конкретных частей игрового состояния
  @deprecated
  Scene setScene(String? id) {
    currentSceneId = id;
    final scene = Director().getSceneById(id);
    //Change current state only if the new state exists.
    background.value = scene.background ?? background.value;
    music.value = scene.music ?? music.value;
    sprites.value = scene.sprites ?? sprites.value;
    nextScene.value = scene.nextScene ?? nextScene.value;
    onLeaveActionId.value = scene.onLeaveActionId ?? onLeaveActionId.value;
    onLoadActionId.value = scene.onLoadActionId ?? onLoadActionId.value;
    choices.value = scene.choices ?? choices.value;
    verse.value = scene.verse ?? verse.value;

    final newScene = _createSceneFromState();
    Director().sceneHandler.requestSceneChange(newScene);
    return newScene;
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

  @deprecated
  Scene _createSceneFromState() {
    return Scene(
        onLeaveActionId: onLeaveActionId.value,
        onLoadActionId: onLoadActionId.value,
        sprites: sprites.value,
        background: background.value,
        music: music.value,
        nextScene: nextScene.value,
        choices: choices.value,
        verse: verse.value);
  }
}
