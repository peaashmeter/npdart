import 'dart:ui';

///Глобальные константы, определяющие работу игры
class Preferences {
  ///Высота текстового окна. По умолчанию равна 3 сантиметрам в логических пикселях.
  double textBoxHeight;

  ///The vertical resolution that the sprites are designed for
  double imageHeight;

  ///It's the time between drawing characters of the string on the scene
  int milliseconds = 30;

  final Map<String, Offset> spritePositions = {
    'left': const Offset(0.33, 0.9),
    'center': const Offset(0.5, 0.9),
    'right': const Offset(0.67, 0.9),
  };

  Preferences({this.textBoxHeight = 114.0, this.imageHeight = 1080});
}
