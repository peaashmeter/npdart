import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/binding.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/scene_handler.dart';
import 'package:visual_novel/core/verse.dart';

///Синглтон для глобальных операций над состоянием игры
class Director with Binding {
  ///Точка доступа к единственному объекту класса [Director]
  factory Director() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = Director._init();
      return _instance!;
    }
  }

  ///Инициализация [Director]
  Director._init() : _sceneHandler = SceneHandler() {
    //TODO: убрать создание сцен отсюда
    _variables = {};
    _scenes = {
      'test_scene': GenericScene.simple(
          id: 'test_scene', verse: Verse(), nextScene: 'test_scene'),
      'scene1': GenericScene.choices(
          id: 'scene1',
          verse: Verse(headerId: 'pushkin', stringId: 'onegin'),
          background: 'scenery1.jpg',
          choices: ['choice1', 'choice2']),
      'scene2': GenericScene.simple(
          id: 'scene2',
          verse: Verse(headerId: 'somebody', stringId: 's2'),
          background: 'scenery1.jpg',
          nextScene: 'scene1'),
    };

    setScene('scene1');
  }

  ///Инстанс синглтона
  static Director? _instance;

  final SceneHandler _sceneHandler;

  ///Здесь хранятся все игровые переменные, идентификация по айди
  late final Map<String, num> _variables;

  ///Все игровые сцены; инициализируются при запуске игры
  late final Map<String, Scene> _scenes;

  late Scene _currentScene;

  Scene get currentScene => _currentScene;

  SceneHandler get sceneHandler => _sceneHandler;

  num getVariable(String id) {
    assert(_variables.containsKey(id));
    return _variables[id]!;
  }

  void setVariable(String id, num value) {
    assert(_variables.containsKey(id));
    _variables[id] = value;
  }

  Scene getScene(String? id) {
    assert(_scenes.containsKey(id));
    return _scenes[id]!;
  }

  void setScene(String? id) {
    _currentScene = getScene(id);
    _sceneHandler.requestSceneChange();
  }

  ///Выполняет действие с указанным id. Возвращает false, если возникла ошибка.
  Future<bool> runAction(String? id, List? args) async {
    final f = getFunction(id);

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
