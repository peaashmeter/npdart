import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/novel.dart';
import 'package:npdart/core/scene.dart';
import 'package:npdart/core/singletons/stage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Novel(
        tree: {
          'scene1': Scene(
            description: 'Тестовая сцена',
            script: () async {
              final square = Character();
              final background = Image.asset(
                'assets/backgrounds/scenery1.jpg',
                fit: BoxFit.cover,
              );

              await Stage().waitForInput();
              Stage().setBackground(background);
              square.enterScene();
              await Stage().waitForInput();
              square.leaveScene();

              Stage().loadScene('scene1');
            },
          )
        },
      ),
    );
  }
}
