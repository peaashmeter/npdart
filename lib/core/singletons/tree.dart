import 'package:npdart/core/scene.dart';

///A singleton that holds all the scenes and provides methods for accessing them.
class Tree {
  static Tree? instance;

  factory Tree() {
    instance ??= Tree._();
    return instance!;
  }

  Tree._();

  final Map<String, Scene> _tree = {};

  Scene getScene(String id) => _tree[id]!;

  ///Fills the inner map with provided scenes.
  ///It is implicitly called by [Novel] when loaded.
  void populateTree(Map<String, Scene> tree) {
    _tree.addAll(tree);
  }
}
