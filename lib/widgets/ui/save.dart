import 'package:flutter/material.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/ui/border.dart';

class SaveGameDialog extends StatelessWidget {
  const SaveGameDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: _generateSaveName());
    final prefs = InheritedNovelState.of(context).snapshot.preferences;

    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(0),
      content: UiBorder(
        child: Material(
          color: Colors.black.withOpacity(0),
          child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 2 / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prefs.translate('menu_save_description'),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: controller,
                          maxLength: 50,
                        )),
                        TextButton(
                            onPressed: () async {
                              final nav = Navigator.of(context);
                              final snapshot =
                                  InheritedNovelState.of(context).snapshot;
                              await save(
                                  SaveData.fromStateSnapshot(
                                      snapshot, controller.text),
                                  snapshot.preferences.savePath);
                              nav.pop();
                            },
                            child: Text(prefs.translate('menu_save_button')))
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  String _generateSaveName() => 'save_${DateTime.now()}';
}
