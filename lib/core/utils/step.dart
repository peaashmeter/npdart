import 'package:npdart/core/singletons/stage.dart';

///A convinient alias for [Stage().waitForInput()]
Future<bool> step() async => await Stage().waitForInput();
