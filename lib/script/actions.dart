import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';

void nextScene(Scene caller) {
  assert(caller.nextScene != null);
  Director().setScene(caller.nextScene!);
}
