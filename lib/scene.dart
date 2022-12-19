import 'package:visual_novel/route.dart';

abstract class Scene {
  final String _id;
  Scene(this._id);

  String get id => _id;
}

abstract class GenericScene extends Scene {
  final String? _text;
  final String? _music;
  final Map<String, int>? _characters;
  GenericScene(super.id, this._text, this._music, this._characters);

  String? get text => _text;
  String? get music => _music;
  Map<String, int>? get characters => _characters;
}

///Сцена без выборов
class SimpleScene extends GenericScene {
  final Scene _nextScene;

  SimpleScene(
      {required String id,
      String? text,
      String? music,
      Map<String, int>? characters,
      required Scene nextScene})
      : _nextScene = nextScene,
        super(id, text, music, characters);

  Scene get nextScene => _nextScene;
}

///Сцена с несколькими (>0) выборами
class MultipleChoiceScene extends GenericScene {
  ///Список с айди выборов из binding
  final List<String> _choices;

  MultipleChoiceScene(
      {required String id,
      String? text,
      String? music,
      Map<String, int>? characters,
      required List<String> choices})
      : _choices = choices,
        super(id, text, music, characters);

  List<String> get choices => _choices;

  //TODO: обработка выбора с заданным айди
}

///Сцена с минимумом требований, внутри которой может быть что угодно,
///даже игра в очко
class InteractiveScene extends Scene {
  InteractiveScene(super.id);

  //TODO: возможность отображать любой виджет(?) внутри такой сцены
}
