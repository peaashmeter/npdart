import 'package:visual_novel/core/binding.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/scene_handler.dart';
import 'package:visual_novel/core/verse.dart';
import '../script/action_binding.dart' show binding;

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
      'scene1': GenericScene.simple(
          id: 'scene1',
          verse: Verse(headerId: 'pushkin', stringId: 'onegin'),
          background: 'scenery1.jpg',
          nextScene: 'scene2'),
      'scene2': GenericScene.simple(
          id: 'scene2',
          verse: Verse(headerId: 'somebody', stringId: 's2'),
          background: 'scenery2.jpg',
          nextScene: 'scene1'),
    };

    setScene('scene1');
  }

  ///Инстанс синглтона
  static Director? _instance;

  //TODO: реализовать это через миксины

  final SceneHandler _sceneHandler;

  //TODO: перенести это в Binding

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

  Scene getScene(String id) {
    assert(_scenes.containsKey(id));
    return _scenes[id]!;
  }

  void setScene(String id) {
    _currentScene = getScene(id);
    _sceneHandler.requestSceneChange();
  }

  void runAction(String id) async {
    assert(binding.containsKey(id), 'There is no action with id $id!');
    await binding[id]!.call(currentScene);
  }
}
