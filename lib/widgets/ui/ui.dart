import 'package:flutter/material.dart';
import 'package:npdart/widgets/ui/border.dart';
import 'package:npdart/widgets/ui/menu.dart';

class UiLayer extends StatelessWidget {
  const UiLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withOpacity(0),
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (context) => const MenuDialog());
                },
                child: UiBorder(
                  child: Icon(
                    Icons.menu_rounded,
                    color: Colors.white30.withOpacity(0.3),
                  ),
                )),
          )),
    );
  }
}
