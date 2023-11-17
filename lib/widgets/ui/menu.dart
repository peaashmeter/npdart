import 'dart:io';

import 'package:flutter/material.dart';
import 'package:npdart/core/state.dart';
import 'package:npdart/widgets/ui/border.dart';
import 'package:npdart/widgets/ui/history.dart';
import 'package:npdart/widgets/ui/load.dart';
import 'package:npdart/widgets/ui/option.dart';
import 'package:npdart/widgets/ui/save.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = InheritedNovelState.of(context).snapshot.preferences;
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(0),
      content: UiBorder(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuOption(
                text: prefs.translate('menu_history'),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (_) => const HistoryDialog());
                }),
            MenuOption(
                text: prefs.translate('menu_save'),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) => const SaveGameDialog(),
                      useRootNavigator: false);
                }),
            MenuOption(
                text: prefs.translate('menu_load'),
                callback: () {
                  Navigator.of(context).pop();

                  showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (_) => const LoadDialog());
                }),
            MenuOption(
                text: prefs.translate('menu_menu'),
                callback: () {
                  exit(0);
                }),
          ],
        ),
      ),
    );
  }
}
