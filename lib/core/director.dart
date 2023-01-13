import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/binding.dart';
import 'package:visual_novel/core/game_state.dart';
import 'package:visual_novel/core/preferences.dart';

import 'loader.dart';

///Синглтон, который отвечает за все основное взаимодействие с игрой
class Director with Binding, GameState {
  ///Инстанс синглтона
  static Director? _instance;

  Preferences _preferences;

  Preferences get preferences => _preferences;

  ///Точка доступа к единственному объекту класса [Director]
  factory Director() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = Director._init();
      return _instance!;
    }
  }

  Director._init() : _preferences = const Preferences();

  ///Выполняет действие с указанным id. Возвращает false, если возникла ошибка.
  Future<bool> runAction(String? id, List? args) async {
    final f = getFunctionById(id);

    try {
      await Function.apply(f, args);
    } on TypeError catch (e) {
      if (kDebugMode) {
        print('''
Exception $e while trying to call a function with id $id.
It usually happens when unacceptable arguments are passed.
In this case, the function has a runtime type ${f.runtimeType}, and the args are $args.''');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Exception $e while trying to call function with id $id.');
      }
      return false;
    }
    return true;
  }

  ///Changes the game state to the one described in a scene with [id].
  void setScene(String? id) {
    currentSceneId.value = id;
    final scene = getSceneById(id);

    //Change current state only if the new state exists.
    background.value = scene.background ?? background.value;
    music.value = scene.music ?? music.value;
    sprites.value = scene.sprites ?? sprites.value;
    nextScene.value = scene.nextScene ?? nextScene.value;
    onLeaveActionId.value = scene.onLeaveActionId ?? onLeaveActionId.value;
    onLoadActionId.value = scene.onLoadActionId ?? onLoadActionId.value;
    choices.value = scene.choices ?? choices.value;
    verse.value = scene.verse ?? verse.value;
  }

  void setPreferences(Preferences newPrefs) {
    _preferences = newPrefs;
  }

  ///Load the game from a save file, or load initialScene from [Preferences],
  ///if the former is not available.
  Future<void> loadSave() async {
    final json = await SaveLoader().loadSaveFile();
    if (json != null) {
      loadStateFromJson(json);
    } else {
      setScene(_preferences.initialScene);
    }
  }
}
