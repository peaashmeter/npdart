import 'package:flutter/material.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/tree.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/game.dart';

class Novel extends StatefulWidget {
  final SaveData initialState;
  final Tree tree;
  const Novel({super.key, required this.initialState, required this.tree});

  @override
  State<Novel> createState() => NovelState._();
}

class NovelState extends State<Novel> {
  late NovelStateSnapshot snapshot;

  NovelState._();

  @override
  void initState() {
    snapshot = NovelStateSnapshot(
        sceneId: widget.initialState.sceneId,
        variables: widget.initialState.state,
        verseHistory: [],
        tree: widget.tree);
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
            child:
                InheritedNovelState(snapshot: snapshot, child: const Game())));
  }
}
