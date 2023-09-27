import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:npdart/core/stage.dart';

// ///Utilities for IO operations
// class SaveLoader {
//   Future<void> writeSaveFile(String data) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = Scene().preferences.savePath;
//     final file = await File('${directory.path}/$path').create(recursive: true);
//     await file.writeAsString(data);
//   }

//   Future<String?> loadSaveFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = Scene().preferences.savePath;
//     final file = File('${directory.path}/$path');
//     if (await file.exists()) {
//       return await file.readAsString();
//     }
//     return null;
//   }
// }
