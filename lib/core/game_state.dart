import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/scene_handler.dart';

///Расширение класса [Director] для манипуляций с игровым состоянием
mixin GameState {
  ///Здесь хранятся все игровые переменные, идентификация по айди
  final Map<String, dynamic> _variables = {};

  late Scene _currentScene = Director().getSceneById('scene1');

  ///Текущая сцена
  Scene get currentScene => _currentScene;

  ///Возвращает игровую переменную по её айди.
  T getVariable<T>(String id) {
    assert(_variables.containsKey(id));
    return _variables[id]!;
  }

  void setScene(String? id) {
    _currentScene = Director().getSceneById(id);
    SceneHandler().requestSceneChange();
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
}
