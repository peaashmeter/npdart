import 'dart:core';

import 'package:visual_novel/core/verse.dart';

class Scene {
  final Verse? _verse;
  final String? _onLoadActionId;
  final String? _onLeaveActionId;
  final String? _nextScene;
  final String? _background;
  final String? _music;
  final List<String>? _choices;

  final Map<String, String>? _sprites;

  Scene(
      {String? onLoadActionId,
      String? onLeaveActionId = 'next_scene',
      String? nextScene,
      String? background,
      String? music,
      Map<String, String>? sprites,
      List<String>? choices,
      Verse? verse})
      : _onLoadActionId = onLoadActionId,
        _onLeaveActionId = onLeaveActionId,
        _nextScene = nextScene,
        _background = background,
        _music = music,
        _sprites = sprites,
        _choices = choices,
        _verse = verse;

  String? get onLeaveActionId => _onLeaveActionId;
  String? get onLoadActionId => _onLoadActionId;
  String? get nextScene => _nextScene;
  Verse? get verse => _verse;
  String? get music => _music;
  String? get background => _background;
  List<String>? get choices => _choices;
  Map<String, String>? get sprites => _sprites;
}
