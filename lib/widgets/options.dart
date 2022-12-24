import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';

///Список выборов, которые есть на сцене
class OptionSpan extends StatelessWidget {
  final List<String>? choices;
  const OptionSpan({super.key, this.choices});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var c in choices ?? [])
          OptionContainer(
              size: size,
              text: Director().getString(c),
              callback: Director().getFunction(c)),
      ],
    );
  }
}

class OptionContainer extends StatefulWidget {
  final String text;
  final Function callback;

  const OptionContainer({
    Key? key,
    required this.size,
    required this.text,
    required this.callback,
  }) : super(key: key);

  final Size size;

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  final defaultStyle =
      TextStyle(fontSize: 24, color: Colors.yellow.shade100, shadows: const [
    Shadow(
      blurRadius: 2,
      offset: Offset(2, 2),
    ),
  ]);

  final onHoverStyle =
      const TextStyle(fontSize: 24, color: Colors.white, shadows: [
    Shadow(
      blurRadius: 2,
      offset: Offset(2, 2),
    ),
  ]);

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
          onTap: () => widget.callback.call(),
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
            width: widget.size.width * 0.7,
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
