class Route {
  final int _variableToCheck;
  final int _valueToCheck;

  final int _variableToIncrement;

  ///Сравниваем значение переменной с каким-то айди с эталоном
  final bool Function()? checkCondition;

  ///Изменяем значение переменной с каким-то айди
  final void Function()? changeVariable;

  ///Айди сцены, на которую перейдем при выполнении условия
  String nextScene;
}
