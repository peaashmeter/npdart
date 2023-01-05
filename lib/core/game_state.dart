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
  Map<String, String>? sprites;
  String? _nextScene;
  String? _onLoadActionId;
  String? _onLeaveActionId;
  List<String>? _choices;
  Verse? verse;

  ///Возвращает игровую переменную по её айди.
  T getVariable<T>(String id) {
    assert(_variables.containsKey(id));
    return _variables[id]!;
  }

  void setScene(String? id) {
    currentSceneId = id;
    final scene = Director().getSceneById(id);
    SceneHandler().requestSceneChange(scene);
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
