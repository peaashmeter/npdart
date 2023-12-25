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
  final String? lastScene;
  final Map<String, dynamic> variables;
  final Tree tree;
  final Preferences preferences;

  ///Will cause exit from scenes tree if this is true.
  final bool isTerminator;

  ///Will not affect autosaving if this is false.
  final bool shouldAutosave;

  ///Will mark the scene as 'visited', therefore it can be skipped through.
  final bool isSkippable;

  ///Should have a reference to the current [AudioManager] here to maintain audio between states.
  final AudioManager audio;

  NovelStateSnapshot(
      {required this.sceneId,
      required this.variables,
      required this.verseHistory,
      required this.tree,
      required this.audio,
      required this.preferences,
      this.lastScene,
      this.isTerminator = false,
      this.shouldAutosave = true,
      this.isSkippable = true});

  NovelStateSnapshot copyWith(
          {String? sceneId,
          String? lastScene,
          Map<String, dynamic>? variables,
          List<Verse>? verseHistory,
          Tree? tree,
          AudioManager? audio,
          Preferences? preferences,
          bool? isTerminator,
          bool? shouldAutosave,
          bool? isSkippable}) =>
      NovelStateSnapshot(
          sceneId: sceneId ?? this.sceneId,
          lastScene: lastScene ?? this.lastScene,
          variables: variables ?? this.variables,
          verseHistory: verseHistory ?? this.verseHistory,
          tree: tree ?? this.tree,
          audio: audio ?? this.audio,
          preferences: preferences ?? this.preferences,
          isTerminator: isTerminator ?? this.isTerminator,
          shouldAutosave: shouldAutosave ?? this.shouldAutosave,
          isSkippable: isSkippable ?? this.isSkippable);

  ///Makes this [NovelStateSnapshot] not affect the saves.
  ///This behavior will not persist through the next states.
  NovelStateSnapshot doNotSave() => copyWith(shouldAutosave: false);

  ///Makes this [NovelStateSnapshot] not affect the list of visited scenes.
  ///This behavior will not persist through the next states.
  NovelStateSnapshot doNotMarkVisited() => copyWith(isSkippable: false);

  ///Makes this [NovelStateSnapshot] a terminator.
  ///It will cause the novel to call onExit() callback.
  NovelStateSnapshot terminate() => copyWith(isTerminator: true);

  ///Return a data binded with a [key] from the global state if such a [key] exists.
  ///Otherwise returns null.
  Object? getData(String key) => variables[key];

  ///Seeks a scene with [sceneId] in the [Tree], then makes it the next one.
  NovelStateSnapshot loadScene(String sceneId) =>
      copyWith(sceneId: sceneId, lastScene: this.sceneId);

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

  ///Updates [Preferences] according to the provided changes.
  NovelStateSnapshot updatePreferences(Preferences preferences) =>
      copyWith(preferences: preferences);
}
