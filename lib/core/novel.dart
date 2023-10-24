import 'package:flutter/material.dart';
import 'package:npdart/core/singletons/state.dart';
import 'package:npdart/core/singletons/tree.dart';
import 'package:npdart/widgets/game.dart';

class Novel extends StatefulWidget {
  const Novel({super.key});

  @override
  State<Novel> createState() => _NovelState();
}

class _NovelState extends State<Novel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Game(
          initialScene: Tree().getScene(NovelState().sceneId!),
        );
      }),
    );
  }
}
