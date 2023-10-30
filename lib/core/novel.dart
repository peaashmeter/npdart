import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/verse.dart';
import 'package:npdart/widgets/game.dart';

class Novel extends StatefulWidget {
  final SaveData initialState;
  const Novel({super.key, required this.initialState});

  @override
  State<Novel> createState() => NovelState._();
}

///The global state of a novel. Visible by design.
///
///You should (in case if you need) access the current global instance via [BuildContext]
///like this: [context.findAncestorStateOfType<NovelState>()].
///
///Note on the performance! Its complexity is O(n) in the element tree.
class NovelState extends State<Novel> {
  late String sceneId;
  late Map<String, dynamic> state;
  final _history = Queue<Verse>();

  List<Verse> get history => List.unmodifiable(_history);

  NovelState._();

  @override
  void initState() {
    sceneId = widget.initialState.sceneId;
    state = widget.initialState.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Game(),
    );
  }

  Object? getData(String key) => state[key];

  Future<void> load(SaveData data) async {
    setState(() {
      data.state;
      sceneId = data.sceneId;
    });
  }

  void removeData(String key) => setState(() {
        state.remove(key);
      });

  ///Binds provided [value] with [key]. Value object must be json-encodable.
  void setData(String key, Object value) => state[key] = value;

  SaveData asSaveData(String description) => SaveData(
      sceneId: sceneId,
      description: description,
      createdAt: DateTime.now(),
      state: state);

  void logVerse(Verse verse) {
    if (_history.length > 100) {
      _history.removeLast();
    }
    _history.addFirst(verse);
  }
}

extension GlobalState on BuildContext {
  NovelState get globalState => findAncestorStateOfType<NovelState>()!;
}
