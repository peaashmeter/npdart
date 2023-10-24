import 'dart:convert';
import 'dart:io';

import 'package:npdart/core/singletons/preferences.dart';
import 'package:path_provider/path_provider.dart';

///A singleton that operates the inner state of the game.
class NovelState {
  static NovelState? instance;

  String? sceneId;

  final Map<String, dynamic> _state = {};

  factory NovelState() {
    instance ??= NovelState._();
    return instance!;
  }
  NovelState._();

  Object? getData(String key) => _state[key];

  Future<void> init() async {
    try {
      await load();
    } catch (e) {
      sceneId = 'root';
      _state.clear();
    }
  }

  Future<void> load() async {
    final savePath = (await getApplicationDocumentsDirectory()).path +
        Preferences().savePath;
    final saveFile = File(savePath);
    if (!await saveFile.exists()) throw SaveFileNotFoundException();
    try {
      final data = jsonDecode(await saveFile.readAsString());
      final String sceneId = data['scene_id'];
      final Map<String, dynamic> gameState = data['state'];

      this.sceneId = sceneId;
      _state.clear();
      _state.addAll(gameState);
    } catch (e) {
      throw SaveFileCorruptedException();
    }
  }

  void removeData(String key) => _state.remove(key);

  Future<void> save() async {
    final savePath = (await getApplicationDocumentsDirectory()).path +
        Preferences().savePath;
    final saveFile = await File(savePath).create(recursive: true);

    final data = {'scene_id': sceneId, 'state': _state};
    await saveFile.writeAsString(jsonEncode(data));
  }

  ///Binds provided [value] with [key]. Value object must be json-encodable.
  void setData(String key, Object value) => _state[key] = value;
}

class SaveFileCorruptedException implements Exception {}

class SaveFileNotFoundException implements Exception {}
