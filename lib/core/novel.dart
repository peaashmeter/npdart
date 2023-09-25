import 'package:flutter/material.dart';
import 'package:visual_novel/core/preferences.dart';
import 'package:visual_novel/widgets/scenery.dart';

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
