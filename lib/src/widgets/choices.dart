import 'dart:io';

import 'package:flutter/material.dart';
import 'package:npdart/src/core/event.dart';
import 'package:npdart/src/core/stage.dart';

///Список выборов, которые есть на сцене
class OptionLayer extends StatelessWidget {
  const OptionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final choices = InheritedStage.of(context).notifier?.choices;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var c in choices!)
            OptionContainer(size: size, text: c.label, callback: c.callback),
        ],
      ),
    );
  }
}

class OptionContainer extends StatefulWidget {
  final String text;
  final Function callback;

  final Size size;

  const OptionContainer({
    Key? key,
    required this.size,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  late final defaultStyle = Theme.of(context).textTheme.headlineMedium!;
  late final onHoverStyle = Theme.of(context).textTheme.headlineMedium!.apply(
        color: Colors.white,
      );

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (event) => setState(() {
          hover = true;
        }),
        onExit: (event) => setState(() {
          hover = false;
        }),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              final result = widget.callback();
              InheritedStage.of(context)
                  .notifier!
                  .dispatchEvent(DialogOptionEvent(result: result));
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0),
                ], stops: const [
                  0.05,
                  0.20,
                  0.80,
                  0.95
                ]),
              ),
              height: Platform.isWindows || Platform.isMacOS || Platform.isLinux
                  ? 57
                  : null,
              width: widget.size.width * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                    style: hover ? onHoverStyle : defaultStyle,
                    child: Center(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
