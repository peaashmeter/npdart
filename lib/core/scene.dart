import 'package:visual_novel/core/verse.dart';

abstract class Scene {
  final String _id;
  Scene(this._id);

  String get id => _id;
}

abstract class GenericScene extends Scene {
  final Verse _verse;
  final String? _background;
  final String? _music;
  final Map<String, int>? _characters;
  GenericScene(
      super.id, this._verse, this._background, this._music, this._characters);

  String? get header => _verse.header;
  String? get text => _verse.text;
  String? get music => _music;
  String? get background => _background;
  Map<String, int>? get characters => _characters;
}

///Сцена без выборов
class SimpleScene extends GenericScene {
  final String _nextScene;
  String get nextScene => _nextScene;

  SimpleScene(
      {required String id,
      required Verse verse,
      String? background,
      String? music,
      Map<String, int>? characters,
      required String nextScene})
      : _nextScene = nextScene,
        super(id, verse, background, music, characters);
}

///Сцена с несколькими (>0) выборами
class MultipleChoiceScene extends GenericScene {
  ///Список с айди выборов из binding
  final List<String> _choices;

  MultipleChoiceScene(
      {required String id,
      required Verse verse,
      String? background,
      String? music,
      Map<String, int>? characters,
      required List<String> choices})
      : _choices = choices,
        super(id, verse, background, music, characters);

  List<String> get choices => _choices;
}

///Сцена с минимумом требований, внутри которой может быть что угодно,
///даже игра в очко
class InteractiveScene extends Scene {
  InteractiveScene(super.id);

  //TODO: возможность отображать любой виджет(?) внутри такой сцены
}
