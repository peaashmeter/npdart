import 'package:npdart/core/novel.dart';
import 'package:npdart/core/stage.dart';

class Scene {
  final Function(Stage stage, NovelState state)? script;
  final String? description;

  Scene({
    required this.script,
    required this.description,
  });
}
