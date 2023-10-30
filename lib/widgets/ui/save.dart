import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:npdart/core/novel.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/singletons/preferences.dart';
import 'package:npdart/widgets/ui/border.dart';

class SaveGameDialog extends StatelessWidget {
  final NovelState state;
  const SaveGameDialog({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: _generateSaveName());

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
                      'menu_save_description',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ).tr(),
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
                              await save(state.asSaveData(controller.text),
                                  Preferences().savePath);
                              nav.pop();
                            },
                            child: const Text('menu_save_button').tr())
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
