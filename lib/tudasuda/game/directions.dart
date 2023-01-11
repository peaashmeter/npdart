import 'dart:math';

enum Directions { left, up, right, down, zero }

class Direction {
  late final Point<int> vector;
  Direction(Directions direction) {
    switch (direction) {
      case Directions.left:
        vector = const Point(-1, 0);
        break;
      case Directions.right:
        vector = const Point(1, 0);
        break;
      case Directions.up:
        vector = const Point(0, -1);
        break;
      case Directions.down:
        vector = const Point(0, 1);
        break;
      default:
        vector = const Point(0, 0);
        break;
    }
  }
}
