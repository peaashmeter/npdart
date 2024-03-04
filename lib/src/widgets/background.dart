import 'package:flutter/material.dart';
import 'package:npdart/src/core/mouse.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';

class BackgroundLayer extends StatefulWidget {
  const BackgroundLayer({
    Key? key,
  }) : super(key: key);

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  //Отношение перемещения фона к перемещению мыши
  late double parallaxFactor;

  @override
  void didChangeDependencies() {
    parallaxFactor =
        InheritedNovelState.of(context).snapshot.preferences.backgroundParallax;
    super.didChangeDependencies();
  }

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
              child: Transform.translate(
                offset: _calculateParallax(
                    InheritedMouse.of(context).mousePos, center),
                child: Transform.scale(
                    //увеличение для того, чтобы компенсировать сдвиг параллакса
                    scale: 1 + 2 * parallaxFactor,
                    filterQuality: FilterQuality.none,
                    child: child),
              ),
            ),
          );
        },
        child: InheritedStage.of(context).notifier?.background ??
            Container(
              color: Colors.black,
            ));
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
