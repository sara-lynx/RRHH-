import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

/// Excepción especializada para errores de comunicación y negocio con el backend de RRHH.
class RrhhRemoteException implements Exception {
  final String code; // 'NOT_FOUND' | 'VALIDATION_FAILED' | 'SERVER_ERROR' | ...
  final String message; // Mensaje legible para la UI
  final Object? originalError;

  const RrhhRemoteException({
    required this.code,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'RrhhRemoteException($code): $message';

  /// Crea una instancia a partir de un error de Serverpod o de red.
  factory RrhhRemoteException.fromServerpod(Object error) {
    if (error is RrhhRemoteException) {
      return error;
    }

    if (error is ServerpodClientException) {
      return RrhhRemoteException(
        code: 'SERVER_ERROR_${error.statusCode}',
        message: error.message,
        originalError: error,
      );
    }

    final str = error.toString();
    if (str.contains('Exception:')) {
      return RrhhRemoteException(
        code: 'SERVER_EXCEPTION',
        message: str.replaceFirst(RegExp(r'^.*Exception:\s*'), '').trim(),
        originalError: error,
      );
    }

    return RrhhRemoteException(
      code: 'UNKNOWN',
      message: str,
      originalError: error,
    );
  }
}
