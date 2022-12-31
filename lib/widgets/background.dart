import 'package:flutter/material.dart';

class BackgroundImage extends StatefulWidget {
  final String initialImage;
  final ValueNotifier<Offset> mousePosNotifier;

  const BackgroundImage({
    Key? key,
    required this.initialImage,
    required this.mousePosNotifier,
  }) : super(key: key);

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  //Отношение перемещения фона к перемещению мыши
  final parallaxFactor = 0.002;
  late String _currentImage;

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
      child: Image.asset(
        'assets/backgrounds/$_currentImage',
        key: ValueKey(_currentImage),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant BackgroundImage oldWidget) {
    _currentImage = widget.initialImage;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _currentImage = widget.initialImage;
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
