import 'package:flutter/widgets.dart';
import 'package:npdart/core/audio.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/tree.dart';
import 'package:npdart/core/verse.dart';

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

class NovelStateEvent extends Notification {
  final NovelStateSnapshot snapshot;

  NovelStateEvent({required this.snapshot});
}

class NovelStateSnapshot {
  final List<Verse> verseHistory;
  final String sceneId;
  final Map<String, dynamic> variables;
  final Tree tree;
  final Preferences preferences;

  ///Will cause exit from scenes tree if this is true.
  final bool isTerminator;

  ///Will not affect autosaving if this is false.
  final bool shouldAutosave;

  ///Should have a reference to the current [AudioManager] here to maintain audio between states.
  final AudioManager audio;

  NovelStateSnapshot(
      {required this.sceneId,
      required this.variables,
      required this.verseHistory,
      required this.tree,
      required this.audio,
      required this.preferences,
      this.isTerminator = false,
      this.shouldAutosave = true});

  NovelStateSnapshot copyWith(
          {String? sceneId,
          Map<String, dynamic>? variables,
          List<Verse>? verseHistory,
          Tree? tree,
          AudioManager? audio,
          Preferences? preferences,
          bool? isTerminator,
          bool? shouldAutosave}) =>
      NovelStateSnapshot(
        sceneId: sceneId ?? this.sceneId,
        variables: variables ?? this.variables,
        verseHistory: verseHistory ?? this.verseHistory,
        tree: tree ?? this.tree,
        audio: audio ?? this.audio,
        preferences: preferences ?? this.preferences,
        isTerminator: isTerminator ?? this.isTerminator,
        shouldAutosave: shouldAutosave ?? this.shouldAutosave,
      );

  ///Makes this [NovelStateSnapshot] not affect the saves.
  NovelStateSnapshot doNotSave() => copyWith(shouldAutosave: false);

  Object? getData(String key) => variables[key];

  ///Seeks a scene with [sceneId] in the [Tree], then makes it the next one.
  NovelStateSnapshot loadScene(String sceneId) => copyWith(sceneId: sceneId);

  ///Adds all the verses from current scene to the history log.
  NovelStateSnapshot logVerses(List<Verse> verses) =>
      copyWith(verseHistory: List.from(verseHistory..addAll(verses)));

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

  ///Makes this [NovelStateSnapshot] a terminator.
  ///It will cause the novel to call onExit() callback.
  NovelStateSnapshot terminate() => copyWith(isTerminator: true);

  ///Updates [Preferences] according to the provided changes.
  NovelStateSnapshot updatePreferences(Preferences preferences) =>
      copyWith(preferences: preferences);
}
