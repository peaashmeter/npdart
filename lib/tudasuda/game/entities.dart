import 'dart:math';

import 'package:flutter/material.dart' hide Border;

import 'directions.dart';
import 'impressions.dart';
import 'mobs.dart';

abstract class Entity {
  Point<int> position;
  int order;
  Impressions impression;
  bool isAnimated;

  Entity(this.position, this.order, this.impression, [this.isAnimated = true]);

  int getLinearPosition(int width) {
    return position.y * width + position.x;
  }

  Widget getImpression(double size) {
    return Impression(
      isAnimated: isAnimated,
      cellSize: size,
      direction: Directions.zero,
      impression: impression,
      key: UniqueKey(),
    );
  }
}

class Pointer extends Entity {
  Pointer(Point<int> position, int order, Impressions impression)
      : super(position, order, impression);
  Pointer.arrowMob(Point<int> position,
      {int order = 0, Impressions impression = Impressions.arrowMobPointer})
      : super(position, order, impression);
  Pointer.ray(Point<int> position,
      {int order = 0, Impressions impression = Impressions.rayPointer})
      : super(position, order, impression);
}
