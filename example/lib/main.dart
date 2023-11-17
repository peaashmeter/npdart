import 'package:easy_localization/easy_localization.dart';
import 'package:example/scenes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  final saveData = await getDefaultInitialSaveData();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ru')],
    path: 'assets/translations',
    child: MyApp(
      saveData: saveData,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final SaveData saveData;
  const MyApp({super.key, required this.saveData});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: theme,
      title: 'novel demo',
      home: Novel(
        initialState: saveData,
        tree: Tree(scenes: scenes),
        preferences: Preferences(translate: (s) => s.tr()),
      ),
    );
  }
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
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
    headlineSmall: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ]),
    //style for dialog strings
    titleLarge: TextStyle(color: Colors.yellow.shade100, shadows: const [
      Shadow(
        blurRadius: 2,
        offset: Offset(2, 2),
      ),
    ]),
  ),
);
