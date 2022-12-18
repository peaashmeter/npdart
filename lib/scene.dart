import 'package:visual_novel/condition.dart';

class Scene {
  final String id;
  final String? text;
  final Map<String, int>? characters;
  final String? background;
  final String? music;

  ///Игра должна проверять каждое условие
  ///и переходить на сцену с айди под выполненным условием
  final List<Route>? routes;

  ///Если никаких условий не задано, должен быть задан адрес
  ///следующей сцены для безусловного перехода
  final String nextScene;

  ///Проходимся по списку условий и находим айди следующей сцены
  String getNextSceneId() {
    for (var route in routes ?? []) {
      if (route.checkCondition?.call() ?? false) {
        return route.nextScene;
      }
    }
    return nextScene;
  }
}
