import 'package:flutter/material.dart';
import 'package:npdart/src/core/stage.dart';
import 'package:npdart/src/core/state.dart';
import 'package:npdart/src/widgets/ui/border.dart';

class HistoryDialog extends StatelessWidget {
  const HistoryDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final history = InheritedNovelState.of(context).snapshot.verseHistory +
        InheritedStage.of(context).notifier!.verseHistory;

    return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0),
        content: UiBorder(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 2 / 3,
            child: ListView(
              children: history
                  .map((verse) => ListTile(
                        title: Text(
                          verse.header,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .apply(color: verse.color),
                        ),
                        isThreeLine: true,
                        subtitle: Text(
                          verse.string,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}
