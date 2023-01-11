import 'dart:math';

import 'package:flutter/material.dart';

import 'directions.dart';

int rngSkinId = 0;

enum Notificators { pointer, other }

class Notificator extends StatelessWidget {
  final icon;
  final double cellSize;
  const Notificator({Key? key, required this.icon, required this.cellSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getIcon(icon);
  }

  _getIcon(Notificators icon) {
    switch (icon) {
      case Notificators.pointer:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: cellSize * 0.1,
            height: cellSize * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red[900],
            ),
          ),
        );
      case Notificators.other:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: cellSize * 0.1,
            height: cellSize * 0.1,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
        );
    }
  }
}

enum Impressions {
  player,
  arrowMob,
  arrowMobPointer,
  arrowMobAnimation,
  exit,
  border,
  rotator,
  switcherOn,
  switcherOff,
  gateOpen,
  gateClosed,
  timedDoor,
  timedDoorClosed,
  coin,
  info,
  repeater,
  annihilator,
  ray,
  rayPointer,
  wireOn,
  wireOff,
  activator,
  portalOn,
  portalOff
}

class Impression extends StatefulWidget {
  final Directions direction;
  final Impressions impression;
  final bool reversed;
  final double cellSize;
  final bool isAnimated;
  final int time;
  final double angle;
  final int parameter;
  final bool fromCenter;
  const Impression({
    Key? key,
    required this.direction,
    required this.impression,
    required this.cellSize,
    this.reversed = false,
    this.isAnimated = true,
    this.time = 0,
    this.angle = 0,
    this.parameter = 0,
    this.fromCenter = false,
  }) : super(key: key);

  @override
  State<Impression> createState() => _ImpressionState();
}

class _ImpressionState extends State<Impression>
    with SingleTickerProviderStateMixin {
  _ImpressionState();

  late Animation<double> animation;
  late AnimationController controller;
  late Impressions impression = widget.impression;
  late Directions direction = widget.direction;
  late Widget child;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.fromCenter ? 1500 : 300),
        vsync: this);
    if (widget.reversed) {
      animation = Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.easeIn))
          .animate(controller)
        ..addListener(() {
          setState(() {});
        });
    } else if (widget.fromCenter) {
      animation = Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.bounceInOut))
          .animate(controller)
        ..addListener(() {
          setState(() {});
        });
    } else {
      animation = Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(curve: Curves.easeOut))
          .animate(controller)
        ..addListener(() {
          setState(() {});
        });
    }

    child = _getImpression(widget.parameter);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.isAnimated
          ? ClipRRect(
              borderRadius: BorderRadius.circular(0.125 * widget.cellSize),
              child: _getAnimation(child),
            )
          : _getImpression(widget.parameter),
    );
  }

  _getAnimation(Widget fill) {
    if (widget.fromCenter) {
      return _rotate(
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.cellSize * animation.value),
            child: fill,
          ),
          direction);
    }
    switch (direction) {
      case Directions.down:
        return Padding(
          padding: widget.reversed
              ? EdgeInsets.only(top: widget.cellSize * animation.value)
              : EdgeInsets.only(bottom: widget.cellSize * animation.value),
          child: fill,
        );
      case Directions.up:
        return Padding(
            padding: widget.reversed
                ? EdgeInsets.only(bottom: widget.cellSize * animation.value)
                : EdgeInsets.only(top: widget.cellSize * animation.value),
            child: fill);
      case Directions.left:
        return Padding(
          padding: widget.reversed
              ? EdgeInsets.only(right: widget.cellSize * animation.value)
              : EdgeInsets.only(left: widget.cellSize * animation.value),
          child: fill,
        );
      case Directions.right:
        return Padding(
          padding: widget.reversed
              ? EdgeInsets.only(left: widget.cellSize * animation.value)
              : EdgeInsets.only(right: widget.cellSize * animation.value),
          child: fill,
        );
      default:
        return fill;
    }
  }

  _getImpression([int parameter = 0]) {
    switch (impression) {
      case Impressions.arrowMob:
        return (getArrowMobImpression(0, direction, widget.cellSize));
      case Impressions.player:
        return getPlayerImpression(0);
      case Impressions.arrowMobPointer:
        return Padding(
          padding: EdgeInsets.all(widget.cellSize * 0.4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
        );
      case Impressions.rayPointer:
        return Padding(
          padding: EdgeInsets.all(widget.cellSize * 0.4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
        );
      case Impressions.arrowMobAnimation:
        return (getArrowMobImpression(0, direction, widget.cellSize));

      case Impressions.exit:
        return Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case Impressions.border:
        return getBorderImpression(0, parameter, widget.cellSize);
      case Impressions.rotator:
        return Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _rotate(
              const FittedBox(child: Icon(Icons.reply_rounded)), direction),
        );
      case Impressions.switcherOff:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.bolt_rounded,
            color: Colors.white70,
          )),
        );
      case Impressions.switcherOn:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.bolt_rounded,
            color: Colors.yellow,
          )),
        );
      case Impressions.gateClosed:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: const FittedBox(
            child: Icon(
              Icons.close_rounded,
              color: Colors.yellow,
            ),
          ),
        );
      case Impressions.gateOpen:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case Impressions.timedDoor:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
          ),
          child: Center(
            child: Text(
              '${widget.time}',
              style: const TextStyle(color: Colors.green, fontSize: 30),
            ),
          ),
        );
      case Impressions.timedDoorClosed:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: const FittedBox(
              child: Icon(
            Icons.timer_rounded,
            color: Colors.red,
          )),
        );
      case Impressions.coin:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.purple[400]!, Colors.purple[600]!])
                .createShader(bounds),
            child: Transform.rotate(
              angle: widget.angle,
              child: Icon(
                Icons.play_arrow_outlined,
                color: Colors.white,
                size: widget.cellSize * 0.5,
              ),
            ),
          ),
        );
      case Impressions.info:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.info_outline,
            color: Colors.white70,
          )),
        );
      case Impressions.repeater:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: FittedBox(
              child: Column(
            children: [
              const Icon(
                Icons.repeat_rounded,
                color: Colors.yellow,
              ),
              Center(
                child: Text(
                  '${widget.time}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          )),
        );
      case Impressions.annihilator:
        return _rotate(
            getAnnihilatorImpression(widget.time, widget.cellSize, parameter),
            direction);
      case Impressions.ray:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, Colors.amber, Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        );
      case Impressions.wireOn:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.cable_rounded,
            color: Colors.yellow,
          )),
        );
      case Impressions.wireOff:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.cable_rounded,
            color: Colors.white70,
          )),
        );
      case Impressions.activator:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FittedBox(
              child: Icon(
            Icons.radio_button_checked_rounded,
            color: Colors.white70,
          )),
        );
      case Impressions.portalOn:
        return getPortalImpression(parameter);
      case Impressions.portalOff:
        return const FittedBox(
          child: Icon(
            Icons.camera_rounded,
            color: Colors.white70,
          ),
        );

      default:
        return const Placeholder();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Widget _rotate(Widget defImp, Directions direction) {
  //calculating the angle via scalar product
  //default direction vector is {-1, 0}
  var v = Direction(direction).vector;
  var d = const Point(-1, 0);
  var cosPhi = (v.x * d.x + v.y * d.y) / (v.magnitude * d.magnitude);

  //calculating the sign of rotation via matrix product
  var sign = (d.x * v.y - d.y * v.x).sign;
  var phi = sign == 0 ? acos(cosPhi) : acos(cosPhi) * sign;
  return Transform.rotate(
    angle: phi,
    child: defImp,
  );
}

Widget getPlayerImpression(int id, {bool preview = false}) {
  switch (id) {
    case 0:
      return Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 1:
      return Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 2:
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 3:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/skins/watermelon.png',
            fit: BoxFit.fill,
          ));
    case 4:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/spider.png', fit: BoxFit.fill));
    case 5:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/turtle.png', fit: BoxFit.fill));
    case 6:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/red_ninja.png', fit: BoxFit.fill));
    case 7:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/blue_ninja.png', fit: BoxFit.fill));
    case 8:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child:
              Image.asset('assets/skins/violet_ninja.png', fit: BoxFit.fill));
    case 9:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child:
              Image.asset('assets/skins/orange_ninja.png', fit: BoxFit.fill));
    case 10:
      return Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Icon(
          Icons.explore_outlined,
          color: Colors.teal[100],
        )),
      );
    case 11:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/avocado.png', fit: BoxFit.fill));
    case 12:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/watermelon_half.png',
              fit: BoxFit.fill));
    case 13:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/slime.png', fit: BoxFit.fill));
    case 14:
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.red,
                Colors.amber,
                Colors.amber,
                Colors.lightGreen,
                Colors.lightGreen,
                Colors.lightBlue,
                Colors.lightBlue,
                Colors.indigo,
                Colors.indigo
              ],
              stops: [
                0,
                0.2,
                0.2,
                0.4,
                0.4,
                0.6,
                0.6,
                0.8,
                0.8,
                1,
              ]),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 15:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/pumpkin.png', fit: BoxFit.fill));
    case 16:
      return !preview
          ? getPlayerImpression(rngSkinId)
          : Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                  child: Icon(
                Icons.casino_outlined,
                color: Colors.red[100],
              )),
            );
    case 17:
      return Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.construction_rounded,
            color: Colors.indigo[100],
          ),
        )),
      );
    case 18:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/ball.png', fit: BoxFit.fill));
    case 19:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/gingerbread.png', fit: BoxFit.fill));
    case 20:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/snowman.png', fit: BoxFit.fill));
    case 21:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/kiwi.png', fit: BoxFit.fill));
    case 22:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/avocado2.png', fit: BoxFit.fill));
    case 23:
      return Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.green[500]!, Colors.green[700]!]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Icon(
          Icons.view_in_ar_rounded,
          color: Colors.grey[900],
        )),
      );
    case 24:
      return Container(
        decoration: BoxDecoration(
          color: Colors.amber[600],
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Icon(
          Icons.stars_outlined,
          color: Colors.amber.shade100,
        )),
      );
    case 25:
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.indigo[600]!, Colors.pink[800]!], radius: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 26:
      return Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const FittedBox(
            child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(
            Icons.whatshot_rounded,
            color: Colors.deepOrange,
          ),
        )),
      );
    case 27:
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/skins/amogus.png',
          fit: BoxFit.fill,
        ),
      );
    case 28:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/skins/golden_watermelon.png',
              fit: BoxFit.fill));
    case 29:
      return Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.science_rounded,
            color: Colors.teal[100],
          ),
        )),
      );
    case 30:
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.red,
                Colors.red,
                Colors.white,
                Colors.white,
                Colors.red,
                Colors.red,
                Colors.white,
                Colors.white,
                Colors.red,
                Colors.red,
              ],
              stops: [
                0,
                0.2,
                0.2,
                0.4,
                0.4,
                0.6,
                0.6,
                0.8,
                0.8,
                1,
              ]),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 31:
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.green,
                Colors.green,
                Colors.white,
                Colors.white,
                Colors.green,
                Colors.green,
                Colors.white,
                Colors.white,
                Colors.green,
                Colors.green,
              ],
              stops: [
                0,
                0.2,
                0.2,
                0.4,
                0.4,
                0.6,
                0.6,
                0.8,
                0.8,
                1,
              ]),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    case 32:
      return Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.emoji_events_rounded,
            color: Colors.cyan[100],
          ),
        )),
      );
    default:
      return Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
      );
  }
}

Widget getArrowMobImpression(int id, Directions dir, double size,
    {bool preview = false}) {
  switch (id) {
    case 0:
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _rotate(
            const FittedBox(child: Icon(Icons.chevron_left_rounded)), dir),
      );
    case 1:
      return Container(
        decoration: BoxDecoration(
          gradient: const RadialGradient(
              colors: [Colors.blue, Colors.indigo], radius: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _rotate(
            Transform.rotate(
                angle: pi,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(
                      child: Icon(
                    Icons.play_arrow_rounded,
                  )),
                )),
            dir),
      );
    case 2:
      return Container(
        decoration: BoxDecoration(
          gradient: const RadialGradient(
              colors: [Colors.indigo, Colors.blue], radius: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _rotate(
            Transform.rotate(
                angle: pi,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(
                      child: Icon(
                    Icons.play_arrow_rounded,
                  )),
                )),
            dir),
      );
    case 3:
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _rotate(
              Image.asset('assets/skins/mimic.png', fit: BoxFit.fill), dir));
    case 4:
      return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 5, 3, 16),
          ),
          child: _rotate(
              Transform.rotate(
                angle: pi,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(colors: [
                              Colors.purple[400]!,
                              Colors.purple[600]!
                            ]).createShader(bounds),
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              dir));
    case 5:
      return Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            Colors.deepPurple[900]!,
            const Color.fromARGB(255, 16, 9, 48)
          ], radius: 0.6)),
          child: _rotate(
              Transform.rotate(
                angle: pi,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(colors: [
                              Colors.purple[400]!,
                              Colors.purple[600]!
                            ]).createShader(bounds),
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              dir));

    default:
      throw Exception('There is no skin with id $id');
  }
}

Widget getBorderImpression(int id, int color, double size) {
  Widget _getBorderImage(int id) {
    switch (id) {
      case 0:
        return Container(
          width: size,
          height: size,
          color: Colors.black,
        );
      case 1:
        return Container(
          width: size,
          height: size,
          color: Colors.black,
          child: FittedBox(
            child: Icon(
              Icons.close_rounded,
              color: Colors.grey[900],
            ),
          ),
        );
      case 2:
        return Container(
          width: size,
          height: size,
          color: Colors.black,
          child: Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.add_rounded,
                color: Colors.grey[900],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.add_rounded,
                color: Colors.grey[900],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.add_rounded,
                color: Colors.grey[900],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.add_rounded,
                color: Colors.grey[900],
              ),
            ),
          ]),
        );
      case 3:
        return Image.asset(
          'assets/skins/watermelon_bw.png',
          fit: BoxFit.fill,
        );
      default:
        throw Exception(
            'Hi dear! The id of Border you got is wrong one! By the way, your id is $id');
    }
  }

  var colors = [
    Colors.black,
    Colors.red[900]!,
    Colors.pink[900]!,
    Colors.purple[900]!,
    Colors.blue[900]!,
    Colors.cyan[900]!,
    Colors.green[900]!,
    Colors.yellow[900]!,
  ];

  return ColorFiltered(
    colorFilter: ColorFilter.mode(colors[color], BlendMode.screen),
    child: _getBorderImage(id),
  );
}

Widget getPortalImpression(int color) {
  switch (color) {
    case 0:
      return const FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.black,
        ),
      );
    case 1:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.red[900],
        ),
      );
    case 2:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.pink[900],
        ),
      );
    case 3:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.purple[900],
        ),
      );
    case 4:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.blue[900],
        ),
      );
    case 5:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.cyan[900],
        ),
      );
    case 6:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.cyan[900],
        ),
      );
    case 7:
      return FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.yellow[900],
        ),
      );
    default:
      return const FittedBox(
        child: Icon(
          Icons.camera_rounded,
          color: Colors.black,
        ),
      );
  }
}

Widget getAnnihilatorImpression(int turns, double size, int charge) {
  return Container(
    color: Colors.black,
    child: Transform.rotate(
      angle: pi,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          Rect rect = Rect.fromLTRB(0, 0, size, size);
          var stop = charge / turns;
          var gradient = LinearGradient(colors: const [
            Colors.orange,
            Colors.orange,
            Colors.white70,
            Colors.white70
          ], stops: [
            0,
            stop,
            stop,
            1
          ]).createShader(rect);

          return gradient;
        },
        child: FittedBox(
          child: const Icon(
            Icons.donut_large_rounded,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
