/// Validador ergonómico de permisos para la interfaz de usuario (Flutter).
///
/// IMPORTANTE:
/// Ocultar o deshabilitar un widget en la UI NO equivale a proteger una operación.
/// Toda acción sensible SIEMPRE se valida estrictamente en el backend (Serverpod).
class PermissionChecker {
  final Set<String> _userPermissions;

  PermissionChecker({Set<String> userPermissions = const {}})
    : _userPermissions = userPermissions;

  /// Retorna si el usuario cuenta con el permiso para visualización de elementos.
  bool has(String permission) => _userPermissions.contains(permission);

  /// Retorna si el usuario cuenta con al menos uno de los permisos indicados.
  bool hasAny(Iterable<String> permissions) =>
      permissions.any(_userPermissions.contains);

  /// Retorna si el usuario cuenta con todos los permisos requeridos.
  bool hasAll(Iterable<String> permissions) =>
      permissions.every(_userPermissions.contains);
}
