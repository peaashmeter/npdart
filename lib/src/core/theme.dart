import 'package:flutter/material.dart';

///A wrapper for the [TextTheme], covering all the apis, necessary to the novel.
class NovelTextTheme extends TextTheme {
  ///A constructor to create a [TextTheme] in a convenient way.
  ///
  ///[choiceStyle] is used to paint options when prompted.
  ///[headerStyle] is used to paint headers of the textbox.
  ///[stringStyle] is used to paint a content of the textbox.
  ///[inputStyle] is used when a user is allowed to type something.
  const NovelTextTheme(
      {TextStyle? choiceStyle,
      TextStyle? headerStyle,
      TextStyle? stringStyle,
      TextStyle? inputStyle})
      : super(
            headlineMedium: choiceStyle,
            titleMedium: inputStyle,
            headlineSmall: headerStyle,
            titleLarge: stringStyle);
}
