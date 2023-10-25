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

  Future<void> autosave() async {
    final savePath = await _getAutoSavePath();
    final saveFile = await File(savePath).create(recursive: true);

    final data = {
      'scene_id': sceneId,
      'description': 'autosave_${DateTime.now()}',
      'state': _state
    };
    await saveFile.writeAsString(jsonEncode(data));
  }

  Object? getData(String key) => _state[key];

  Future<void> init() async {
    try {
      final saves = await listSaves();
      await load(saves.first);
    } catch (e) {
      sceneId = 'root';
      _state.clear();
    }
  }

  Future<List<SaveData>> listSaves() async {
    final savesDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}${Preferences().savePath}');
    if (!await savesDir.exists()) return [];
    final saves = <SaveData>[];
    await for (final save in savesDir.list()) {
      if (save is File) {
        try {
          final data = jsonDecode(await save.readAsString());

          final String sceneId = data['scene_id'];
          final String description = data['description'];
          final Map<String, dynamic> state = data['state'];
          final DateTime createdAt = (await save.stat()).changed;

          saves.add(SaveData(
              sceneId: sceneId,
              description: description,
              createdAt: createdAt,
              state: state));
        } catch (e) {
          continue;
        }
      }
    }
    return saves..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> load(SaveData data) async {
    _state.clear();
    _state.addAll(data.state);
    sceneId = data.sceneId;
  }

  void removeData(String key) => _state.remove(key);

  Future<void> save(String description) async {
    final savePath =
        '${(await getApplicationDocumentsDirectory()).path}${Preferences().savePath}save_${DateTime.now().millisecondsSinceEpoch}.json';
    final saveFile = await File(savePath).create(recursive: true);

    final data = {
      'scene_id': sceneId,
      'description': description,
      'state': _state
    };

    await saveFile.writeAsString(jsonEncode(data));
  }

  ///Binds provided [value] with [key]. Value object must be json-encodable.
  void setData(String key, Object value) => _state[key] = value;

  Future<String> _getAutoSavePath() async =>
      '${(await getApplicationDocumentsDirectory()).path}${Preferences().savePath}autosave.json';
}

class SaveData {
  String sceneId;
  String description;
  DateTime createdAt;
  Map<String, dynamic> state;

  SaveData(
      {required this.sceneId,
      required this.description,
      required this.createdAt,
      required this.state});
}

class SaveFileCorruptedException implements Exception {}

class SaveFileNotFoundException implements Exception {}
