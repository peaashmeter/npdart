import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:npdart/core/save.dart';
import 'package:npdart/core/singletons/preferences.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/ui/border.dart';

class LoadDialog extends StatefulWidget {
  const LoadDialog({
    super.key,
  });

  @override
  State<LoadDialog> createState() => _LoadDialogState();
}

class _LoadDialogState extends State<LoadDialog> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0),
        content: UiBorder(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 2 / 3,
            child: FutureBuilder(
                future: listSaves(Preferences().savePath),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.expand(
                        child: Center(child: CircularProgressIndicator()));
                  }

                  return ListView(
                      children: snapshot.data!
                          .map((save) => ListTile(
                                title: Text(
                                  save.description,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(
                                  DateFormat("dd.MM.yyyy HH:mm:ss")
                                      .format(save.createdAt),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                trailing: TextButton(
                                    onPressed: () async {
                                      final nav = Navigator.of(context);
                                      //no dependency
                                      final state = context
                                          .getInheritedWidgetOfExactType<
                                              InheritedNovelState>()!
                                          .snapshot
                                          .loadScene(save.sceneId);
                                      NovelStateEvent(snapshot: state)
                                          .dispatch(context);

                                      nav.pop();
                                    },
                                    child: const Text('load_save_button').tr()),
                              ))
                          .toList());
                }),
          ),
        ));
  }
}
