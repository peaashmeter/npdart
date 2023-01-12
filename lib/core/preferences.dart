import 'dart:ui';

///Глобальные константы, определяющие работу игры.
class Preferences {
  ///Высота текстового окна. По умолчанию равна 3 сантиметрам в логических пикселях.
  final double textBoxHeight;

  ///The vertical resolution that the sprites are designed for.
  final double imageHeight;

  ///It's the time between drawing characters of the string on the scene.
  final int milliseconds;

  ///The folder where the sprites are located.
  final String spritesRoot;

  ///The folder where the backgrounds are located.
  final String backgroundsRoot;

  ///Named relative positions of the sprites on a scene.
  ///Each position is represented as [Offset] from (left, top)
  ///corner of the screen, where (0, 0) is the top-left corner,
  ///and (1, 1) is the bottom-right one.
  final Map<String, Offset> spritePositions;

  const Preferences({
    this.textBoxHeight = 114.0,
    this.imageHeight = 1080,
    this.spritesRoot = 'assets/sprites/',
    this.backgroundsRoot = 'assets/backgrounds/',
    this.spritePositions = const {
      'left': Offset(0.33, 0.9),
      'center': Offset(0.5, 0.9),
      'right': Offset(0.67, 0.9),
    },
    this.milliseconds = 20,
  });

  ///Creates a copy of this preferences replacing the specified parameters.
  Preferences apply({
    double? textBoxHeight,
    double? imageHeight,
    String? spritesRoot,
    String? backgroundsRoot,
    Map<String, Offset>? spritePositions,
    String? initialScene,
    int? milliseconds,
  }) {
    return Preferences(
        textBoxHeight: textBoxHeight ?? this.textBoxHeight,
        imageHeight: imageHeight ?? this.imageHeight,
        spritesRoot: spritesRoot ?? this.spritesRoot,
        backgroundsRoot: backgroundsRoot ?? this.backgroundsRoot,
        spritePositions: spritePositions ?? this.spritePositions,
        milliseconds: milliseconds ?? this.milliseconds);
  }
}
