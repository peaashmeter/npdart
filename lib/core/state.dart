import 'package:flutter/widgets.dart';
import 'package:npdart/core/audio.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/tree.dart';
import 'package:npdart/core/verse.dart';

class NovelStateEvent extends Notification {
  final NovelStateSnapshot snapshot;

  NovelStateEvent({required this.snapshot});
}

class InheritedNovelState extends InheritedWidget {
  final NovelStateSnapshot snapshot;
  const InheritedNovelState(
      {super.key, required this.snapshot, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedNovelState oldWidget) =>
      oldWidget.snapshot != snapshot;

  static InheritedNovelState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedNovelState>()!;
}

class NovelStateSnapshot {
  final List<Verse> verseHistory;
  final String sceneId;
  final Map<String, dynamic> variables;
  final Tree tree;
  final Preferences preferences;

  ///Should have a reference to the current [AudioManager] here to maintain audio between states.
  final AudioManager audio;

  NovelStateSnapshot({
    required this.sceneId,
    required this.variables,
    required this.verseHistory,
    required this.tree,
    required this.audio,
    required this.preferences,
  });

  NovelStateSnapshot copyWith(
          {String? sceneId,
          Map<String, dynamic>? variables,
          List<Verse>? verseHistory,
          Tree? tree,
          AudioManager? audio,
          Preferences? preferences}) =>
      NovelStateSnapshot(
          sceneId: sceneId ?? this.sceneId,
          variables: variables ?? this.variables,
          verseHistory: verseHistory ?? this.verseHistory,
          tree: tree ?? this.tree,
          audio: audio ?? this.audio,
          preferences: preferences ?? this.preferences);

  Object? getData(String key) => variables[key];

  NovelStateSnapshot removeData(String key) {
    final copy = Map<String, dynamic>.from(variables);
    copy[key] = null;
    return copyWith(variables: copy);
  }

  ///Binds provided [value] with [key]. Value object must be json-encodable.
  NovelStateSnapshot setData(String key, Object value) {
    final copy = Map<String, dynamic>.from(variables);
    copy[key] = value;
    return copyWith(variables: copy);
  }

  NovelStateSnapshot logVerses(List<Verse> verses) =>
      copyWith(verseHistory: List.from(verseHistory..addAll(verses)));

  NovelStateSnapshot loadScene(String sceneId) => copyWith(sceneId: sceneId);

  NovelStateSnapshot updatePreferences(Preferences preferences) =>
      copyWith(preferences: preferences);
}
