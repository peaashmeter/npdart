import 'package:flutter/foundation.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';

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

  late Scene _currentScene = Director().getSceneById(Director().currentSceneId);

  Scene get currentScene => _currentScene;

  ///Уведомляет отрисовщик, что сцена изменилась
  void requestSceneChange(Scene scene) {
    _currentScene = scene;
    notifyListeners();
  }
}
