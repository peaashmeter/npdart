import 'package:flutter/foundation.dart';

///Расширение [Director], связывающее игровое состояние и отрисовку.
///Вынесено в отдельный класс для того, чтобы [Director] не зависел от
///[ChangeNotifier]
class SceneHandler extends ChangeNotifier {
  static SceneHandler? _instance;

  factory SceneHandler() {
    if (_instance != null) {
      return _instance!;
    }
    _instance = SceneHandler._();
    return _instance!;
  }
  SceneHandler._();

  ///Уведомляет отрисовщик, что сцена изменилась
  void requestSceneChange() {
    notifyListeners();
  }
}
