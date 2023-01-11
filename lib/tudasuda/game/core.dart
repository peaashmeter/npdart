import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import 'entities.dart';

import 'impressions.dart';
import 'mob_handler.dart';
import 'mobs.dart';
import '../level.dart';

import 'directions.dart';

late ValueNotifier<Player> playerNotifier;

class Core extends ChangeNotifier {
  List<Mob> mobs = [];
  final Level level;
  late Player playerInstance;
  List<Entity> disposables = [];
  final Function nextLevel;
  final Function replay;
  final double size;
  late int width;
  late int height;
  Map<Point<int>, List<Mob>> mobsAtPoints = {};
  Map<int, Mob> mobsIds = {};
  List<Bound> bounds = [];
  List<Portal> portals = [];
  List<Rotator> rotators = [];
  List<ValueNotifier<CellNotifierData>> cellsNotifiers = [];
  late List<List<Entity>> cellChildren;
  late bool isPlaying;
  final bool isPlayerInvincible;
  final BuildContext context;
  late HashSet<int> changedCells1;
  late HashSet<int> _pointers;

  Core(this.level, this.size, this.nextLevel, this.replay, this.context,
      {this.isPlayerInvincible = false}) {
    width = level.width;
    height = level.height;

    isPlaying = false;

    mobs = List.from(decodeMobs(level.mobs, width, height))
      ..sort((x, y) {
        int compare = x.order.compareTo(y.order);
        if (compare == 0) {
          return x.id.compareTo(y.id);
        } else {
          return compare;
        }
      });

    playerInstance = Player(level.playerPos);
    mobs.add(playerInstance);

    //creating a map of empty lists
    for (var i = 0; i < width * height; i++) {
      var point = Point<int>(i % width, i ~/ width);
      mobsAtPoints.addAll({point: []});
    }
    //filling a map & creating an ids map
    for (var mob in mobs) {
      mobsAtPoints[mob.position]!.add(mob);
      mobsIds.addAll({mob.id: mob});
      if (mob is Bound && mob.isOn) {
        bounds.add(mob);
      }
      if (mob is Rotator) {
        rotators.add(mob);
      }
      if (mob is Portal) {
        portals.add(mob);
      }
    }

    playerNotifier = ValueNotifier(playerInstance);

    cellChildren = List.generate(width * height, (index) => []);
    changedCells1 = HashSet();
    _pointers = HashSet();
    //changedCells2 = HashSet();

    makeBoard();
  }

  void makeBoard() {
    doGameCycle(true);
    playerNotifier.notifyListeners();
    //isPlaying = true;

    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => isPlaying = true);
  }

  void destroyBoard() {
    isPlaying = false;

    List<List<Entity>> cellChildren =
        List.generate(width * height, (index) => []);

    remakeLists();

    Map<int, List<Notificator>> notificators = {};
    for (int i = 0; i < mobs.length; i++) {
      var m = mobs[i];
      cellChildren[m.getLinearPosition(width)].add(m);
    }

    for (var e in disposables) {
      cellChildren[e.getLinearPosition(width)].add(e);
    }

    mobs.removeWhere((mob) => mob is Disposable);

    for (int j = 0; j < cellChildren.length; j++) {
      var c = cellChildren[j];
      c.sort((a, b) => a.order.compareTo(b.order));

      if (c.whereType<Pointer>().isNotEmpty && c.whereType<Mob>().isNotEmpty) {
        notificators[j] != null
            ? notificators[j]!.add(Notificator(
                cellSize: size,
                icon: Notificators.pointer,
                key: UniqueKey(),
              ))
            : notificators[j] = [
                Notificator(
                  cellSize: size,
                  icon: Notificators.pointer,
                  key: UniqueKey(),
                )
              ];
      }
      if (c.where((m) => m is Mob && m is! AnimationMob).length > 1) {
        notificators[j] != null
            ? notificators[j]!.add(Notificator(
                cellSize: size,
                icon: Notificators.other,
                key: UniqueKey(),
              ))
            : notificators[j] = [
                Notificator(
                  cellSize: size,
                  icon: Notificators.other,
                  key: UniqueKey(),
                )
              ];
      }
    }

    for (var i = 0; i < cellsNotifiers.length; i++) {
      var x = i % width;
      var y = i ~/ width;

      if ((x - playerInstance.position.x).abs() < 10 &&
          (y - playerInstance.position.y).abs() < 15) {
        cellsNotifiers[i].value = CellNotifierData(
            CellAnimations.none,
            notificators[i] ?? [],
            List.generate(cellChildren[i].length,
                (index) => cellChildren[i][index].getImpression(size)));
        cellsNotifiers[i].notifyListeners();
      }
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      for (var i = 0; i < cellsNotifiers.length; i++) {
        var x = i % width;
        var y = i ~/ width;

        if ((x - playerInstance.position.x).abs() < 10 &&
            (y - playerInstance.position.y).abs() < 15) {
          cellsNotifiers[i].value = CellNotifierData(
              CellAnimations.destroy,
              notificators[i] ?? [],
              List.generate(
                  cellChildren[i]
                      .where((element) => element is! AnimationMob)
                      .length, (index) {
                return AnimationMob.entity(
                        cellChildren
                            .where((element) => element is! AnimationMob)
                            .toList()[i][index],
                        Directions.zero)
                    .getImpression(size);
              }));
          cellsNotifiers[i].notifyListeners();
        }
      }
    });

    playerNotifier.notifyListeners();
  }

  void updateState() {
    doGameCycle(false);
    playerNotifier.notifyListeners();
  }

  void doGameCycle(bool isMake) {
    changedCells1 = HashSet();
    // disposables
    //     .whereType<Pointer>()
    //     .forEach((p) => changedCells1.add(p.getLinearPosition(width)));

    //loop of activation

    for (var p in _pointers) {
      cellChildren[p].removeWhere((element) => element is Pointer);
    }

    for (var i = 0; i < mobs.length; i++) {
      var mob = mobs[i];

      if (mob is Player && !isPlayerInvincible && !isMake) {
        if (mob.checkIfWin(
            mobs
                .where((element) => element.position == playerInstance.position)
                .toList(),
            nextLevel,
            replay)) {
          return;
        }
      }

      if (mob is Info && playerInstance.position != mob.position) {
        mob.showed = false;
      }

      if (mob is Annihilator) {
        mob.spawnPointers(
            mobsAtPoints, width, height, disposables.length, disposables);
        mob.spawnRay(mobsAtPoints, width, height, mobs.length, mobs);
      }

      if (mob is ArrowMob) {
        mob.animateLeave(disposables);
      }

      if ((!isMake || mob is! Lazy) && mob is! Emitter && mob is! Electric) {
        mob.action(playerInstance, disposables);
      }

      if (!isMake) {
        mobsAtPoints[mob.position]?.remove(mob);
        mob.move(width, height, bounds);
        mobsAtPoints[mob.position]?.add(mob);
      }

      if (mob is Portal) {
        mob.teleportMobs(mobsAtPoints[mob.position]!);
      }

      if (mob is Info && mob.position == playerInstance.position) {
        if (!mob.showed) {
          mob.showInfo(context);
          mob.showed = true;
        }
      }
    }
    remakeLists();

    for (var cell in mobsAtPoints.values) {
      if (cell.isNotEmpty && cell.last is! Activable) {
        cell.last.scheduleActivation(mobsAtPoints);
      }
    }
    //loop of mechanisms
    for (var mob in mobs) {
      if (mob is Emitter) {
        mob.emitSignal(mobsIds, mob is Electric ? (mob as Electric).isOn : true,
            mob.connectedTo);
      }
      if (mob is Emitter || mob is Electric) {
        mob.action(playerInstance, disposables);
      }

      if (mob is Rotator) {
        mob.rotateMobs(mobsAtPoints[mob.position]!);
      }
    }
    //loop of spawning
    for (var mob in mobs) {
      if (mob is ArrowMob) {
        mob.spawnPointer(disposables, bounds);
        continue;
      }
    }

    for (var e in disposables) {
      var pos = e.getLinearPosition(width);

      if (!changedCells1.contains(pos)) {
        cellChildren[pos] = [e];
      } else {
        cellChildren[pos].add(e);
      }

      changedCells1.add(pos);
    }

    Map<int, List<Notificator>> notificators = {};
    for (int i = 0; i < mobs.length; i++) {
      var m = mobs[i];
      var pos = m.getLinearPosition(width);
      if (!changedCells1.contains(pos)) {
        cellChildren[pos] = [m];
      } else {
        cellChildren[pos].add(m);
      }

      changedCells1.add(pos);
    }

    mobs.removeWhere((mob) => mob is Disposable);
    mobs.removeWhere(
        (mob) => mob is Coin && mob.position == playerInstance.position);

    for (int j = 0; j < cellChildren.length; j++) {
      var c = cellChildren[j];
      c.sort((a, b) => a.order.compareTo(b.order));

      if (c.whereType<Pointer>().isNotEmpty && c.whereType<Mob>().isNotEmpty) {
        notificators[j] != null
            ? notificators[j]!.add(Notificator(
                cellSize: size,
                icon: Notificators.pointer,
                key: UniqueKey(),
              ))
            : notificators[j] = [
                Notificator(
                  cellSize: size,
                  icon: Notificators.pointer,
                  key: UniqueKey(),
                )
              ];
      }
      if (c.where((m) => m is Mob && m is! AnimationMob).length > 1) {
        notificators[j] != null
            ? notificators[j]!.add(Notificator(
                cellSize: size,
                icon: Notificators.other,
                key: UniqueKey(),
              ))
            : notificators[j] = [
                Notificator(
                  cellSize: size,
                  icon: Notificators.other,
                  key: UniqueKey(),
                )
              ];
      }
    }

    if (isMake) {
      for (var i = 0; i < cellChildren.length; i++) {
        cellsNotifiers.add(ValueNotifier(CellNotifierData(
            isMake ? CellAnimations.create : CellAnimations.none,
            notificators[i] ?? [],
            List.generate(cellChildren[i].length,
                (index) => cellChildren[i][index].getImpression(size)))));
      }
    } else {
      for (var i in changedCells1.union(_pointers)) {
        // var x = i % width;
        // var y = i ~/ width;

        cellsNotifiers[i].value = CellNotifierData(
            CellAnimations.none,
            notificators[i] ?? [],
            List.generate(cellChildren[i].length,
                (index) => cellChildren[i][index].getImpression(size)));
      }
    }

    mobs = List.from(mobs);
    _pointers = HashSet();
    disposables
        .whereType<Pointer>()
        .forEach((p) => _pointers.add(p.getLinearPosition(width)));
    disposables = [];
  }

  void remakeLists() {
    mobsAtPoints = {};
    bounds = [];
    portals = [];
    rotators = [];

    //// creating a map of empty lists
    // for (var i = 0; i < width * height; i++) {
    //   var point = Point<int>(i % width, i ~/ width);
    //   mobsAtPoints.addAll({point: []});
    // }
    //filling a map & creating an ids map
    for (var mob in mobs) {
      if (mob is Bound && mob.isOn) {
        bounds.add(mob);
      }
      if (mob is Portal && mob.isOn) {
        portals.add(mob);
      }
      if (mob is Rotator) {
        rotators.add(mob);
      }

      if (mobsAtPoints.containsKey(mob.position)) {
        mobsAtPoints[mob.position]!.add(mob);
      } else {
        mobsAtPoints.addAll({
          mob.position: [mob]
        });
      }

      // mobsIds.addAll({mob.id: mob});

    }
  }

  void movePlayer(Directions d) {
    if (playerInstance.isAlive && isPlaying) {
      switch (d) {
        case Directions.right:
          playerInstance.direction = Directions.right;
          playerInstance.makeTurn(const Point(1, 0), mobs, disposables,
              playerInstance, width, height, updateState);
          break;
        case Directions.down:
          playerInstance.direction = Directions.down;
          playerInstance.makeTurn(const Point(0, 1), mobs, disposables,
              playerInstance, width, height, updateState);
          break;

        case Directions.left:
          playerInstance.direction = Directions.left;
          playerInstance.makeTurn(const Point(-1, 0), mobs, disposables,
              playerInstance, width, height, updateState);
          break;

        case Directions.up:
          playerInstance.direction = Directions.up;
          playerInstance.makeTurn(const Point(0, -1), mobs, disposables,
              playerInstance, width, height, updateState);
          break;
        default:
      }
    }
  }
}

// class PlayerMoveNotifier extends ChangeNotifier {
//   final Player playerInstance;

//   PlayerMoveNotifier(this.playerInstance);

//   ///call this after player's move
//   void registerPlayerMove() {
//     notifyListeners();
//   }
// }

class TimeIndicator extends StatefulWidget {
  final Core core;
  final Function replay;
  final int time;
  final bool isKilling;
  final ValueNotifier<Object> notifier;

  const TimeIndicator(
      {Key? key,
      required this.time,
      required this.isKilling,
      required this.core,
      required this.replay,
      required this.notifier})
      : super(key: key);

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> sizeAnimation;
  late Animation<Color?> colorAnimation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.time), vsync: this);

    sizeAnimation = Tween<double>(begin: 1, end: 0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(controller)
      ..addListener(() {
        setState(() {});
      });
    colorAnimation = ColorTween(begin: Colors.green, end: Colors.red)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.reset();
    controller.forward().then((value) {
      if (widget.core.isPlaying) {
        if (widget.isKilling) {
          widget.replay();
        } else {
          widget.core.playerInstance.direction = Directions.zero;
          widget.core.updateState();
          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
          widget.notifier.notifyListeners();
        }
      }
      widget.core.playerInstance.isTurnMade = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: sizeAnimation.value * MediaQuery.of(context).size.width,
      color: colorAnimation.value,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DPad extends StatelessWidget {
  final double cellSize;
  final void Function(Directions) movePlayer;
  final Core core;
  const DPad(
      {Key? key,
      required this.cellSize,
      required this.movePlayer,
      required this.core})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: cellSize * 3 + 12,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DPadButton(
                  action: () => movePlayer(Directions.up),
                  icon: Icons.arrow_upward_rounded,
                  cellSize: cellSize,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DPadButton(
                  action: () => movePlayer(Directions.left),
                  icon: Icons.arrow_back_rounded,
                  cellSize: cellSize,
                ),
                DPadButton(
                  action: () => {},
                  icon: Icons.fiber_manual_record_rounded,
                  cellSize: cellSize,
                ),
                DPadButton(
                  action: () => movePlayer(Directions.right),
                  icon: Icons.arrow_forward_rounded,
                  cellSize: cellSize,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DPadButton(
                  action: () => movePlayer(Directions.down),
                  icon: Icons.arrow_downward_rounded,
                  cellSize: cellSize,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DPadButton extends StatefulWidget {
  final Function action;
  final IconData icon;
  final double cellSize;
  const DPadButton(
      {Key? key,
      required this.action,
      required this.icon,
      required this.cellSize})
      : super(key: key);

  @override
  State<DPadButton> createState() => _DPadButtonState();
}

class _DPadButtonState extends State<DPadButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: widget.cellSize,
        height: widget.cellSize,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF263238))),
          onPressed: () {
            widget.action.call();
          },
          child: Icon(widget.icon),
        ),
      ),
    );
  }
}

class CellNotifierData {
  late CellAnimations animation;
  late List<Notificator> notificators;
  late List<Widget> children;

  CellNotifierData(this.animation, this.notificators, this.children);

  @override
  bool operator ==(Object other) {
    if (other is CellNotifierData &&
        animation == other.animation &&
        notificators == other.notificators &&
        children == other.children) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => 1;
}

class Cell extends StatefulWidget {
  final double size;
  final ValueNotifier<CellNotifierData> notifier;

  const Cell({Key? key, required this.size, required this.notifier})
      : super(key: key);

  const Cell.animate({Key? key, required this.size, required this.notifier})
      : super(key: key);

  const Cell.empty({Key? key, required this.size, required this.notifier})
      : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (context, CellNotifierData notifier, child) {
        if (notifier.animation != CellAnimations.none) {
          return AnimatedCell(
            children: notifier.children,
            animation: notifier.animation,
            notificators: notifier.notificators,
            size: widget.size,
            key: widget.key,
          );
        } else {
          var padding = 0.2 * widget.size;

          return ClipRRect(
            borderRadius: BorderRadius.circular(padding),
            child: SizedBox(
              width: widget.size,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                    )),
                    Stack(
                      fit: StackFit.expand,
                      children: notifier.children,
                    ),
                    Positioned(
                      top: widget.size * 0.05,
                      right: widget.size * 0.05,
                      child: Column(children: notifier.notificators),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

enum CellAnimations { none, create, destroy }

class AnimatedCell extends StatefulWidget {
  final double size;
  final List<Widget> children;
  final List<Notificator> notificators;
  final CellAnimations animation;
  const AnimatedCell(
      {Key? key,
      required this.children,
      required this.size,
      required this.animation,
      required this.notificators})
      : super(key: key);

  @override
  State<AnimatedCell> createState() => _AnimatedCellState();
}

class _AnimatedCellState extends State<AnimatedCell>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    if (widget.animation == CellAnimations.create) {
      animation = Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(curve: Curves.easeIn))
          .animate(controller)
        ..addListener(() {
          setState(() {});
        });
    } else {
      animation = Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.easeOut))
          .animate(controller)
        ..addListener(() {
          setState(() {});
        });
    }
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var size = widget.size;
    var padding = 0.2 * size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(padding),
      child: SizedBox(
        width: size,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Padding(
            padding: EdgeInsets.all(size / 2 * animation.value),
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                )),
                Stack(
                  fit: StackFit.expand,
                  children: widget.children,
                ),
                Positioned(
                  top: size * 0.05,
                  right: size * 0.05,
                  child: Column(children: widget.notificators),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Board extends StatefulWidget {
  final double cellSize;
  final double xCellsOnScreen;
  final double yCellsOnScreen;
  final int height;
  final int width;
  final Player playerInstance;
  final List<ValueNotifier<CellNotifierData>> cellsNotifiers;

  const Board(
      {Key? key,
      required this.cellSize,
      required this.xCellsOnScreen,
      required this.yCellsOnScreen,
      required this.height,
      required this.width,
      required this.playerInstance,
      required this.cellsNotifiers})
      : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  //late LinkedScrollControllerGroup _controllers;

  late ScrollController horizontalController;
  late ScrollController verticalController;

  late Widget cellsGrid;

  @override
  void initState() {
    super.initState();
    var dy = _calculateDy(widget.playerInstance);

    verticalController = ScrollController(initialScrollOffset: dy);
    cellsGrid = _makeCellsGrid();
  }

  double _calculateDx(Player playerInstance) {
    return playerInstance.position.x * widget.cellSize -
        widget.cellSize * widget.xCellsOnScreen * 0.5 +
        widget.cellSize * 0.5;
  }

  double _calculateDy(Player playerInstance) {
    return playerInstance.position.y * widget.cellSize -
        widget.cellSize * widget.yCellsOnScreen * 0.5 +
        widget.cellSize * 0.5;
  }

  Widget _makeCellsGrid() {
    List<List<Cell>> _cells = List.generate(widget.height, (index) => []);

    //generating list of lists where i is dy and j is dx (top to down and left to right oriented)
    for (var i = 0; i < widget.height; i++) {
      for (var j = 0; j < widget.width; j++) {
        _cells[i].add(Cell(
            key: UniqueKey(),
            size: widget.cellSize,
            notifier: widget.cellsNotifiers[i * widget.width + j]));
      }
    }

    List<Widget> rows = [];
    for (int k = 0; k < _cells.length; k++) {
      var row = _cells[k];

      var r = Center(
          child: BoardRow(
        key: UniqueKey(),
        row: row,
        size: widget.cellSize,
        calculateDx: _calculateDx,
      ));

      rows.add(r);
    }

    var grid = ValueListenableBuilder(
      valueListenable: playerNotifier,
      builder: (context, Player value, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          var dy = _calculateDy(playerNotifier.value) < 0
              ? 0.0
              : _calculateDy(playerNotifier.value);
          dy = dy > verticalController.position.maxScrollExtent
              ? verticalController.position.maxScrollExtent
              : dy;
          verticalController.animateTo(dy,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        });

        return ScrollConfiguration(
          behavior: OffGlowScrollBehavior().copyWith(scrollbars: false),
          child: ListView.builder(
            controller: verticalController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rows.length,
            itemBuilder: (context, index) =>
                RepaintBoundary(child: rows[index]),
          ),
        );
      },
    );

    return grid;
  }

  @override
  Widget build(BuildContext context) {
    return cellsGrid;
  }
}

class OffGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class BoardRow extends StatefulWidget {
  final double size;
  final List<Cell> row;

  final double Function(Player) calculateDx;
  const BoardRow(
      {Key? key,
      required this.row,
      required this.size,
      required this.calculateDx})
      : super(key: key);

  @override
  State<BoardRow> createState() => _BoardRowState();
}

class _BoardRowState extends State<BoardRow> {
  late ScrollController horizontalController;

  @override
  void initState() {
    horizontalController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var dx = widget.calculateDx(playerNotifier.value);

      horizontalController.animateTo(dx,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ValueListenableBuilder(
          valueListenable: playerNotifier,
          builder: (context, Player value, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              var dx = widget.calculateDx(playerNotifier.value) < 0
                  ? 0.0
                  : widget.calculateDx(playerNotifier.value);
              dx = dx > horizontalController.position.maxScrollExtent
                  ? horizontalController.position.maxScrollExtent
                  : dx;

              horizontalController.animateTo(dx,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            });

            return ScrollConfiguration(
              behavior: OffGlowScrollBehavior().copyWith(scrollbars: false),
              child: ListView.builder(
                controller: horizontalController,
                itemBuilder: (context, index) => RepaintBoundary(
                  child: widget.row[index],
                ),
                itemCount: widget.row.length,
                itemExtent: widget.size,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          },
        ),
      ),
    );
  }
}

class InteractiveBoard extends StatefulWidget {
  final double cellSize;
  final double xCellsOnScreen;
  final double yCellsOnScreen;
  final int height;
  final int width;
  final Player playerInstance;
  final List<ValueNotifier<CellNotifierData>> cellsNotifiers;
  const InteractiveBoard(
      {Key? key,
      required this.cellSize,
      required this.xCellsOnScreen,
      required this.yCellsOnScreen,
      required this.height,
      required this.width,
      required this.playerInstance,
      required this.cellsNotifiers})
      : super(key: key);

  @override
  State<InteractiveBoard> createState() => _InteractiveBoardState();
}

class _InteractiveBoardState extends State<InteractiveBoard> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        constrained: false,
        clipBehavior: Clip.none,
        child: Board(
          cellSize: widget.cellSize,
          xCellsOnScreen: widget.xCellsOnScreen,
          yCellsOnScreen: widget.yCellsOnScreen,
          height: widget.height,
          width: widget.width,
          playerInstance: widget.playerInstance,
          cellsNotifiers: widget.cellsNotifiers,
          key: UniqueKey(),
        ));
  }
}
