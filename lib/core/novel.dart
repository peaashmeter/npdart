import 'package:flutter/material.dart';
import 'package:npdart/core/audio.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/tree.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/game.dart';

class Novel extends StatefulWidget {
  final SaveData initialState;
  final Tree tree;
  final Preferences preferences;
  const Novel(
      {super.key,
      required this.initialState,
      required this.tree,
      required this.preferences});

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
        preferences: widget.preferences);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<NovelStateEvent>(
            onNotification: (event) {
              setState(() {
                snapshot = event.snapshot;
              });
              return true;
            },
            child: InheritedNovelState(
                snapshot: snapshot, child: const ParralaxHandler())));
  }
}
