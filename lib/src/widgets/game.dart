import 'dart:io';

import 'package:flutter/material.dart';
import 'package:npdart/src/core/event.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';
import 'package:npdart/src/widgets/background.dart';
import 'package:npdart/src/widgets/choices.dart';
import 'package:npdart/src/widgets/sprites.dart';
import 'package:npdart/src/widgets/textbox.dart';
import 'package:npdart/src/widgets/ui/ui.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with WidgetsBindingObserver {
  late Stage stage;
  late Size size;

  @override
  void initState() {
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
    //do not affect the bgm while running on desktop.
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) return;
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
    );
  }
}
