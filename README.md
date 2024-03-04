# npdart

A minimal game engine for creating visual novels.
Please check the `example` folder before use.

# Features:
* Global and local game state management
* Scene tree
* Basic persistence (including autosaves)
* Rendering backgrounds and foreground sprites
* Sounds
* Textbox with RichText support

# Example:

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