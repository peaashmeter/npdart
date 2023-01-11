import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game/directions.dart';
import 'game/mobs.dart';

class Pattern {
  List<Mob> mobs;
  List<Point<int>> path;
  List<Point<int>> idealPath;
  Pattern(this.mobs, this.path, this.idealPath);
}

//weights are deprecated; used before to make some patterns appear later
Map<Function, double> getPatternGenerators() {
  var map = <Function, double>{};

  map.addAll({plain: 1});

  map.addAll({yWall: 1});

  map.addAll({xWall: 1});

  map.addAll({plainHard: 1});

  map.addAll({yCross: 1});

  map.addAll({laserRoom: 1});

  map.addAll({portals: 1});

  return map;
}

List<Point<int>> pathTrace(List<Point<int>> waypoints, int width, int height,
    List<Point<int>> forbidden, List<double> distortions) {
  List<Point<int>> path = [waypoints.first];
  for (var i = 0; i < waypoints.length - 1; i++) {
    path.addAll(_trace(waypoints[i], waypoints[i + 1], width, height, forbidden,
        distortions[i]));
  }
  return path;
}

List<Point<int>> _trace(Point<int> from, Point<int> to, int width, int height,
    List<Point<int>> forbidden, double distortion) {
  List<Point<int>> path = [];
  Point<int> pointer = from;
  List<Point<int>> aStarVisited = [];
  do {
    Map<Point<int>, double> paceWeights = {};

    double lesserWeight;
    if (path.length < 2 * (width + height)) {
      lesserWeight = distortion;
    } else {
      lesserWeight = 0;
    }

    if (pointer.x + 1 < width &&
        !forbidden.contains(Point(pointer.x + 1, pointer.y))) {
      if (_countDistance(Point(pointer.x + 1, pointer.y), to) <
          _countDistance(Point(pointer.x, pointer.y), to)) {
        paceWeights.addAll({Point(pointer.x + 1, pointer.y): 1});
      } else {
        paceWeights.addAll({Point(pointer.x + 1, pointer.y): lesserWeight});
      }
    }
    if (pointer.x - 1 >= 0 &&
        !forbidden.contains(Point(pointer.x - 1, pointer.y))) {
      if (_countDistance(Point(pointer.x - 1, pointer.y), to) <
          _countDistance(Point(pointer.x, pointer.y), to)) {
        paceWeights.addAll({Point(pointer.x - 1, pointer.y): 1});
      } else {
        paceWeights.addAll({Point(pointer.x - 1, pointer.y): lesserWeight});
      }
    }

    if (pointer.y + 1 < height &&
        !forbidden.contains(Point(pointer.x, pointer.y + 1))) {
      if (_countDistance(Point(pointer.x, pointer.y + 1), to) <
          _countDistance(Point(pointer.x, pointer.y), to)) {
        paceWeights.addAll({Point(pointer.x, pointer.y + 1): 1});
      } else {
        paceWeights.addAll({Point(pointer.x, pointer.y + 1): lesserWeight});
      }
    }
    if (pointer.y - 1 >= 0 &&
        !forbidden.contains(Point(pointer.x, pointer.y - 1))) {
      if (_countDistance(Point(pointer.x, pointer.y - 1), to) <
          _countDistance(Point(pointer.x, pointer.y), to)) {
        paceWeights.addAll({Point(pointer.x, pointer.y - 1): 1});
      } else {
        paceWeights.addAll({Point(pointer.x, pointer.y - 1): lesserWeight});
      }
    }

    if (path.length > 20) {
      paceWeights.removeWhere((key, value) => aStarVisited.contains(key));
      //paceWeights.removeWhere((key, value) => value != 1);
      if (paceWeights.isEmpty) {
        aStarVisited = [];
      }
      aStarVisited.add(pointer);
    }

    double totalWeight =
        paceWeights.values.fold(0, (prev, element) => prev + element);
    double rand = Random().nextDouble() * totalWeight;
    double s = 0;
    for (var p in paceWeights.entries) {
      s += p.value;
      if (s >= rand) {
        path.add(p.key);
        pointer = p.key;
        break;
      }
    }
    // if (path.length > 50) {
    //   throw Exception('from: $from, to: $to');
    // }
  } while (pointer != to);
  return path;
}

int _countDistance(Point<int> a, Point<int> b) {
  return (b.x - a.x).abs() + (b.y - a.y).abs();
}

bool plain(int width, int height, List<Pattern> patterns) {
  var start = Point<int>(0, height - 1);
  var end = Point<int>(width - 1, 0);
  List<Point<int>> path =
      pathTrace([start, end], width, height, [], [0.15, 0.15]);
  List<Point<int>> idealPath =
      pathTrace([start, end], width, height, [], List.filled(2, 0));
  patterns.add(Pattern([], path, idealPath));
  return true;
}

bool plainHard(int width, int height, List<Pattern> patterns) {
  var start = Point<int>(0, height - 1);
  var end = Point<int>(width - 1, 0);
  List<Point<int>> path =
      pathTrace([start, end], width, height, [], [0.3, 0.3]);
  List<Point<int>> idealPath =
      pathTrace([start, end], width, height, [], List.filled(2, 0));
  patterns.add(Pattern([], path, idealPath));
  return true;
}

bool timedSimple(int width, int height, List<Pattern> patterns) {
  var start = Point<int>(0, height - 1);

  var end = Point<int>(width - 1, 0);
  var door = Random().nextBool() == true
      ? Point<int>(width - 2, 0)
      : Point<int>(width - 1, 1);
  var border = door == Point<int>(width - 2, 0)
      ? Point<int>(width - 1, 1)
      : Point<int>(width - 2, 0);
  List<Point<int>> path = pathTrace(
      [start, door, end], width, height, [border], [0.15, 0.15, 0.15]);
  List<Point<int>> idealPath =
      pathTrace([start, door, end], width, height, [border], List.filled(3, 0));

  List<Mob> mobs = [TimedDoor(0, door, path.length - 1, []), Border(1, border)];
  patterns.add(Pattern(mobs, path, idealPath));
  return true;
}

bool laserRoom(int width, int height, List<Pattern> patterns) {
  if (height >= 6 && width >= 5) {
    List<Mob> mobs = [];
    List<Point<int>> forbidden = [];

    var start = Point<int>(0, 1 + Random().nextInt(height - 2));
    var end = Point<int>(width - 1, 1 + Random().nextInt(height - 2));

    int upperLaserX = Random().nextInt(width - 2) + 1;
    int lowerLaserX = Random().nextInt(width - 2) + 1;

    List<Point<int>> upperRay =
        List.generate(height - 2, (y) => Point(upperLaserX, y + 1));
    List<Point<int>> lowerRay =
        List.generate(height - 2, (y) => Point(lowerLaserX, y + 1));

    for (var i = 0; i < width; i++) {
      forbidden.add(Point(i, 0));
      forbidden.add(Point(i, height - 1));

      if (i != upperLaserX) {
        mobs.add(Border(mobs.length, Point(i, 0)));
      }

      if (i != lowerLaserX) {
        mobs.add(Border(mobs.length, Point(i, height - 1)));
      }
    }

    List<Point<int>> path =
        pathTrace([start, end], width, height, forbidden, [0.15, 0.15]);
    List<Point<int>> idealPath =
        pathTrace([start, end], width, height, forbidden, List.filled(2, 0));

    List<int> turnsOnUpperRay = [];
    for (var i = 0; i < path.length; i++) {
      if (upperRay.contains(path[i])) {
        turnsOnUpperRay.add(i + 1);
      }
    }
    int upperReload = 4;

    if (turnsOnUpperRay.isNotEmpty) {
      upperReload = turnsOnUpperRay.first + 1;

      for (var n in turnsOnUpperRay) {
        if (n % upperReload == 0) {
          upperReload++;
        }
      }
    }

    List<int> turnsOnLowerRay = [];
    for (var i = 0; i < path.length; i++) {
      if (lowerRay.contains(path[i])) {
        turnsOnLowerRay.add(i + 1);
      }
    }

    int lowerReload = 4;

    if (turnsOnLowerRay.isNotEmpty) {
      lowerReload = turnsOnLowerRay.first + 1;

      for (var n in turnsOnLowerRay) {
        if (n % lowerReload == 0) {
          lowerReload++;
          break;
        }
      }
    }

    mobs.add(Annihilator(mobs.length, Point(upperLaserX, 0), Directions.down, 1,
        upperReload, []));

    mobs.add(Annihilator(mobs.length, Point(lowerLaserX, height - 1),
        Directions.up, 1, lowerReload, []));

    patterns.add(Pattern(mobs, path, idealPath));

    return true;
  }
  return false;
}

bool yWall(int width, int height, List<Pattern> patterns) {
  _findStartPos(Point<int> gap) {
    if (gap.y > height ~/ 2) {
      return const Point<int>(0, 0);
    } else {
      return Point<int>(0, height - 1);
    }
  }

  _findEndPos(Point<int> gap) {
    if (gap.y > height ~/ 2) {
      return Point<int>(width - 1, 0);
    } else {
      return Point<int>(width - 1, height - 1);
    }
  }

  if (width % 2 == 1 && width > 4) {
    int middle = width ~/ 2;
    List<Mob> mobs = [];
    List<Point<int>> forbidden = [];
    List<Point<int>> waypoints = [];

    for (var i = 0; i < height; i++) {
      mobs.add(Border(0, Point<int>(middle, i)));
      forbidden.add(Point<int>(middle, i));
    }
    var remove = Random().nextInt(mobs.length);
    mobs.removeAt(remove);
    forbidden.removeAt(remove);
    var gap = Point<int>(middle, remove);
    waypoints.add(_findStartPos(gap));
    waypoints.add(gap);
    waypoints.add(_findEndPos(gap));
    if (kDebugMode) {
      print('waypoints: $waypoints');
    }
    List<Point<int>> path =
        pathTrace(waypoints, width, height, forbidden, [0.15, 0.15, 0.15]);
    List<Point<int>> idealPath = pathTrace(
        waypoints, width, height, forbidden, List.filled(waypoints.length, 0));
    patterns.add(Pattern(mobs, path, idealPath));
    return true;
  } else {
    return false;
  }
}

bool xWall(int width, int height, List<Pattern> patterns) {
  _findStartPos(Point<int> gap) {
    if (gap.x > width ~/ 2) {
      return Point<int>(0, height - 1);
    } else {
      return Point<int>(width - 1, height - 1);
    }
  }

  _findEndPos(Point<int> gap) {
    if (gap.x > width ~/ 2) {
      return const Point<int>(0, 0);
    } else {
      return Point<int>(width - 1, 0);
    }
  }

  if (height % 2 == 1 && height > 4) {
    int middle = height ~/ 2;
    List<Mob> mobs = [];
    List<Point<int>> forbidden = [];
    List<Point<int>> waypoints = [];

    for (var i = 0; i < width; i++) {
      mobs.add(Border(0, Point<int>(i, middle)));
      forbidden.add(Point<int>(i, middle));
    }
    var remove = Random().nextInt(mobs.length);
    mobs.removeAt(remove);
    forbidden.removeAt(remove);
    var gap = Point<int>(remove, middle);
    waypoints.add(_findStartPos(gap));
    waypoints.add(gap);
    waypoints.add(_findEndPos(gap));
    List<Point<int>> path =
        pathTrace(waypoints, width, height, forbidden, [0.15, 0.15, 0.15]);
    List<Point<int>> idealPath = pathTrace(
        waypoints, width, height, forbidden, List.filled(waypoints.length, 0));
    patterns.add(Pattern(mobs, path, idealPath));
    return true;
  } else {
    return false;
  }
}

bool yCross(int width, int height, List<Pattern> patterns) {
  var start = Point<int>(0, height - 1);

  var end = const Point<int>(0, 0);
  if (height % 2 == 1 && width % 2 == 1 && height > 4 && width > 4) {
    int ymiddle = height ~/ 2;
    int xmiddle = width ~/ 2;
    List<Mob> mobs = [];
    List<Point<int>> forbidden = [];
    List<Point<int>> waypoints = [];

    for (var i = 0; i < width; i++) {
      mobs.add(Border(0, Point<int>(i, ymiddle)));
      forbidden.add(Point<int>(i, ymiddle));
    }
    var remove = width ~/ 2 + 1 + Random().nextInt(width ~/ 2 - 1);
    mobs.removeAt(remove);
    forbidden.removeAt(remove);
    var xgap = Point<int>(remove, ymiddle);

    Point<int> ygap1 =
        Point<int>(xmiddle, ymiddle + 1 + Random().nextInt(ymiddle));
    Point<int> ygap2 = Point<int>(xmiddle, Random().nextInt(ymiddle));

    for (var i = 0; i < height; i++) {
      if (i != ygap1.y && i != ygap2.y) {
        mobs.add(Border(0, Point<int>(xmiddle, i)));
        forbidden.add(Point<int>(xmiddle, i));
      }
    }

    waypoints.add(start);
    waypoints.add(ygap1);
    waypoints.add(xgap);
    waypoints.add(ygap2);
    waypoints.add(end);
    if (kDebugMode) {
      print(waypoints);
    }
    List<Point<int>> path = pathTrace(
        waypoints, width, height, forbidden, [0.15, 0.15, 0.15, 0.15, 0.15]);
    List<Point<int>> idealPath = pathTrace(
        waypoints, width, height, forbidden, List.filled(waypoints.length, 0));
    patterns.add(Pattern(mobs, path, idealPath));
    return true;
  } else {
    return false;
  }
}

bool portals(int width, int height, List<Pattern> patterns) {
  if (height % 2 == 1 && height > 4 && width > 4) {
    var start = Point<int>(Random().nextInt(width), 0);
    var end = Point(Random().nextInt(width), height - 1);
    int ymiddle = height ~/ 2;

    List<Mob> mobs = [];
    List<Point<int>> forbidden = [];
    //List<Point<int>> waypoints = [];

    var portalEntrance = Point(Random().nextInt(width), ymiddle - 1);
    var portalOut = Point(Random().nextInt(width), ymiddle + 1);

    for (var i = 0; i < width; i++) {
      mobs.add(Border(0, Point<int>(i, ymiddle)));
      forbidden.add(Point<int>(i, ymiddle));
    }

    mobs.add(Portal(mobs.length, portalEntrance, [], true,
        yShift: portalOut.y - portalEntrance.y,
        xShift: portalOut.x - portalEntrance.x));
    mobs.add(Portal(
      mobs.length,
      portalEntrance,
      [],
      false,
    ));

    var path = pathTrace(
        [start, portalEntrance], width, height, forbidden, [0.15, 0.15]);
    var idealPath =
        pathTrace([start, portalEntrance], width, height, forbidden, [0, 0]);
    path.addAll(
        pathTrace([portalOut, end], width, height, forbidden, [0.15, 0.15]));
    idealPath
        .addAll(pathTrace([portalOut, end], width, height, forbidden, [0, 0]));
    patterns.add(Pattern(mobs, path, idealPath));

    return true;
  }
  return false;
}
