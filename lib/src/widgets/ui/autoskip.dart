import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/src/core/core.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';

class AutoskipDialog extends StatefulWidget {
  const AutoskipDialog({
    super.key,
  });

  @override
  State<AutoskipDialog> createState() => _AutoskipDialogState();
}

class _AutoskipDialogState extends State<AutoskipDialog> {
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stage =
        context.getInheritedWidgetOfExactType<InheritedStage>()!.notifier!;
    final state = InheritedNovelState.of(context).snapshot;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final visitedScenes = await getVisitedScenes(state.preferences.savePath);
      await autoskip(stage, state, visitedScenes);
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space) {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black54,
        ),
      ),
    );
  }

  Future<bool> autoskip(
      Stage stage, NovelStateSnapshot state, Set<String> visited) async {
    if (!mounted) return true;
    if (!visited.contains(state.sceneId)) return true;
    if (stage.choices.isNotEmpty) return true;

    stage.dispatchEvent(RequestNextEvent());
    await Future.delayed(Duration(milliseconds: 50));

    return autoskip(stage, state, visited);
  }
}
