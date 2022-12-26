import 'dart:ui';

///Глобальные константы, определяющие работу игры
class Preferences {
  ///Высота текстового окна. По умолчанию равна 3 сантиметрам в логических пикселях.
  double textBoxHeight;

  final Map<String, Offset> characterPositions = {};

  Preferences({this.textBoxHeight = 114.0});
}
