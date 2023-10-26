import 'dart:core';

class Scene {
  final Function()? script;
  final String? description;

  ///A timestamp to differentiate two instances of a same scene, loaded in different times
  final int? token;

  Scene({
    required this.script,
    required this.description,
  }) : token = DateTime.timestamp().millisecondsSinceEpoch;

  ///Returns a copy of [other] with a new token
  factory Scene.from(Scene other) {
    return Scene(script: other.script, description: other.description);
  }
}
