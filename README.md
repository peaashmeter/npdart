# npdart

A minimal game engine for creating visual novels.
Please check the `example` folder before use.

```dart
void main(){
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const prefs = Preferences(savePath: '/example/');

    return MaterialApp(
      home: FutureBuilder(
        future: getDefaultInitialSaveData(prefs),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(color: Colors.black);

          return Novel(
              initialState: snapshot.data!,
              tree: Tree(scenes: {
                'root': Scene(script: (stage, state) async => state.loadScene('root'))
              }),
              preferences: prefs);
        },
      ),
    );
  }
}
```