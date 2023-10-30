import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:npdart/core/novel.dart';
import 'package:npdart/core/stage.dart';
import 'package:npdart/widgets/ui/border.dart';
import 'package:npdart/widgets/ui/history.dart';
import 'package:npdart/widgets/ui/load.dart';
import 'package:npdart/widgets/ui/option.dart';
import 'package:npdart/widgets/ui/save.dart';

class MenuDialog extends StatelessWidget {
  final NovelState state;
  final Stage stage;
  const MenuDialog({
    super.key,
    required this.state,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(0),
      content: UiBorder(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuOption(
                text: 'menu_history'.tr(),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) => HistoryDialog(
                            state: state,
                          ));
                }),
            MenuOption(
                text: 'menu_save'.tr(),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) => SaveGameDialog(state: state),
                      useRootNavigator: false);
                }),
            MenuOption(
                text: 'menu_load'.tr(),
                callback: () {
                  Navigator.of(context).pop();

                  showDialog(
                      context: context,
                      builder: (_) => LoadDialog(
                            stage: stage,
                            state: state,
                          ));
                }),
            MenuOption(
                text: 'menu_menu'.tr(),
                callback: () {
                  exit(0);
                }),
          ],
        ),
      ),
    );
  }
}
