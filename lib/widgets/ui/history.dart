import 'package:flutter/material.dart';
import 'package:npdart/core/novel.dart';
import 'package:npdart/widgets/ui/border.dart';

class HistoryDialog extends StatelessWidget {
  final NovelState state;
  const HistoryDialog({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0),
        content: UiBorder(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 2 / 3,
            child: ListView(
              children: state.history
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
