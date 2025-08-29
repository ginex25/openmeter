class NoPermissionException implements Exception {
  final String message;

  NoPermissionException([this.message = "No permission for notification."]);

  @override
  String toString() => message;
}
