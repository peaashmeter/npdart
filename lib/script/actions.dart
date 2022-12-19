import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';

void changeScene(Scene caller) {
  assert(
      caller is SimpleScene, 'Caller scene ${caller.id} is not a SimpleScene!');

  Director.getInstance().setScene((caller as SimpleScene).nextScene);
}
