import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npdart/core/character.dart';
import 'package:npdart/core/choice.dart';
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
          'root': Scene(
            description: 'Тестовая сцена',
            script: () async {
              final background = Image.asset(
                'assets/backgrounds/scenery1.jpg',
                fit: BoxFit.cover,
              );

              final oleg = Lena();
              final sanya = Lena();

              await Stage().waitForInput();
              Stage().setBackground(background);

              sanya.enterScene();
              sanya.moveTo(const Offset(0.3, 0.5));

              oleg.enterScene();
              oleg.moveTo(const Offset(0, 0.5));
              oleg.setScale(1.2);

              await Stage().waitForInput();
              oleg.say('Hello, world!');
              oleg.setScale(0.7);
              await Stage().waitForInput();

              Stage().showChoices({
                Choice(
                    label: 'Выбор 1',
                    callback: () => oleg.say('Ты выбрал вариант 1')),
                Choice(
                    label: 'Выбор 2',
                    callback: () => sanya.say('Ты выбрал вариант 2')),
              });

              await Stage().waitForInput();
              oleg.leaveScene();
              await Stage().waitForInput();
              sanya.leaveScene();
              await Stage().waitForInput();
              Stage().loadScene('root');
            },
          )
        },
      ),
    );
  }
}
