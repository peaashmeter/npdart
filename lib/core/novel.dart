import 'package:flutter/material.dart';
import 'package:npdart/core/audio.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/tree.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/parallax.dart';

///An entry point of the visual novel.
class Novel extends StatefulWidget {
  final SaveData initialState;
  final Tree tree;
  final Preferences preferences;
  final Function? onExit;
  const Novel(
      {super.key,
      required this.initialState,
      required this.tree,
      required this.preferences,
      this.onExit});

  @override
  State<Novel> createState() => _NovelState._();
}

class _NovelState extends State<Novel> {
  late NovelStateSnapshot snapshot;

  _NovelState._();

  @override
  void initState() {
    snapshot = NovelStateSnapshot(
      sceneId: widget.initialState.sceneId,
      variables: widget.initialState.state,
      verseHistory: [],
      audio: AudioManager(),
      tree: widget.tree,
      preferences: widget.preferences,
      isTerminator: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<NovelStateEvent>(
            onNotification: (event) {
              if (event.snapshot.isTerminator) {
                widget.onExit?.call();
                return true;
              }
              if (event.snapshot.shouldAutosave) {
                autosave(SaveData.fromStateSnapshot(event.snapshot, ''),
                    event.snapshot.preferences.savePath);
              }

              setState(() {
                snapshot = event.snapshot
                    .copyWith(shouldAutosave: true, isTerminator: false);
              });
              return true;
            },
            child: InheritedNovelState(
                snapshot: snapshot, child: const ParralaxHandler())));
  }
}
