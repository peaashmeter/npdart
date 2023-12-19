import 'dart:io';

import 'package:flutter/material.dart';

class MenuOption extends StatefulWidget {
  final String text;
  final Function callback;
  const MenuOption({super.key, required this.text, required this.callback});

  @override
  State<MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
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
            onTap: () => widget.callback(),
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
              width: MediaQuery.sizeOf(context).width * 0.5,
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
