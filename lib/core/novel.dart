import 'package:flutter/material.dart';
import 'package:npdart/core/preferences.dart';
import 'package:npdart/widgets/stage.dart';

class Novel extends StatefulWidget {
  const Novel({super.key});

  @override
  State<Novel> createState() => _NovelState();
}

class _NovelState extends State<Novel> {
  @override
  Widget build(BuildContext context) {
    return const Preferences(child: Stage());
  }
}
