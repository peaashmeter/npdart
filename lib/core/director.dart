import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/scene_handler.dart';
import 'package:visual_novel/core/verse.dart';
import '../script/action_binding.dart' show binding;

///Синглтон для глобальных операций над состоянием игры
class Director {
  ///Приватный конструктор
  Director._();

  ///Инстанс синглтона
  static Director? _instance;

  static Director getInstance() {
    assert(_instance is Director);
    return _instance!;
  }

  static void initDirector() {
    assert(_instance is! Director);
    _instance = Director._();

    //TODO: убрать создание сцен отсюда

    _instance!._variables = {};
    _instance!._scenes = {
      'scene1': GenericScene.simple(
          id: 'scene1',
          verse: Verse('Какой-то чел',
              '''​Мой дядя самых честных правил, когда не в шутку занемог, он уважать себя заставил и лучше выдумать не мог. Его пример другим наука; но, боже мой, какая скука с больным сидеть и день и ночь, не отходя ни шагу прочь! Какое низкое коварство полуживого забавлять, ему подушки поправлять, печально подносить лекарство, вздыхать и думать про себя: когда же черт возьмет тебя!'''),
          background: 'scenery1.jpg',
          nextScene: 'scene2'),
      'scene2': GenericScene.simple(
          id: 'scene1',
          verse: Verse('Какой-то чел', ''),
          background: 'scenery1.jpg',
          nextScene: 'scene1'),
    };
    _instance!._sceneHandler = SceneHandler();

    _instance!.setScene('scene1');
  }

  late final SceneHandler _sceneHandler;

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
