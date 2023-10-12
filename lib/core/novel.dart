import 'package:flutter/material.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/singletons/tree.dart';
import 'package:npdart/widgets/game.dart';

class Novel extends StatefulWidget {
  final Map<String, Scene> tree;
  const Novel({super.key, required this.tree});

  @override
  State<Novel> createState() => _NovelState();
}

class _NovelState extends State<Novel> {
  @override
  void initState() {
    Tree().populateTree(widget.tree);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Preferences(child: Scaffold(
      body: Builder(builder: (context) {
        final initialScene = widget.tree[Preferences.of(context).initialScene]!;
        return Game(
          initialScene: initialScene,
        );
      }),
    ));
  }
}
