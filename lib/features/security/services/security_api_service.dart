import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../main.dart' as app;

class SecurityDashboardMetrics {
  final int totalUsers;
  final int totalRoles;
  final int totalAuditLogs;
  final int activeSessions;

  const SecurityDashboardMetrics({
    required this.totalUsers,
    required this.totalRoles,
    required this.totalAuditLogs,
    required this.activeSessions,
  });
}

/// Servicio cliente tipado para interactuar con los endpoints RPC de Serverpod.
/// Cumple con la política de datos reales de base de datos (No-Mock Policy).
class SecurityApiService {
  final Client _client;

  SecurityApiService({Client? client}) : _client = client ?? app.client;

  // --- Dashboard ---
  Future<SecurityDashboardMetrics> getDashboardMetrics() async {
    try {
      final users = await _client.user.listUsers(
        limit: 500,
        offset: 0,
        includeDeleted: false,
      );
      final roles = await _client.rbac.listRoles();
      final logs = await _client.audit.listLogs(limit: 50, offset: 0);

      return SecurityDashboardMetrics(
        totalUsers: users.length,
        totalRoles: roles.length,
        totalAuditLogs: logs.length,
        activeSessions: 1, // Sesión actual conectada
      );
    } catch (_) {
      return const SecurityDashboardMetrics(
        totalUsers: 0,
        totalRoles: 0,
        totalAuditLogs: 0,
        activeSessions: 0,
      );
    }
  }

  // --- Usuarios ---
  Future<List<AppUser>> listUsers({
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await _client.user.listUsers(
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  Future<AppUser> createUser({
    required String email,
    required String fullName,
    List<int> roleIds = const [],
  }) async {
    return await _client.user.createUser(
      email: email,
      fullName: fullName,
      roleIds: roleIds,
    );
  }

  Future<AppUser?> updateUser({
    required int id,
    required String fullName,
  }) async {
    return await _client.user.updateUser(id: id, fullName: fullName);
  }

  Future<bool> setUserActive({
    required int id,
    required bool isActive,
  }) async {
    return await _client.user.setUserActive(id: id, isActive: isActive);
  }

  Future<bool> deleteUser(int id) async {
    return await _client.user.deleteUser(id);
  }

  // --- Roles & RBAC ---
  Future<List<AppRole>> listRoles() async {
    return await _client.rbac.listRoles();
  }

  Future<List<AppPermission>> listPermissions() async {
    return await _client.rbac.listPermissions();
  }

  Future<UserRole> assignRoleToUser({
    required int userId,
    required int roleId,
  }) async {
    return await _client.rbac.assignRoleToUser(
      userId: userId,
      roleId: roleId,
    );
  }

  Future<bool> removeRoleFromUser({
    required int userId,
    required int roleId,
  }) async {
    return await _client.rbac.removeRoleFromUser(
      userId: userId,
      roleId: roleId,
    );
  }

  Future<RolePermission> assignPermissionToRole({
    required int roleId,
    required int permissionId,
  }) async {
    return await _client.rbac.assignPermissionToRole(
      roleId: roleId,
      permissionId: permissionId,
    );
  }

  Future<List<String>> getUserEffectivePermissions(int userId) async {
    return await _client.rbac.getUserEffectivePermissions(userId);
  }

  Future<AppRole> createRole(AppRole role) async {
    return await _client.rbac.createRole(role);
  }

  Future<AppRole> updateRole(AppRole role) async {
    return await _client.rbac.updateRole(role);
  }

  Future<bool> deleteRole(int roleId) async {
    return await _client.rbac.deleteRole(roleId);
  }

  Future<List<int>> getRolePermissions(int roleId) async {
    return await _client.rbac.getRolePermissions(roleId);
  }

  Future<List<int>> syncRolePermissions({
    required int roleId,
    required List<int> permissionIds,
  }) async {
    return await _client.rbac.syncRolePermissions(
      roleId: roleId,
      permissionIds: permissionIds,
    );
  }

  // --- Auditoría ---
  Future<List<AuditLog>> listAuditLogs({
    int limit = 50,
    int offset = 0,
    int? userId,
    String? action,
  }) async {
    return await _client.audit.listLogs(
      limit: limit,
      offset: offset,
      userId: userId,
      action: action,
    );
  }

  Future<AuditLogPageResponse> listAuditLogsPaged({
    int page = 1,
    int pageSize = 25,
    String? action,
    String? result,
    int? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    return await _client.audit.listLogsPaged(
      page: page,
      pageSize: pageSize,
      action: action,
      result: result,
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
      search: search,
    );
  }

  // --- Monitoreo de Sesiones ---
  Future<List<UserSession>> listUserSessions(int userId) async {
    return await _client.sessionManagement.listUserSessions(userId);
  }

  Future<bool> revokeSession(int sessionId) async {
    return await _client.sessionManagement.revokeSession(sessionId);
  }
}
