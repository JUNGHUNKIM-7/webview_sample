extension StringUtil on String {
  String get toFirstUpper => this[0].toUpperCase() + substring(1);

  String get toCapitalize => split(' ').map((e) => e.toFirstUpper).join(' ');
}
