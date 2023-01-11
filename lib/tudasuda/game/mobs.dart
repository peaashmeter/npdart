import 'dart:math';

import 'package:flutter/material.dart';

import 'directions.dart';
import 'entities.dart';
import 'impressions.dart';

class Mob extends Entity {
  int id;
  Directions direction;

  List<int> connectedTo = [];

  bool isDangerous = false; //true if player dies on collision;
  Mob(this.id, Point<int> position, this.direction, Impressions impression,
      int order, bool isDangerous,
      [bool isAnimated = true])
      : super(position, order, impression, isAnimated);
  Mob.clone(Mob mob, Point<int> position, int id)
      : this(id, position, mob.direction, mob.impression, mob.order,
            mob.isDangerous);
  void move(int width, int height, List<Bound> bounds) {
    position = getNextPosition(width, height, bounds);
  }

  ///Returns true when the action has somehow ended the game.
  bool action(Player playerInstance, List<Entity> disposables) {
    return false;
  }

  void animateLeave(List<Entity> entities) {
    if (direction != Directions.zero) {
      entities.add(AnimationMob.mob(this));
    }
  }

  Impressions getAnimationImpression() {
    return impression;
  }

  Directions getInvertedDirection() {
    switch (direction) {
      case Directions.left:
        return Directions.right;
      case Directions.right:
        return Directions.left;
      case Directions.up:
        return Directions.down;
      case Directions.down:
        return Directions.up;

      default:
        return direction;
    }
  }

  Point<int> getNextPosition(int width, int height, List<Bound> mobs) {
    var m = directionVector;
    if ((position + m).x < 0) {
      return Point(width - 1, (position + m).y);
    } else if ((position + m).x > width - 1) {
      return Point(0, (position + m).y);
    } else if ((position + m).y < 0) {
      return Point((position + m).x, height - 1);
    } else if ((position + m).y > height - 1) {
      return Point((position + m).x, 0);
    } else {
      return position + m;
    }
  }

  Widget invokeLeaveAnimation(double size) {
    return Impression(
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
      reversed: true,
    );
  }

  Point<int> get directionVector => Direction(direction).vector;

  void scheduleActivation(Map<Point<int>, List<Mob>> mobsAtPoints) {
    for (var mob in mobsAtPoints[position]!) {
      if (mob != this && mob is Activable) {
        mob.scheduledActivation = true;
      }
    }
  }
}

mixin Lazy on Mob {}
mixin Activable on Mob {
  bool scheduledActivation = false;
}

mixin Disposable on Mob {
  void dispose(List<Mob> mobs, int i) {
    mobs.removeAt(i);
  }
}
mixin Electric on Mob {
  bool isOn = false;
  List<bool> signals = [];
  void onSignal(bool signal, int id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  bool connected = false;
}

mixin Emitter on Mob {
  void emitSignal(Map<int, Mob> mobsIds, bool signal, List<int> connectedTo) {
    for (var _id in connectedTo) {
      var target = mobsIds[_id];
      if (target != null && target is Electric) {
        target.onSignal(signal, id);
      }
    }
  }
}
mixin Spawner on Mob {
  void spawnEntities(int index, List<Entity> entities,
      List<Entity> entitiesToSpawn, int width, int height) {
    entities.insertAll(index, entitiesToSpawn.toList());
  }
}

class Exit extends Mob {
  Exit(int id, Point<int> position,
      {int order = 16,
      Impressions impression = Impressions.exit,
      Directions direction = Directions.zero,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);
  @override
  Exit.clone(Mob mob, Point<int> position, id) : this(id, position);

  @override
  Widget getImpression(double size) {
    return Impression(
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
    );
  }
}

class AnimationMob extends Mob with Disposable {
  AnimationMob.mob(Mob m)
      : super(65535, m.position, m.direction, m.getAnimationImpression(), 15,
            false);
  AnimationMob.entity(Entity e, Directions direction, [order = 1])
      : super(65535, e.position, direction, e.impression, order, false);

  @override
  Widget getImpression(double size) {
    return invokeLeaveAnimation(size);
  }
}

class ArrowMob extends Mob with Spawner {
  final int width;
  final int height;
  @override
  bool get isDangerous => true;
  ArrowMob(int id, Point<int> position, Directions direction, this.height,
      this.width,
      {Impressions impression = Impressions.arrowMob,
      int order = 15,
      bool isDangerous = true,
      bool isAnimated = false})
      : super(id, position, direction, impression, order, isDangerous,
            isAnimated);

  @override
  ArrowMob.clone(ArrowMob mob, Point<int> position, id)
      : this(id, position, mob.direction, mob.height, mob.width);

  @override
  Point<int> getNextPosition(int width, int height, List<Bound> mobs) {
    if ((position + directionVector).x >= width) {
      var _border = mobs
          .where((b) => b.position.x < position.x && b.position.y == position.y)
          .toList()
        ..sort((a, b) => a.position.x.compareTo(b.position.x));
      if (_border.isNotEmpty) {
        return _border.last.position + Direction(direction).vector;
      }
      return super.getNextPosition(width, height, mobs);
    } else if ((position + directionVector).x < 0) {
      var _border = mobs
          .where((b) => b.position.x > position.x && b.position.y == position.y)
          .toList()
        ..sort((a, b) => b.position.x.compareTo(a.position.x));
      if (_border.isNotEmpty) {
        return _border.last.position + Direction(direction).vector;
      }
      return super.getNextPosition(width, height, mobs);
    } else if ((position + directionVector).y >= height) {
      var _border = mobs
          .where((b) => b.position.y < position.y && b.position.x == position.x)
          .toList()
        ..sort((a, b) => a.position.y.compareTo(b.position.y));
      if (_border.isNotEmpty) {
        return _border.last.position + Direction(direction).vector;
      }
      return super.getNextPosition(width, height, mobs);
    } else if ((position + directionVector).y < 0) {
      var _border = mobs
          .where((b) => b.position.y > position.y && b.position.x == position.x)
          .toList()
        ..sort((a, b) => b.position.y.compareTo(a.position.y));
      if (_border.isNotEmpty) {
        return _border.last.position + Direction(direction).vector;
      }
      return super.getNextPosition(width, height, mobs);
    } else if (mobs
        .where((b) => b.position == super.getNextPosition(width, height, mobs))
        .isNotEmpty) {
      return mobs
          .where(
              (b) => b.position == super.getNextPosition(width, height, mobs))
          .first
          .findLastEmptyCell(direction, mobs, width, height);
    } else {
      return super.getNextPosition(width, height, mobs);
    }
  }

  void spawnPointer(List<Entity> pointers, List<Bound> bounds) {
    spawnEntities(
        pointers.length,
        pointers,
        [Pointer.arrowMob(getNextPosition(width, height, bounds))],
        width,
        height);
  }

  @override
  void move(width, height, bounds) {
    position = getNextPosition(width, height, bounds);
  }

  @override
  Impressions getAnimationImpression() {
    return Impressions.arrowMobAnimation;
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: isAnimated,
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
    );
  }
}

mixin Bound on Mob {
  bool isOn = true;
  Point<int> findLastEmptyCell(
      Directions direction, List<Mob> mobs, int width, int height) {
    List<Bound> borders = mobs.whereType<Bound>().where((b) => b.isOn).toList();

    switch (direction) {
      case Directions.left:
        List<Mob> _borders = borders
            .where(
                (b) => b.position.x > position.x && b.position.y == position.y)
            .toList()
          ..sort((a, b) => a.position.x.compareTo(b.position.x));
        if (_borders.isNotEmpty) {
          return _borders.first.position + Direction(direction).vector;
        }
        return Point(width - 1, position.y);
      case Directions.right:
        List<Mob> _borders = borders
            .where(
                (b) => b.position.x < position.x && b.position.y == position.y)
            .toList()
          ..sort((a, b) => b.position.x.compareTo(a.position.x));
        if (_borders.isNotEmpty) {
          return _borders.first.position + Direction(direction).vector;
        }
        return Point(0, position.y);
      case Directions.up:
        List<Mob> _borders = borders
            .where(
                (b) => b.position.y > position.y && b.position.x == position.x)
            .toList()
          ..sort((a, b) => a.position.y.compareTo(b.position.y));
        if (_borders.isNotEmpty) {
          return _borders.first.position + Direction(direction).vector;
        }
        return Point(position.x, height - 1);
      case Directions.down:
        List<Mob> _borders = borders
            .where(
                (b) => b.position.y < position.y && b.position.x == position.x)
            .toList()
          ..sort((a, b) => b.position.y.compareTo(a.position.y));
        if (_borders.isNotEmpty) {
          return _borders.first.position + Direction(direction).vector;
        }
        return Point(position.x, 0);
      default:
        return position;
    }
  }
}

class Border extends Mob with Bound, Electric {
  @override
  bool get isOn => true;
  int color;
  Border(int id, Point<int> position,
      {int order = 2,
      Impressions impression = Impressions.border,
      Directions direction = Directions.zero,
      this.color = 0,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);
  @override
  Border.clone(Mob mob, Point<int> position, id)
      : this(id, position, color: (mob as Border).color);

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or && !connected) {
        connected = true;
        color = (color + 1) % 8;
      } else if (!or && connected) {
        color = (color - 1) % 8;
        connected = false;
      }
    }
    signals = [];

    return false;
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: Impressions.border,
      parameter: color,
      key: UniqueKey(),
    );
  }
}

class Player extends Mob {
  //Directions direction;
  bool isAlive;
  bool isTurnMade = false;
  int coins = 0;
  Player(Point<int> position,
      {Impressions impression = Impressions.player,
      int order = 15,
      direction = Directions.zero,
      this.isAlive = true})
      : super(65533, position, direction, impression, order, false);
  Player.clone(Mob mob, Point<int> position) : this(position);
  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: true,
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
    );
  }

  @override
  void move(int width, int height, List<Mob> mobs) {}

  bool checkIfWin(List<Mob> mobs, Function win, Function lose) {
    if (mobs.where((mob) => mob.isDangerous).isNotEmpty) {
      isAlive = false;
      lose();

      return true;
    }
    if (mobs.whereType<Exit>().isNotEmpty) {
      isAlive = false;

      win();
      return true;
    }
    if (mobs.whereType<Coin>().isNotEmpty) {
      //mobs.removeWhere((element) => element is Coin);
      coins++;
      return false;
    }
    return false;
  }

  Point<int> calculateMove(m, width, height) {
    if ((position + m).x >= 0 &&
        (position + m).x < width &&
        (position + m).y >= 0 &&
        (position + m).y < height) {
      return position + m;
    }
    return position;
  }

  @override
  void animateLeave(List<Entity> entities) {
    entities.add(AnimationMob.entity(this, direction, order = 15));
  }

  void makeTurn(Point<int> m, List<Mob> mobs, List<Entity> disposables,
      Player playerInstance, int width, int height, Function update) {
    if ((mobs
                .whereType<Bound>()
                .where((b) =>
                    b.isOn && b.position == calculateMove(m, width, height))
                .isEmpty ||
            mobs
                .whereType<Portal>()
                .where((b) => b.isOn && b.position == position)
                .isNotEmpty) &&
        calculateMove(m, width, height) != position) {
      playerInstance.animateLeave(disposables);
      position = calculateMove(m, width, height);
      isTurnMade = true;
      update.call();
      if (isAlive) {}
    }
  }
}

class TimedDoor extends Mob with Bound, Emitter, Electric, Lazy {
  late int turns;

  @override
  bool isOn = false;

  @override
  List<int> connectedTo = [];

  TimedDoor(int id, Point<int> position, this.turns, this.connectedTo)
      : super(id, position, Directions.zero, Impressions.timedDoor, 5, false);
  @override
  TimedDoor.clone(TimedDoor mob, Point<int> position, int id)
      : this(id, position, mob.turns, List.from(mob.connectedTo));
  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: turns > 0 ? impression : Impressions.timedDoorClosed,
      time: turns,
      key: UniqueKey(),
    );
  }

  @override
  void onSignal(bool signal, id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (turns > 0) {
      turns--;
      if (turns == 0) {
        isOn = true;
      }
    }

    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or && !connected) {
        connected = true;

        turns++;
        turns %= 64;
      } else if (!or && connected) {
        if (turns == 0) {
          isOn = false;
        }
        turns--;
        turns %= 64;
        connected = false;
      }
    }
    signals = [];
    return false;
  }
}

class Rotator extends Mob with Electric {
  final bool isAnimated;

  Rotator(int id, Point<int> position, Directions direction,
      {Impressions impression = Impressions.rotator,
      int order = 14,
      bool isDangerous = false,
      this.isAnimated = false})
      : super(id, position, direction, impression, order, isDangerous);
  @override
  Rotator.clone(Rotator mob, Point<int> position, id)
      : this(id, position, mob.direction);

  @override
  void animateLeave(List<Entity> entities) {}

  void rotateMobs(List<Mob> mobInCell) {
    for (var mob in mobInCell) {
      if (mob != this) {
        mob.direction = direction;
      }
    }
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or && !connected) {
        connected = true;

        switch (direction) {
          case Directions.left:
            direction = Directions.up;
            break;
          case Directions.up:
            direction = Directions.right;
            break;
          case Directions.right:
            direction = Directions.down;
            break;
          case Directions.down:
            direction = Directions.left;
            break;
          default:
        }
      } else if (!or && connected) {
        switch (direction) {
          case Directions.left:
            direction = Directions.down;
            break;
          case Directions.up:
            direction = Directions.left;
            break;
          case Directions.right:
            direction = Directions.up;
            break;
          case Directions.down:
            direction = Directions.right;
            break;
          default:
        }
        connected = false;
      }
    }
    signals = [];

    return false;
  }

  @override
  void onSignal(bool signal, id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: isAnimated,
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
    );
  }

  @override
  void move(int width, int height, List<Mob> mobs) {
    return;
  }
}

class Info extends Mob with Electric {
  bool showed = false;
  String dialog;
  Info(int id, Point<int> position, this.dialog,
      {Directions direction = Directions.zero,
      Impressions impression = Impressions.info,
      int order = 10,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);
  @override
  Info.clone(Info mob, Point<int> position, id)
      : this(id, position, mob.dialog);

  showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SkinDialog(id, 'Сообщение', dialog),
    );
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: impression,
      key: UniqueKey(),
    );
  }
}

class Gate extends Mob with Bound, Electric {
  @override
  bool isOn = true;

  Gate(int id, Point<int> position, this.isOn,
      {Directions direction = Directions.zero,
      Impressions impression = Impressions.gateClosed,
      int order = 4,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);
  @override
  Gate.clone(Gate mob, Point<int> position, id) : this(id, position, mob.isOn);

  @override
  void onSignal(bool signal, id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or) {
        isOn = false;
      } else {
        isOn = true;
      }
    }
    signals = [];

    return false;
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: !isOn ? Impressions.gateOpen : Impressions.gateClosed,
      key: UniqueKey(),
    );
  }
}

class Switcher extends Mob with Emitter, Electric, Activable {
  @override
  bool isOn = false;
  @override
  List<int> connectedTo = [];

  List<Mob> mobsPreviousTurn = [];

  Switcher(int id, Point<int> position, this.connectedTo, this.isOn,
      {Impressions impression = Impressions.switcherOff,
      Directions direction = Directions.zero,
      int order = 0,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);

  @override
  Switcher.clone(Switcher mob, Point<int> position, id)
      : this(
          id,
          position,
          List.from(mob.connectedTo),
          mob.isOn,
        );

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: isOn ? Impressions.switcherOn : Impressions.switcherOff,
      key: UniqueKey(),
    );
  }

  @override
  void onSignal(bool signal, id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (scheduledActivation) {
      signals.add(!isOn);
      connected = false;
      scheduledActivation = false;
    }

    if (signals.isNotEmpty) {
      var xor =
          signals.reduce((value, element) => value == element ? false : true);

      if (xor && !connected) {
        connected = true;

        isOn = !isOn;
      } else if (!xor) {
        isOn = false;
        connected = false;
      }
    }
    signals = [];

    return false;
  }
}

class Repeater extends Mob with Electric, Emitter {
  late int repeat;
  //bool isPositive = true;

  @override
  List<int> connectedTo = [];

  Repeater(int id, Point<int> position, this.connectedTo, this.repeat,
      {Impressions impression = Impressions.switcherOff,
      Directions direction = Directions.zero,
      int order = 3,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);

  @override
  Repeater.clone(Repeater mob, Point<int> position, id)
      : this(id, position, List.from(mob.connectedTo), mob.repeat);

  @override
  void onSignal(bool signal, id, [List<Mob> mobs = const []]) {
    signals.add(signal);
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or) {
        connected = true;

        //isPositive = true;
      } else {
        connected = false;
      }
    }
    signals = [];

    return false;
  }

  @override
  void emitSignal(Map<int, Mob> mobsIds, bool signal, List<int> connectedTo) {
    if (connected) {
      int value = 1;
      for (var _id in connectedTo) {
        var _mob = mobsIds[_id];
        if (_mob is Border) {
          _mob.color = (_mob.color + value * repeat) % 8;
        } else if (_mob is TimedDoor) {
          _mob.turns += value * repeat;
        } else if (_mob is Repeater) {
          _mob.repeat += value * repeat;
        } else if (_mob is Annihilator) {
          for (var i = 0; i < repeat; i++) {
            _mob.direction = switchDirection(_mob.direction);
          }
        } else if (_mob is Rotator) {
          for (var i = 0; i < repeat; i++) {
            _mob.direction = switchDirection(_mob.direction);
          }
        }
      }
    }
  }

  Directions switchDirection(Directions direction) {
    switch (direction) {
      case Directions.left:
        return Directions.up;
      case Directions.up:
        return Directions.right;
      case Directions.right:
        return Directions.down;
      case Directions.down:
        return Directions.left;
      default:
        return direction;
    }
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: Impressions.repeater,
      time: repeat,
      key: UniqueKey(),
    );
  }
}

class Coin extends Mob {
  final double angle;
  Coin(
    int id,
    Point<int> position,
    this.angle, {
    Directions direction = Directions.zero,
    Impressions impression = Impressions.coin,
    int order = 1,
    bool isDangerous = false,
  }) : super(id, position, direction, impression, order, isDangerous);

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: Impressions.coin,
      angle: angle,
      key: UniqueKey(),
    );
  }
}

class Annihilator extends Mob with Electric, Emitter, Bound, Lazy, Spawner {
  int turns = 4;
  int charge = 1;

  @override
  List<int> connectedTo = [];

  Annihilator(
    int id,
    Point<int> position,
    Directions direction,
    this.charge,
    this.turns,
    this.connectedTo, {
    Impressions impression = Impressions.annihilator,
    int order = 0,
    bool isDangerous = false,
  }) : super(id, position, direction, impression, order, isDangerous);

  @override
  Annihilator.clone(Annihilator mob, Point<int> position, int id)
      : this(id, position, mob.direction, mob.charge, mob.turns,
            List.from(mob.connectedTo));

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: impression,
      time: turns,
      parameter: charge,
      key: UniqueKey(),
    );
  }

  @override
  void animateLeave(List<Entity> entities) {}

  @override
  Point<int> getNextPosition(int width, int height, List<Mob> mobs) {
    return position;
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    charge %= turns;
    charge++;
    if (signals.isNotEmpty) {
      var or = signals.reduce((value, element) => value || element);
      if (or) {
        switch (direction) {
          case Directions.left:
            direction = Directions.up;
            break;
          case Directions.up:
            direction = Directions.right;
            break;
          case Directions.right:
            direction = Directions.down;
            break;
          case Directions.down:
            direction = Directions.left;
            break;
          default:
        }
      }
    }

    signals = [];

    return false;
  }

  List<Ray> _castRay(
      Map<Point<int>, List<Mob>> mobsAtPoints, int width, int height) {
    // List<Bound> border = List<Bound>.from(
    //     mobs.where((mob) => mob is Bound && mob.isOn).toList());

    // List<Rotator> rotators = mobs.whereType<Rotator>().toList();
    // List<Portal> portals =
    //     mobs.whereType<Portal>().where((p) => p.isOn).toList();
    List<Ray> cells = [];

    var initialDir = direction;
    var pointer = position;

    for (var i = 0; i < 32; i++) {
      var next = pointer + Direction(direction).vector;
      var rs = mobsAtPoints[next]?.whereType<Rotator>() ?? [];

      var ps =
          mobsAtPoints[next]?.whereType<Portal>().where((p) => p.isOn) ?? [];

      if (rs.isNotEmpty) {
        cells.add(Ray(id, next, direction));
        direction = rs.first.direction;
      }

      if (next.x < 0 ||
          next.x >= width ||
          next.y < 0 ||
          next.y >= height ||
          (mobsAtPoints[next] != null &&
              mobsAtPoints[next]!
                  .whereType<Bound>()
                  .where((b) => b.isOn)
                  .isNotEmpty)) {
        break;
      } else {
        if (ps.isNotEmpty) {
          var p = ps.first;
          pointer = Point(pointer.x + p.xShift, pointer.y + p.yShift);
        } else {
          pointer = next;
        }
        cells.add(Ray(id, next, direction));
      }
    }
    direction = initialDir;

    return cells;
  }

  void spawnRay(Map<Point<int>, List<Mob>> mobsAtPoints, int width, int height,
      int index, List<Mob> mobs) {
    if (charge == turns) {
      spawnEntities(
          index, mobs, _castRay(mobsAtPoints, width, height), width, height);
    }
  }

  List<Pointer> _castPointer(
      Map<Point<int>, List<Mob>> mobsAtPoints, int width, int height) {
    // List<Bound> border = List<Bound>.from(
    //     mobs.where((mob) => mob is Bound && mob.isOn).toList());
    // List<Rotator> rotators = mobs.whereType<Rotator>().toList();
    // List<Portal> portals =
    //     mobs.whereType<Portal>().where((p) => p.isOn).toList();
    List<Pointer> cells = [];

    var initialDir = direction;
    var pointer = position;

    for (var i = 0; i < 32; i++) {
      var next = pointer + Direction(direction).vector;
      var rs = mobsAtPoints[next]?.whereType<Rotator>() ?? [];

      var ps =
          mobsAtPoints[next]?.whereType<Portal>().where((p) => p.isOn) ?? [];

      if (rs.isNotEmpty) {
        cells.add(Pointer.ray(next));
        direction = rs.first.direction;
      }

      if (next.x < 0 ||
          next.x >= width ||
          next.y < 0 ||
          next.y >= height ||
          (mobsAtPoints[next] != null &&
              mobsAtPoints[next]!.whereType<Bound>().isNotEmpty)) {
        break;
      } else {
        if (ps.isNotEmpty) {
          var p = ps.first;
          pointer = Point(pointer.x + p.xShift, pointer.y + p.yShift);
        } else {
          pointer = next;
        }
        cells.add(Pointer.ray(next));
      }
    }
    direction = initialDir;

    return cells;
  }

  void spawnPointers(Map<Point<int>, List<Mob>> mobsAtPoints, int width,
      int height, int index, List<Entity> mobs) {
    if (charge == turns - 1 || turns == 1) {
      spawnEntities(index, mobs, _castPointer(mobsAtPoints, width, height),
          width, height);
    }
  }
}

class Ray extends Mob with Disposable {
  Ray(int id, Point<int> position, Directions direction,
      {Impressions impression = Impressions.ray,
      int order = 65535,
      bool isDangerous = true})
      : super(id, position, direction, impression, order, isDangerous);

  @override
  bool get isDangerous => true;

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: isAnimated,
      cellSize: size,
      direction: direction,
      impression: impression,
      fromCenter: true,
      key: UniqueKey(),
    );
  }

  @override
  Point<int> getNextPosition(int width, int height, List<Mob> mobs) {
    return position;
  }
}

class Wire extends Mob with Electric, Emitter {
  @override
  bool isOn = false;
  List<int> connectedTo = [];

  Wire(int id, Point<int> position, this.connectedTo,
      {Directions direction = Directions.zero,
      Impressions impression = Impressions.wireOff,
      int order = 0,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);

  Wire.clone(Wire mob, Point<int> position, int id)
      : this(id, position, List.from(mob.connectedTo));

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: isOn ? Impressions.wireOn : Impressions.wireOff,
      key: UniqueKey(),
    );
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      isOn = signals.reduce((value, element) => value || element);
    } else {
      isOn = false;
    }
    signals = [];
    return false;
  }
}

class Pressure extends Mob with Emitter, Activable {
  bool connected = false;
  List<Mob> mobsPreviousTurn = [];
  @override
  List<int> connectedTo = [];

  Pressure(int id, Point<int> position, this.connectedTo,
      {Impressions impression = Impressions.switcherOff,
      Directions direction = Directions.zero,
      int order = 0,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);

  @override
  Pressure.clone(Pressure mob, Point<int> position, int id)
      : this(
          id,
          position,
          List.from(mob.connectedTo),
        );

  @override
  void emitSignal(Map<int, Mob> mobsIds, bool signal, List<int> connectedTo) {
    if (scheduledActivation) {
      super.emitSignal(mobsIds, true, connectedTo);

      scheduledActivation = false;
    } else {
      super.emitSignal(mobsIds, false, connectedTo);
    }
  }

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: Impressions.activator,
      key: UniqueKey(),
    );
  }
}

class Portal extends Mob with Emitter, Electric {
  late int xShift;
  late int yShift;
  late int color;

  @override
  late bool isOn;

  @override
  List<int> connectedTo = [];

  Portal(int id, Point<int> position, this.connectedTo, this.isOn,
      {this.xShift = 0,
      this.yShift = 0,
      this.color = 7,
      Directions direction = Directions.zero,
      Impressions impression = Impressions.portalOn,
      int order = 1,
      bool isDangerous = false})
      : super(id, position, direction, impression, order, isDangerous);

  Portal.clone(Portal mob, Point<int> position, int id)
      : this(id, position, List.from(mob.connectedTo), mob.isOn);

  @override
  Widget getImpression(double size) {
    return Impression(
      isAnimated: false,
      cellSize: size,
      direction: direction,
      impression: isOn ? Impressions.portalOn : Impressions.portalOff,
      parameter: color,
      key: UniqueKey(),
    );
  }

  void teleportMobs(List<Mob> mobsInCell) {
    for (var m in mobsInCell) {
      if (m != this && isOn) {
        m.position = Point(m.position.x + xShift - m.directionVector.x,
            m.position.y + yShift - m.directionVector.y);
      }
    }
  }

  @override
  bool action(Player playerInstance, List<Entity> disposables) {
    if (signals.isNotEmpty) {
      var xor =
          signals.reduce((value, element) => value == element ? false : true);

      if (xor && !connected) {
        connected = true;

        isOn = !isOn;
      } else if (!xor) {
        isOn = false;
        connected = false;
      }
    }
    signals = [];

    return false;
  }
}

class SkinDialog extends StatelessWidget {
  final int type;
  final int id;
  final bool isPurchasable;
  final int cost;
  final String title;
  final String description;

  const SkinDialog(this.id, this.title, this.description,
      {this.isPurchasable = false, this.cost = 0, this.type = 0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.blueGrey[900],
      content: Text(
        description,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
