import 'package:flutter/material.dart';
import 'package:npdart/core/singletons/stage.dart';

class UiLayer extends StatelessWidget {
  const UiLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withOpacity(0),
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const MenuDialog());
                },
                child: UiBorder(
                  child: Icon(
                    Icons.menu_rounded,
                    color: Colors.white30.withOpacity(0.3),
                  ),
                )),
          )),
    );
  }
}

class MenuDialog extends StatelessWidget {
  const MenuDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: Colors.white30.withOpacity(0.3), width: 2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuOption(
                text: 'History',
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => const HistoryContainer());
                }),
            MenuOption(text: 'Save', callback: () {}),
            MenuOption(text: 'Load', callback: () {}),
            MenuOption(text: 'Main Menu', callback: () {}),
          ],
        ),
      ),
    );
  }
}

class HistoryContainer extends StatelessWidget {
  const HistoryContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0),
        content: Container(
          width: MediaQuery.sizeOf(context).width * 2 / 3,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Colors.white30.withOpacity(0.3), width: 2)),
          child: ListView(
            children: Stage()
                .history
                .map((verse) => ListTile(
                      title: Text(
                        verse.header,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .apply(color: verse.color),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        verse.string,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}

class UiBorder extends StatelessWidget {
  final Widget? child;
  const UiBorder({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white30.withOpacity(0.3), width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

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
        child: GestureDetector(
          onTap: () => widget.callback(),
          child: Container(
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
            height: 57,
            width: MediaQuery.sizeOf(context).width * 0.5,
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
    );
  }
}
