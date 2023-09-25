import 'dart:core';

class Scene {
  final Function? script;
  final Set<String>? nextScene;

  Scene({this.script, this.nextScene});
}
