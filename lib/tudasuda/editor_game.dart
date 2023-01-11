import 'dart:async';

import 'package:flutter/material.dart' hide Border;
import 'package:flutter/services.dart';
import 'game/directions.dart';

import 'game/core.dart';
import 'level.dart';

class EditorGame extends StatefulWidget {
  final Level level;
  const EditorGame({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  State<EditorGame> createState() => _GameState();

  double getCellSize(BuildContext context, double xCellsOnScreen) {
    const size = 57.0;
    return size;
  }

  double getYCellsOnScreen(
      Level level, BuildContext context, double xCellsOnScreen) {
    return level.height <=
            1 / MediaQuery.of(context).size.aspectRatio * xCellsOnScreen - 2
        ? level.height.toDouble()
        : 1 / MediaQuery.of(context).size.aspectRatio * xCellsOnScreen - 2;
  }
}

class _GameState extends State<EditorGame> {
  late double xCellsOnScreen;
  late double yCellsOnScreen;

  ValueNotifier<bool> isOnPause = ValueNotifier(false);

  late Core core;
  late Level level;
  late double cellSize;
  late bool isDpad;

  late Board board;

  bool isDialogShown = false;

  ValueNotifier<Object> timer = ValueNotifier(Object);

  //make player don't move while holding movement keys
  bool isReadyToMove = true;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    isDpad = false;
    level = widget.level;
    xCellsOnScreen = level.boardSize;

    focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    cellSize = widget.getCellSize(context, xCellsOnScreen);
    yCellsOnScreen = xCellsOnScreen;

    core = Core(level, cellSize, nextLevel, replay, context);

    board = Board(
      cellSize: cellSize,
      xCellsOnScreen: xCellsOnScreen,
      yCellsOnScreen: yCellsOnScreen,
      height: core.height,
      width: core.width,
      playerInstance: core.playerInstance,
      cellsNotifiers: core.cellsNotifiers,
      key: UniqueKey(),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKeyEvent: (key) {
        if (key is KeyUpEvent && !isReadyToMove) {
          Future.delayed(
              const Duration(milliseconds: 100), () => isReadyToMove = true);

          return;
        }
        if (key is KeyUpEvent || !isReadyToMove) return;
        if (key.physicalKey == PhysicalKeyboardKey.keyW) {
          core.movePlayer(Directions.up);
        } else if (key.physicalKey == PhysicalKeyboardKey.keyA) {
          core.movePlayer(Directions.left);
        } else if (key.physicalKey == PhysicalKeyboardKey.keyS) {
          core.movePlayer(Directions.down);
        } else if (key.physicalKey == PhysicalKeyboardKey.keyD) {
          core.movePlayer(Directions.right);
        } else if (key.logicalKey == LogicalKeyboardKey.escape) {
          isOnPause.value = true;
          (showMenuDialog(context, level)
              .then((value) => isOnPause.value = false));
        }

        isReadyToMove = false;
      },
      child: GestureDetector(
          onHorizontalDragEnd: (details) {
            var v = details.primaryVelocity;
            if (v != 0 && v != null) {
              if (v > 0) {
                core.movePlayer(Directions.right);
              } else {
                core.movePlayer(Directions.left);
              }
            }
          },
          onVerticalDragEnd: (details) {
            var v = details.primaryVelocity;
            if (v != 0 && v != null) {
              if (v > 0) {
                core.movePlayer(Directions.down);
              } else {
                core.movePlayer(Directions.up);
              }
            }
          },
          child: WillPopScope(
            onWillPop: () async {
              isOnPause.value = true;
              return (showMenuDialog(context, level)
                  .then((value) => isOnPause.value = false));
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey[900],
                title: Text(level.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                actions: [
                  IconButton(
                      onPressed: () {
                        isOnPause.value = true;
                        showMenuDialog(context, level)
                            .then((value) => isOnPause.value = false);
                      },
                      icon: const Icon(Icons.menu_rounded))
                ],
                flexibleSpace: SizedBox(
                  height: cellSize * 2,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ValueListenableBuilder(
                        valueListenable: timer,
                        builder: (context, value, child) {
                          return ValueListenableBuilder(
                            valueListenable: playerNotifier,
                            builder: (context, value, child) =>
                                ValueListenableBuilder(
                                    valueListenable: isOnPause,
                                    builder: (BuildContext context, bool pause,
                                        Widget? child) {
                                      if (level.turnTime == 0 ||
                                          isOnPause.value) {
                                        return Container(
                                          height: 4,
                                          color: Colors.blueGrey[900],
                                        );
                                      }
                                      return TimeIndicator(
                                        key: UniqueKey(),
                                        time: level.turnTime,
                                        isKilling: level.deathTimer,
                                        core: core,
                                        replay: replay,
                                        notifier: timer,
                                      );
                                    }),
                          );
                        },
                      )),
                ),
              ),
              body: Container(
                color: Colors.black,
                child: Center(
                  child: Container(
                    width: widget.getCellSize(context, xCellsOnScreen) *
                        xCellsOnScreen,
                    height: widget.getCellSize(context, xCellsOnScreen) *
                        xCellsOnScreen,
                    color: Colors.black,
                    child: Align(
                      alignment: Alignment.center,
                      child: Builder(builder: (context) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          if (!isDialogShown && level.dialog != '') {
                            isOnPause.value = true;
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    backgroundColor: Colors.blueGrey[900],
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(level.dialog,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blueGrey[50],
                                                fontSize: 20)),
                                      ),
                                    ],
                                  );
                                }).then((value) => isOnPause.value = false);
                            isDialogShown = true;
                          }
                        });
                        return board;
                      }),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<dynamic> showMenuDialog(BuildContext context, Level level) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.blueGrey[900],
            title: Text('pause',
                style: TextStyle(color: Colors.blueGrey[50], fontSize: 30)),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  replay();
                  Navigator.pop(context);
                },
                child: Text('replay',
                    style: TextStyle(color: Colors.blueGrey[50], fontSize: 20)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          backgroundColor: Colors.blueGrey[900],
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(level.dialog,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey[50],
                                      fontSize: 20)),
                            ),
                          ],
                        );
                      });
                },
                child: Text('show_dialog',
                    style: TextStyle(color: Colors.blueGrey[50], fontSize: 20)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  isDialogShown = false;

                  int count = 0;
                  Navigator.popUntil(context, (route) => count++ == 2);
                },
                child: Text('to_editor',
                    style: TextStyle(color: Colors.blueGrey[50], fontSize: 20)),
              ),
            ],
          );
        });
  }

  void replay() {
    core.destroyBoard();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        core = Core(level, cellSize, nextLevel, replay, context);

        board = Board(
          cellSize: cellSize,
          xCellsOnScreen: xCellsOnScreen,
          yCellsOnScreen: yCellsOnScreen,
          height: core.height,
          width: core.width,
          playerInstance: core.playerInstance,
          cellsNotifiers: core.cellsNotifiers,
          key: UniqueKey(),
        );
      });
    });
  }

  void nextLevel() {
    core.destroyBoard();
    isDialogShown = false;
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      Navigator.pop(context);
    });
  }
}
