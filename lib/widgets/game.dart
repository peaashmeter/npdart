import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/mouse.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/background.dart';
import 'package:npdart/widgets/choices.dart';
import 'package:npdart/widgets/sprites.dart';
import 'package:npdart/widgets/textbox.dart';
import 'package:npdart/widgets/ui/ui.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with WidgetsBindingObserver {
  late Stage stage;
  late Size size;

  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //create a new stage for each new global state
    final state = InheritedNovelState.of(context).snapshot;
    stage = Stage(audio: state.audio);
    state.tree.getScene(state.sceneId).script(stage, state).then(
        (snapshot) => NovelStateEvent(snapshot: snapshot).dispatch(context));

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      stage.audio.resumeBackgroundSound();
    } else {
      stage.audio.pauseBackgroundSound();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stage.audio.smoothlyStopBackground(const Duration(seconds: 1));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        stage.dispatchEvent(RequestNextEvent());
      },
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            stage.dispatchEvent(RequestNextEvent());
          }
        },
        child: InheritedStage(
          notifier: stage,
          child: Navigator(
              onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => const Stack(
                      children: [
                        BackgroundLayer(),
                        SpriteLayer(),
                        TextLayer(),
                        OptionLayer(),
                        UiLayer(),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}

class ParralaxHandler extends StatefulWidget {
  const ParralaxHandler({super.key});

  @override
  State<ParralaxHandler> createState() => _ParralaxHandlerState();
}

class _ParralaxHandlerState extends State<ParralaxHandler>
    with SingleTickerProviderStateMixin {
  Offset mousePos = Offset.zero;
  late AnimationController fakeMouseController;
  late Animation<double> fakeMouseAnimation;

  @override
  void initState() {
    fakeMouseController =
        AnimationController(duration: const Duration(seconds: 7), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: fakeMouseController,
      curve: Curves.easeInOutSine,
      reverseCurve: Curves.easeInOutSine,
    );
    fakeMouseAnimation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    fakeMouseController.repeat(
      reverse: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    mousePos = Offset(size.width * fakeMouseAnimation.value,
        size.height / 2 - sin(pi * fakeMouseAnimation.value) * size.height / 2);

    return InheritedMouse(mousePos: mousePos, child: const Game());
  }
}
