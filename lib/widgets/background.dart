import 'package:flutter/material.dart';

class BackgroundImage extends StatefulWidget {
  final String initialImage;

  const BackgroundImage({
    Key? key,
    required this.initialImage,
  }) : super(key: key);

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  late String _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.initialImage;
  }

  @override
  void didUpdateWidget(covariant BackgroundImage oldWidget) {
    _currentImage = widget.initialImage;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizedBox.expand(
          child: FadeTransition(
            opacity: animation,
            child: child,
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
}
