class Country {
  final String name;

  final String code;

  final String dialCode;

  const Country({this.name, this.code, this.dialCode});

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode $name";

  String toCountryStringOnly() => '$name';

  String get flagUri => 'flags/${code.toLowerCase()}.png';

  bool matches(String value) {
    return code.toUpperCase() == value.toUpperCase() ||
        dialCode == value.toString();
  }
}
