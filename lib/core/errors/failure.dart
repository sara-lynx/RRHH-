/// Representación unificada de fallos en el frontend.
class Failure {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(this.message, {this.code, this.details});

  @override
  String toString() => 'Failure: $message (code: $code)';
}
