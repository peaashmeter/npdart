import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/binding.dart';
import 'package:visual_novel/core/game_state.dart';
import 'package:visual_novel/core/preferences.dart';
import 'package:visual_novel/core/scene_handler.dart';

///Синглтон, который отвечает за все основное взаимодействие с игрой
class Director with Binding, GameState {
  ///Инстанс синглтона
  static Director? _instance;

  final SceneHandler _sceneHandler;

  final Preferences _preferences;

  ///Точка доступа к единственному объекту класса [Director]
  factory Director() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = Director._init();
      return _instance!;
    }
  }

  //TODO: Убрать жесткую инициализацию настроек

  ///Инициализация [Director]
  Director._init()
      : _sceneHandler = SceneHandler(),
        _preferences = const Preferences() {}

  ///Действует аналогично вызову SceneHandler(),
  ///однако позволяет получать доступ к нему через [Director]
  SceneHandler get sceneHandler => _sceneHandler;

  Preferences get preferences => _preferences;

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
}
