import 'package:flutter/material.dart';

///Глобальные константы, определяющие работу игры.
class Preferences {
  static String defaultTranslator(String s) => s;

  ///Высота текстового окна. По умолчанию равна 3 сантиметрам в логических пикселях.
  final double textBoxHeight;

  ///It's the time between drawing characters of the string on the scene.
  final int typingDelay;

  ///Parallax intensity of background and sprites with depth set to 1.
  final double backgroundParallax;

  ///Named relative positions of the sprites on a scene.
  ///Each position is represented as [Offset] from the center
  ///of the screen, where (-1, -1) is the top-left corner,
  ///and (1, 1) is the bottom-right one.
  final Map<String, Offset> spritePositions;

  ///Relative path to the save folder. Root is defined by getApplicationDocumentsDirectory().
  final String savePath;

  ///A callback which translates the engine built-in strings.
  ///Default to [Preferences.defaultTranslator]
  final String Function(String) translate;

  const Preferences(
      {this.textBoxHeight = 114,
      this.typingDelay = 20,
      this.backgroundParallax = 0.005,
      this.spritePositions = const {
        'center': Offset(0, 0.5),
        'center_left': Offset(
          -1 / 3,
          0.5,
        ),
        'center_right': Offset(1 / 3, 0.5),
        'left': Offset(-2 / 3, 0.5),
        'right': Offset(2 / 3, 0.5),
      },
      this.savePath = '/novel/',
      this.translate = Preferences.defaultTranslator});

  Preferences copyWith({
    double? textBoxHeight,
    int? typingDelay,
    double? backgroundParallax,
    Map<String, Offset>? spritePositions,
    String? savePath,
    String Function(String)? translate,
  }) =>
      Preferences(
          textBoxHeight: textBoxHeight ?? this.textBoxHeight,
          typingDelay: typingDelay ?? this.typingDelay,
          backgroundParallax: backgroundParallax ?? this.backgroundParallax,
          spritePositions: spritePositions ?? this.spritePositions,
          savePath: savePath ?? this.savePath,
          translate: translate ?? this.translate);
}
