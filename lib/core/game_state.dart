import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/scene_handler.dart';
import 'package:visual_novel/core/verse.dart';

///Расширение класса [Director] для манипуляций с игровым состоянием
mixin GameState {
  ///Здесь хранятся все игровые переменные, идентификация по айди
  final Map<String, dynamic> _variables = {};

  String? currentSceneId = 'scene1';

  String? background;
  String? music;
  Map<String, String>? sprites;
  String? nextScene;
  String? onLoadActionId;
  String? onLeaveActionId;
  List<String>? choices;
  Verse? verse;

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
    background = scene.background ?? background;
    music = scene.music ?? music;
    sprites = scene.sprites ?? sprites;
    nextScene = scene.nextScene ?? nextScene;
    onLeaveActionId = scene.onLeaveActionId ?? onLeaveActionId;
    onLoadActionId = scene.onLoadActionId ?? onLoadActionId;
    choices = scene.choices ?? choices;
    verse = scene.verse ?? verse;

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
        onLeaveActionId: onLeaveActionId,
        onLoadActionId: onLoadActionId,
        sprites: sprites,
        background: background,
        music: music,
        nextScene: nextScene,
        choices: choices,
        verse: verse);
  }
}
