import 'mobs.dart';

List<Mob> decodeMobs(
    List<Map<String, Map<String, dynamic>>> mobs, width, height) {
  List<Mob> _mobs = [];
  Mob _makeMob(String literal, Map<String, dynamic> params) {
    switch (literal) {
      case 'arrowMob':
        return ArrowMob(params['id'] ?? 0, params['position'],
            params['direction'], height, width,
            isAnimated: true);
      case 'exit':
        return Exit(params['id'] ?? 0, params['position']);
      case 'border':
        return Border(params['id'] ?? 0, params['position'],
            color: params['color'] ?? 0);
      case 'rotator':
        return Rotator(
            params['id'] ?? 0, params['position'], params['direction']);
      case 'switcher':
        return Switcher(params['id'] ?? 0, params['position'],
            params['connectedTo'].cast<int>(), params['isOn']);
      case 'gate':
        return Gate(params['id'] ?? 0, params['position'], params['isOn']);
      case 'timedDoor':
        return TimedDoor(params['id'] ?? 0, params['position'], params['turns'],
            params['connectedTo']?.cast<int>() ?? []);
      case 'coin':
        return Coin(params['id'], params['position'], params['angle']);
      case 'info':
        return Info(params['id'], params['position'], params['dialog']);
      case 'repeater':
        return Repeater(params['id'] ?? 0, params['position'],
            params['connectedTo'].cast<int>(), params['repeat'] ?? 0);
      case 'annihilator':
        return Annihilator(
          params['id'] ?? 0,
          params['position'],
          params['direction'],
          params['charge'] ?? 0,
          params['turns'] ?? 0,
          params['connectedTo'].cast<int>(),
        );
      case 'wire':
        return Wire(params['id'] ?? 0, params['position'],
            params['connectedTo'].cast<int>());
      case 'activator':
        return Pressure(params['id'] ?? 0, params['position'],
            params['connectedTo'].cast<int>());
      case 'portal':
        return Portal(
          params['id'] ?? 0,
          params['position'],
          params['connectedTo'].cast<int>(),
          params['isOn'] ?? true,
          xShift: params['xShift'] ?? 0,
          yShift: params['yShift'] ?? 0,
          color: params['color'] ?? 7,
        );
      default:
        throw ('Can\'t decode mob: $literal');
    }
  }

  for (var _m in mobs) {
    _mobs.add(_makeMob(_m.keys.first, _m[_m.keys.first]!));
  }
  return _mobs;
}

List<Map<String, Map<String, dynamic>>> encodeMobs(List<Mob> mobs) {
  List<Map<String, Map<String, dynamic>>> mobsEncoded = [];

  Map<String, Map<String, dynamic>> _makeMob(Mob mob) {
    if (mob is ArrowMob) {
      return {
        'arrowMob': {
          'id': mob.id,
          'position': mob.position,
          'direction': mob.direction
        }
      };
    } else if (mob is Exit) {
      return {
        'exit': {'id': mob.id, 'position': mob.position}
      };
    } else if (mob is Border) {
      return {
        'border': {'id': mob.id, 'position': mob.position, 'color': mob.color}
      };
    } else if (mob is Rotator) {
      return {
        'rotator': {
          'id': mob.id,
          'position': mob.position,
          'direction': mob.direction
        }
      };
    } else if (mob is Switcher) {
      return {
        'switcher': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
          'isOn': mob.isOn,
        }
      };
    } else if (mob is Gate) {
      return {
        'gate': {
          'id': mob.id,
          'position': mob.position,
          'isOn': mob.isOn,
        }
      };
    } else if (mob is TimedDoor) {
      return {
        'timedDoor': {
          'id': mob.id,
          'position': mob.position,
          'turns': mob.turns,
          'connectedTo': mob.connectedTo,
          'direction': mob.direction
        }
      };
    } else if (mob is Coin) {
      return {
        'coin': {'id': mob.id, 'position': mob.position, 'angle': mob.angle}
      };
    } else if (mob is Info) {
      return {
        'info': {'id': mob.id, 'position': mob.position, 'dialog': mob.dialog}
      };
    } else if (mob is Repeater) {
      return {
        'repeater': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
          'repeat': mob.repeat,
        }
      };
    } else if (mob is Annihilator) {
      return {
        'annihilator': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
          'charge': mob.charge,
          'turns': mob.turns,
          'direction': mob.direction
        }
      };
    } else if (mob is Wire) {
      return {
        'wire': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
          'direction': mob.direction
        }
      };
    } else if (mob is Pressure) {
      return {
        'activator': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
        }
      };
    } else if (mob is Portal) {
      return {
        'portal': {
          'id': mob.id,
          'position': mob.position,
          'connectedTo': mob.connectedTo,
          'xShift': mob.xShift,
          'yShift': mob.yShift,
          'color': mob.color,
          'isOn': mob.isOn,
        }
      };
    } else {
      throw Exception('Can\'t encode mob: $mob');
    }
  }

  for (var mob in mobs) {
    if (mob is! Player) {
      mobsEncoded.add(_makeMob(mob));
    }
  }
  return mobsEncoded;
}
