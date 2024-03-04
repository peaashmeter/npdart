import 'dart:convert';
import 'dart:io';

import 'package:npdart/src/core/preferences.dart';
import 'package:npdart/src/core/state.dart';
import 'package:path_provider/path_provider.dart';

///A snapshot of a state of the game, which can be used to load the state anew.
class SaveData {
  final String sceneId;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic> state;
  SaveData(
      {required this.sceneId,
      required this.description,
      required this.createdAt,
      required this.state});

  SaveData.fallback()
      : this(
            sceneId: 'root',
            description: '_',
            createdAt: DateTime.now(),
            state: {});

  SaveData.fromStateSnapshot(NovelStateSnapshot snapshot, String description)
      : this(
            createdAt: DateTime.now(),
            description: description,
            sceneId: snapshot.sceneId,
            state: snapshot.variables);
}

///Creates a save and writes it to the unique file.
Future<void> autosave(SaveData saveData, String savePath) async {
  final savePath_ = await _getAutoSavePath(savePath);
  final saveFile = await File(savePath_).create(recursive: true);

  final data = {
    'scene_id': saveData.sceneId,
    'description': 'autosave_${DateTime.now()}',
    'state': saveData.state
  };
  await saveFile.writeAsString(jsonEncode(data));
}

Future<String> _getAutoSavePath(String savePath) async =>
    '${(await getApplicationDocumentsDirectory()).path}${savePath}autosave.json';

Future<void> save(SaveData saveData, String savePath) async {
  final savePath_ =
      '${(await getApplicationDocumentsDirectory()).path}${savePath}save_${DateTime.now().millisecondsSinceEpoch}.json';
  final saveFile = await File(savePath_).create(recursive: true);

  final data = {
    'scene_id': saveData.sceneId,
    'description': saveData.description,
    'state': saveData.state
  };

  await saveFile.writeAsString(jsonEncode(data));
}

Future<List<SaveData>> listSaves(String savePath) async {
  final savesDir =
      Directory('${(await getApplicationDocumentsDirectory()).path}$savePath');
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

///Returns the most recent save is case if one exists. Otherwise returns a clear state defined by [SaveData.fallback];
Future<SaveData> getDefaultInitialSaveData(Preferences preferences) async {
  final saves = await listSaves(preferences.savePath);
  if (saves.isNotEmpty) {
    return saves.first;
  } else {
    return SaveData.fallback();
  }
}

Future<String> _getVisitedScenesPath(String savePath) async =>
    '${(await getApplicationDocumentsDirectory()).path}${savePath}visited.json';

Future<void> markSceneAsVisited(String sceneId, String savePath) async {
  final path = await _getVisitedScenesPath(savePath);
  final file = await File(path).create(recursive: true);

  final contents = await file.readAsString();

  late final Set<String> visitedScenes;
  if (contents.isNotEmpty) {
    visitedScenes = Set<String>.from(jsonDecode(contents));
  } else {
    visitedScenes = {};
  }

  visitedScenes.add(sceneId);
  final json = jsonEncode(visitedScenes.toList());
  await file.writeAsString(json);
}

Future<Set<String>> getVisitedScenes(String savePath) async {
  final path = await _getVisitedScenesPath(savePath);
  final file = await File(path).create(recursive: true);

  final contents = await file.readAsString();
  if (contents.isNotEmpty) {
    return Set<String>.from(jsonDecode(contents));
  }
  return {};
}
