///Информация, выводимая в текстовом блоке сцены
class Verse {
  final String? _header;
  final String? _text;

  Verse(this._header, this._text);

  ///Заголовок (имя персонажа и т.п) в текстовом поле
  String? get header => _header;
  String? get text => _text;
}
