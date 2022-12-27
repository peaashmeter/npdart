import 'package:flutter/material.dart';
import 'package:visual_novel/core/director.dart';

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
              text: Director().getStringById(c),
              callback: Director().getFunctionById(c)),
      ],
    );
  }
}

class _OptionContainerState extends State<OptionContainer> {
  late final defaultStyle = Theme.of(context).textTheme.headline4!;
  late final onHoverStyle = Theme.of(context).textTheme.headline4!.apply(
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
                child: const Center(
                  child: Text(
                    'Some english text',
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
