import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/novel.dart';

import 'package:npdart/core/singletons/state.dart';
import 'package:npdart/core/singletons/tree.dart';
import 'package:npdart/scenes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  await NovelState().init();
  Tree().populate(scenes);

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      fallbackLocale: const Locale('en'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Marmelad',
        textTheme: TextTheme(
          //Style for choices
          headlineMedium: TextStyle(
              color: Colors.yellow.shade100,
              fontSize: 24,
              shadows: const [
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
      ),
      home: const Novel(),
    );
  }
}
