import 'package:npdart/core/stage.dart';
import 'package:npdart/core/state.dart';

class Scene {
  final Future<NovelStateSnapshot> Function(
      Stage stage, NovelStateSnapshot state) script;
  final String? description;

  Scene({
    required this.script,
    required this.description,
  });
}
