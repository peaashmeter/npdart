import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';
import 'package:npdart/src/core/tree.dart';

///A core element of a global state of the game.
///
///Consider a visual novel as a [Tree] of scenes.
///Globally, 'beating the game' means to traverse the entire tree, from its root
///to one of its leaves.
///
///Once a [Scene] is loaded, a [Stage] is implicitly created to represent local changes.
///
///Every scene contains a [script] that runs right after the scene loaded.
///The script usually contains a sequence of actions which change the state of a [Stage].
///The script will also usually return a new [Scene].
class Scene {
  final Future<NovelStateSnapshot> Function(
      Stage stage, NovelStateSnapshot state) script;
  final String? description;

  Scene({
    required this.script,
    this.description,
  });
}
