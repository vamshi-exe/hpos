class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
