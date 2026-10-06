/// Excepción lanzada ante fallos en los flujos de autenticación y verificación de seguridad.
class AuthException implements Exception {
  final String message;
  final String? code;
  final Object? details;

  AuthException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}
