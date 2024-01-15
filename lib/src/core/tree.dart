import 'package:npdart/src/core/scene.dart';

///A class that holds all the scenes and provides methods for accessing them.
class Tree {
  final Map<String, Scene> scenes;

  Tree({required this.scenes});

  Scene getScene(String id) {
    assert(scenes.containsKey(id),
        'There is no scene with id $id. Also note that a scene with id "root" should be defined.');
    return scenes[id]!;
  }
}
