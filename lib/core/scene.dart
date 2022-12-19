import 'package:visual_novel/core/verse.dart';

abstract class Scene {
  final String _id;
  final String? _actionId;
  final String? _nextScene;

  Scene(this._id, this._actionId, this._nextScene);

  String get id => _id;
  String? get actionId => _actionId;
  String? get nextScene => _nextScene;
}

class GenericScene extends Scene {
  final Verse _verse;
  final String? _background;
  final String? _music;
  final Map<String, int>? _characters;

  ///Список с айди выборов из binding
  final List<String>? _choices;
  List<String>? get choices => _choices;

  GenericScene(
      {required String id,
      required Verse verse,
      String? background,
      String? music,
      Map<String, int>? characters,
      List<String>? choices,
      String? actionId,
      String? nextScene})
      : _verse = verse,
        _background = background,
        _music = music,
        _characters = characters,
        _choices = choices,
        super(id, actionId, nextScene);

  GenericScene.simple({
    required String id,
    required Verse verse,
    required String nextScene,
    String? background,
    String? music,
    Map<String, int>? characters,
    String actionId = 'next_scene',
  }) : this(
            id: id,
            verse: verse,
            background: background,
            music: music,
            characters: characters,
            choices: null,
            actionId: actionId,
            nextScene: nextScene);

  GenericScene.newVerse(
      {required String id, required Verse verse, required String nextScene})
      : this.simple(id: id, verse: verse, nextScene: nextScene);

  GenericScene.choices({
    required String id,
    required Verse verse,
    required List<String>? choices,
    String? background,
    String? music,
    Map<String, int>? characters,
    String? actionId,
  }) : this(
            id: id,
            verse: verse,
            background: background,
            music: music,
            characters: characters,
            choices: choices,
            actionId: actionId,
            nextScene: null);

  String? get header => _verse.header;
  String? get text => _verse.text;
  String? get music => _music;
  String? get background => _background;
  Map<String, int>? get characters => _characters;
}

///Сцена с минимумом требований, внутри которой может быть что угодно,
///даже игра в очко
class InteractiveScene extends Scene {
  InteractiveScene(String id) : super(id, null, null);

  //TODO: возможность отображать любой виджет(?) внутри такой сцены
}
