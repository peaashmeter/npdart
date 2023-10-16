import 'package:npdart/core/scene.dart';

///A singleton that holds all the scenes and provides methods for accessing them.
class Tree {
  static Tree? instance;

  final Map<String, Scene> _tree = {};

  factory Tree() {
    instance ??= Tree._();
    return instance!;
  }

  Tree._();

  Scene getScene(String id) {
    assert(_tree.containsKey(id),
        'There is no scene with id $id. Also note that a scene with id "root" should be defined.');
    return _tree[id]!;
  }

  ///Fills the inner map with provided scenes.
  ///It is implicitly called by [Novel] when loaded.
  void populate(Map<String, Scene> tree) {
    _tree.addAll(tree);
  }
}
