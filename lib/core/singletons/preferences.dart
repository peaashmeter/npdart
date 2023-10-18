import 'package:flutter/material.dart';

///Глобальные константы, определяющие работу игры.
class Preferences {
  static Preferences? instance;

  ///Высота текстового окна. По умолчанию равна 3 сантиметрам в логических пикселях.
  final double textBoxHeight = 114;

  ///It's the time between drawing characters of the string on the scene.
  final int typingDelay = 20;

  ///Parallax intensity of background and sprites with depth set to 1.
  final double backgroundParallax = 0.005;

  ///Named relative positions of the sprites on a scene.
  ///Each position is represented as [Offset] from the center
  ///of the screen, where (-1, -1) is the top-left corner,
  ///and (1, 1) is the bottom-right one.
  final Map<String, Offset> spritePositions = const {
    'center': Offset(0, 0.5),
    'center_left': Offset(
      -1 / 3,
      0.5,
    ),
    'center_right': Offset(1 / 3, 0.5),
    'left': Offset(-2 / 3, 0.5),
    'right': Offset(2 / 3, 0.5),
  };

  ///Relative path to the save file. Root is defined by getApplicationDocumentsDirectory().
  final String savePath = 'novel/save.json';

  factory Preferences() {
    instance ??= Preferences._();
    return instance!;
  }

  Preferences._();
}
