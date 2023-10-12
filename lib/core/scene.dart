import 'dart:core';

class Scene {
  final Function()? script;
  final String? description;

  Scene({
    required this.script,
    required this.description,
  });
}
