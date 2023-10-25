import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
                      builder: (context) => const HistoryDialog());
                }),
            MenuOption(
                text: 'menu_save'.tr(),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => const SaveGameDialog());
                }),
            MenuOption(
                text: 'menu_load'.tr(),
                callback: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => const LoadDialog());
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
