import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/event.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/widgets/ui/border.dart';
import 'package:npdart/widgets/ui/menu.dart';

class UiLayer extends StatefulWidget {
  const UiLayer({super.key});

  @override
  State<UiLayer> createState() => _UiLayerState();
}

class _UiLayerState extends State<UiLayer> {
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stage = InheritedStage.of(context).notifier!;
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space) {
          stage.dispatchEvent(RequestNextEvent());
        } else if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          showMenu();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0),
              child: InkWell(
                  onTap: showMenu,
                  child: UiBorder(
                    child: Icon(
                      Icons.menu_rounded,
                      color: Colors.white30.withOpacity(0.3),
                    ),
                  )),
            )),
      ),
    );
  }

  void showMenu() => showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => const MenuDialog());
}
