import 'dart:async';

import 'package:visual_novel/script/actions.dart';

import '../core/scene.dart';

///Таблица функций, которые вызываются при совершении действия с некоторым айди
Map<String, FutureOr<void> Function(Scene)> binding = {
  'change_scene': changeScene
};
