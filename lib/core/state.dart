import 'package:flutter/widgets.dart';
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

  NovelStateSnapshot(
      {required this.sceneId,
      required this.variables,
      required this.verseHistory});

  NovelStateSnapshot copyWith(
          {String? sceneId,
          Map<String, dynamic>? variables,
          List<Verse>? verseHistory}) =>
      NovelStateSnapshot(
          sceneId: sceneId ?? this.sceneId,
          variables: variables ?? this.variables,
          verseHistory: verseHistory ?? this.verseHistory);

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
}
