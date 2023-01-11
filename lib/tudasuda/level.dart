import 'dart:math';
import 'package:json_annotation/json_annotation.dart';

import 'game/directions.dart';
part 'level.g.dart';

@JsonSerializable(explicitToJson: true)
class Level {
  final int width;
  final int height;
  @JsonKey(toJson: _pointToJson, fromJson: _pointFromJson)
  final Point<int> playerPos;
  @JsonKey(toJson: _mobsToJson, fromJson: _mobsFromJson)
  final List<Map<String, Map<String, dynamic>>> mobs;
  final int turnTime;
  final String title;
  final String dialog;
  final int turns;
  final bool deathTimer;
  final double boardSize;
  const Level(
      {required this.width,
      required this.height,
      required this.playerPos,
      required this.mobs,
      required this.title,
      this.turns = 0,
      this.turnTime = 0,
      this.deathTimer = false,
      this.dialog = '',
      this.boardSize = 7});
  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  const Level.empty(this.title,
      {this.width = 4,
      this.height = 4,
      this.playerPos = const Point<int>(0, 0),
      this.mobs = const [],
      this.turnTime = 0,
      this.dialog = '',
      this.deathTimer = false,
      this.turns = 0,
      this.boardSize = 7});
  Map<String, dynamic> toJson() => _$LevelToJson(this);

  static Map<String, dynamic>? _pointToJson(Point<int>? playerPos) =>
      playerPos != null
          ? <String, dynamic>{"x": playerPos.x, "y": playerPos.y}
          : null;

  static Point<int> _pointFromJson(Map<String, dynamic>? coords) {
    if (coords != null && coords['x'] != null && coords['y'] != null) {
      return Point<int>(coords['x']!, coords['y']!);
    } else {
      return const Point(0, 0);
    }
  }

  static List<Map<String, Map<String, dynamic>>>? _mobsToJson(
      List<Map<String, Map<String, dynamic>>>? mobs) {
    if (mobs != null) {
      var l = <Map<String, Map<String, dynamic>>>[];
      for (var m in mobs) {
        Map<String, Map<String, dynamic>> mob = {};
        mob.addAll({m.keys.first: {}});

        mob.values.first.addAll({
          "id": m.values.first['id'],
          "position": {
            "x": (m.values.first['position'] as Point<int>).x,
            "y": (m.values.first['position'] as Point<int>).y
          }
        });
        if (m.values.first['direction'] != null) {
          mob.values.first.addAll(
              {"direction": (m.values.first['direction'] as Directions).index});
        }
        if (m.values.first['connectedTo'] != null) {
          mob.values.first.addAll(
              {"connectedTo": (m.values.first['connectedTo'].cast<int>())});
        }
        if (m.values.first['isOn'] != null) {
          mob.values.first.addAll({"isOn": (m.values.first['isOn'])});
        }
        if (m.values.first['turns'] != null) {
          mob.values.first.addAll({"turns": (m.values.first['turns'])});
        }
        if (m.values.first['dialog'] != null) {
          mob.values.first.addAll({"dialog": (m.values.first['dialog'])});
        }
        if (m.values.first['color'] != null) {
          mob.values.first.addAll({"color": (m.values.first['color'])});
        }
        if (m.values.first['repeat'] != null) {
          mob.values.first.addAll({"repeat": (m.values.first['repeat'])});
        }
        if (m.values.first['charge'] != null) {
          mob.values.first.addAll({"charge": (m.values.first['charge'])});
        }
        if (m.values.first['xShift'] != null) {
          mob.values.first.addAll({"xShift": (m.values.first['xShift'])});
        }
        if (m.values.first['yShift'] != null) {
          mob.values.first.addAll({"yShift": (m.values.first['yShift'])});
        }
        l.add(mob);
      }
      return l;
    }
    return null;
  }

  static List<Map<String, Map<String, dynamic>>> _mobsFromJson(m) {
    List<Map<String, Map<String, dynamic>>>? l = [];
    for (int i = 0; i < m.length; i++) {
      var mob = m[i];
      l.add({mob.keys.first: {}});
      l[i][mob.keys.first]!.addAll({
        "id": mob.values.first['id'],
        "position": Point<int>(mob.values.first['position']['x'],
            mob.values.first['position']['y'])
      });
      if (mob.values.first['direction'] != null) {
        l[i][mob.keys.first]!.addAll(
            {"direction": Directions.values[mob.values.first['direction']]});
      }
      if (mob.values.first['connectedTo'] != null) {
        l[i][mob.keys.first]!
            .addAll({"connectedTo": mob.values.first['connectedTo']});
      }
      if (mob.values.first['isOn'] != null) {
        l[i][mob.keys.first]!.addAll({"isOn": mob.values.first['isOn']});
      }
      if (mob.values.first['turns'] != null) {
        l[i][mob.keys.first]!.addAll({"turns": mob.values.first['turns']});
      }
      if (mob.values.first['dialog'] != null) {
        l[i][mob.keys.first]!.addAll({"dialog": mob.values.first['dialog']});
      }
      if (mob.values.first['color'] != null) {
        l[i][mob.keys.first]!.addAll({"color": mob.values.first['color']});
      }
      if (mob.values.first['repeat'] != null) {
        l[i][mob.keys.first]!.addAll({"repeat": mob.values.first['repeat']});
      }
      if (mob.values.first['charge'] != null) {
        l[i][mob.keys.first]!.addAll({"charge": mob.values.first['charge']});
      }
      if (mob.values.first['xShift'] != null) {
        l[i][mob.keys.first]!.addAll({"xShift": mob.values.first['xShift']});
      }
      if (mob.values.first['yShift'] != null) {
        l[i][mob.keys.first]!.addAll({"yShift": mob.values.first['yShift']});
      }
    }
    return l;
  }
}
