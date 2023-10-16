import 'package:flutter/material.dart';
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
    Tree().populate(widget.tree);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Game(
          initialScene: Tree().getScene('root'),
        );
      }),
    );
  }
}
