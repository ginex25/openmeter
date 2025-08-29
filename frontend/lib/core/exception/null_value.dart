class NullValueException implements Exception {
  final String message;

  NullValueException([this.message = "A value must not be zero."]);

  @override
  String toString() => message;
}
