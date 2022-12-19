import 'package:flutter/foundation.dart';

///Часть [Director], связывающая игровое состояние и отрисовку.
///Вынесена в отдельный класс для того, чтобы [Director] не зависел от
///[ChangeNotifier]
class SceneHandler extends ChangeNotifier {
  SceneHandler();

  ///Уведомляет отрисовщик, что сцена изменилась
  void requestSceneChange() {
    notifyListeners();
  }
}
