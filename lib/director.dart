import 'package:visual_novel/scene.dart';

///Синглтон, в котором мы храним текущее состояние игры
class Director {
  ///Здесь хранятся все игровые переменные, идентификация по айди
  final Map<String, int> variables;

  final Map<String, Scene> scenes;

  Scene scene;

  void goToNextScene(String id) {
    throw Error();
    //TODO: уведомить отрисовщик, что надо нарисовать новую сцену
  }
}
