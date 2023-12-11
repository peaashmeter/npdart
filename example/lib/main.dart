import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:oneday/scenes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(EasyLocalization(
    supportedLocales: const [Locale('ru')],
    fallbackLocale: const Locale('ru'),
    path: 'assets/translations',
    child: const OneDay(),
  ));
}

class OneDay extends StatelessWidget {
  const OneDay({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final prefs = Preferences(
        translate: (s) => s.tr(), savePath: '/oneday/', typingDelay: 35);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: theme,
      title: 'One Day',
      home: FutureBuilder(
        future: getSaveData(prefs),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(color: Colors.black);

          return Novel(
              initialState: snapshot.data!,
              tree: Tree(scenes: scenes),
              preferences: prefs);
        },
      ),
    );
  }
}

Future<SaveData> getSaveData(Preferences preferences) async {
  var saveData = await getDefaultInitialSaveData(preferences);

  if (saveData.sceneId == 'menu') {
    saveData = SaveData.fallback();
  } else if (saveData.sceneId != 'root') {
    saveData = SaveData(
        sceneId: 'menu',
        description: '',
        createdAt: DateTime.now(),
        state: saveData.state);
  }
  return saveData;
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow, brightness: Brightness.dark),
  fontFamily: 'Marmelad',
  textTheme: TextTheme(
    //Style for choices
    headlineMedium:
        TextStyle(color: Colors.yellow.shade100, fontSize: 24, shadows: const [
      Shadow(
        blurRadius: 2,
        offset: Offset(2, 2),
      ),
    ]),
    //style for text input
    titleMedium: const TextStyle(color: Colors.white, fontSize: 16, shadows: [
      Shadow(
        blurRadius: 2,
        offset: Offset(2, 2),
      ),
    ]),
    //style for headers
    headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: Platform.isAndroid || Platform.isIOS ? 16 : 20,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ]),
    //style for dialog strings
    titleLarge: TextStyle(
        color: Colors.yellow.shade100,
        fontSize: Platform.isAndroid || Platform.isIOS ? 16 : null,
        shadows: const [
          Shadow(
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ]),
  ),
);
