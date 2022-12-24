///Информация, выводимая в текстовом блоке сцены
class Verse {
  final String? _headerId;
  final String? _stringId;

  Verse({String? headerId, String? stringId})
      : _headerId = headerId,
        _stringId = stringId;

  ///Идентификатор заголовока (имя персонажа и т.п) в текстовом поле
  String? get headerId => _headerId;

  ///Идентификатор текстовой строки
  String? get stringId => _stringId;
}
