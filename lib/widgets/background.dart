import 'package:flutter/material.dart';
import 'package:visual_novel/core/stage.dart';

class BackgroundLayer extends StatefulWidget {
  final ValueNotifier<Offset> mousePosNotifier;

  const BackgroundLayer({
    Key? key,
    required this.mousePosNotifier,
  }) : super(key: key);

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  //Отношение перемещения фона к перемещению мыши
  final parallaxFactor = 0.002;

  @override
  Widget build(BuildContext context) {
    final center = MediaQuery.of(context).size / 2;

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SizedBox.expand(
            child: FadeTransition(
              opacity: animation,
              child: ValueListenableBuilder(
                valueListenable: widget.mousePosNotifier,
                builder: (context, mousePos, _) {
                  return Transform.translate(
                    offset: _calculateParallax(mousePos, center),
                    child: Transform.scale(
                        //увеличение для того, чтобы компенсировать сдвиг параллакса
                        scale: 1 + parallaxFactor,
                        filterQuality: FilterQuality.none,
                        child: child),
                  );
                },
              ),
            ),
          );
        },
        child: InheritedStage.of(context).background);
  }

  Offset _calculateParallax(Offset mousePos, Size center) {
    //Рассматриваем это как вектор с измерениями вдвое меньше размеров экрана
    //(x, y) = (width, heigth)
    final center = MediaQuery.of(context).size / 2;

    final offsetX = (center.width - mousePos.dx) * parallaxFactor;
    final offsetY = (center.height - mousePos.dy) * parallaxFactor;

    return Offset(offsetX, offsetY);
  }
}
