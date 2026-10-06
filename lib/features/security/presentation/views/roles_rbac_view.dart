import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Metadata de presentación para humanizar los permisos canónicos de la base de datos
class _PermissionMeta {
  final String title;
  final String friendlyDescription;
  final IconData icon;

  const _PermissionMeta({
    required this.title,
    required this.friendlyDescription,
    required this.icon,
  });
}

class RolesRbacView extends StatefulWidget {
  const RolesRbacView({super.key});

  @override
  State<RolesRbacView> createState() => _RolesRbacViewState();
}

class _RolesRbacViewState extends State<RolesRbacView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<AppRole> _roles = [];
  List<AppPermission> _permissions = [];
  AppRole? _selectedRole;
  Set<int> _selectedRolePermissionIds = {};
  final Map<int, int> _rolePermissionCounts = {};
  bool _isSavingPermissions = false;

  String _searchQuery = '';
  String _selectedModuleFilter = 'todos';
  final _searchController = TextEditingController();

  static final Map<String, _PermissionMeta> _metaMap = {
    'users.view': const _PermissionMeta(
      title: 'Consultar Directorio de Usuarios',
      friendlyDescription:
          'Visualización de perfiles, roles asignados y estados de colaboradores.',
      icon: Icons.people_outline,
    ),
    'users.create': const _PermissionMeta(
      title: 'Registrar Nuevos Usuarios',
      friendlyDescription:
          'Aprovisionamiento de cuentas e inicio de credenciales corporativas.',
      icon: Icons.person_add_outlined,
    ),
    'users.update': const _PermissionMeta(
      title: 'Modificar Cuentas de Usuarios',
      friendlyDescription:
          'Edición de información de perfil, nombres y configuraciones de cuenta.',
      icon: Icons.manage_accounts_outlined,
    ),
    'users.disable': const _PermissionMeta(
      title: 'Suspender / Desactivar Cuentas',
      friendlyDescription:
          'Pausado preventivo de acceso al sistema sin borrado definitivo.',
      icon: Icons.pause_circle_outline,
    ),
    'users.delete': const _PermissionMeta(
      title: 'Dar de Baja Usuarios',
      friendlyDescription:
          'Revocación definitiva y eliminación permanente de identidades.',
      icon: Icons.person_remove_outlined,
    ),
    'roles.view': const _PermissionMeta(
      title: 'Visualizar Matriz de Roles',
      friendlyDescription:
          'Inspección de roles existentes, jerarquías y políticas de acceso.',
      icon: Icons.admin_panel_settings_outlined,
    ),
    'roles.manage': const _PermissionMeta(
      title: 'Gestionar Políticas de Roles',
      friendlyDescription:
          'Creación, parametrización y mutación de perfiles RBAC del sistema.',
      icon: Icons.shield_outlined,
    ),
    'permissions.view': const _PermissionMeta(
      title: 'Consultar Catálogo de Privilegios',
      friendlyDescription:
          'Auditoría y revisión de vectores de operaciones protegidas.',
      icon: Icons.key_outlined,
    ),
    'permissions.assign': const _PermissionMeta(
      title: 'Asignar Privilegios a Roles',
      friendlyDescription:
          'Vinculación y delegación granular de capacidades operativas.',
      icon: Icons.assignment_turned_in_outlined,
    ),
    'audit.view': const _PermissionMeta(
      title: 'Consultar Bitácora de Auditoría',
      friendlyDescription:
          'Acceso al registro inmutable de transacciones e IPs de origen.',
      icon: Icons.history_edu_outlined,
    ),
    'audit.export': const _PermissionMeta(
      title: 'Exportar Registros de Auditoría',
      friendlyDescription:
          'Generación y descarga forense de la bitácora en formatos estándar.',
      icon: Icons.download_outlined,
    ),
    'sessions.view': const _PermissionMeta(
      title: 'Monitoreo de Sesiones Activas',
      friendlyDescription:
          'Supervisión de dispositivos conectados, IPs y tokens en tiempo real.',
      icon: Icons.devices_outlined,
    ),
    'sessions.revoke': const _PermissionMeta(
      title: 'Revocación Forzosa de Sesiones',
      friendlyDescription:
          'Terminación inmediata de sesiones activas y expulsión de tokens.',
      icon: Icons.power_settings_new_outlined,
    ),
    'system.maintenance': const _PermissionMeta(
      title: 'Mantenimiento y Gobernanza',
      friendlyDescription:
          'Operaciones globales de integridad y parámetros de seguridad del núcleo.',
      icon: Icons.settings_suggest_outlined,
    ),
    'catalog.view': const _PermissionMeta(
      title: 'Consultar Catálogo y Tarifario',
      friendlyDescription:
          'Visualización de partidas de servicio, rubros, líneas y tarifas base.',
      icon: Icons.menu_book_outlined,
    ),
    'catalog.manage': const _PermissionMeta(
      title: 'Gestionar Catálogo y Tarifas Especiales',
      friendlyDescription:
          'Creación, edición, precios diferenciados (scopes) y baja de partidas o rubros.',
      icon: Icons.price_change_outlined,
    ),
  };

  _PermissionMeta _getMeta(AppPermission perm) {
    return _metaMap[perm.code] ??
        _PermissionMeta(
          title: perm.code,
          friendlyDescription: perm.description,
          icon: Icons.lock_outline,
        );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final roles = await _service.listRoles();
      final permissions = await _service.listPermissions();

      if (mounted) {
        setState(() {
          _roles = roles;
          _permissions = permissions;
          if (_roles.isNotEmpty) {
            _selectedRole = _roles.first;
          }
          _isLoading = false;
        });

        if (_selectedRole != null) {
          _selectRole(_selectedRole!);
        }

        for (final r in roles) {
          if (r.id != null) {
            _service.getRolePermissions(r.id!).then((ids) {
              if (mounted) {
                setState(() => _rolePermissionCounts[r.id!] = ids.length);
              }
            });
          }
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectRole(AppRole role) async {
    setState(() {
      _selectedRole = role;
      _selectedRolePermissionIds = {};
    });

    if (role.id != null) {
      try {
        final ids = await _service.getRolePermissions(role.id!);
        if (mounted && _selectedRole?.id == role.id) {
          setState(() {
            _selectedRolePermissionIds = ids.toSet();
            _rolePermissionCounts[role.id!] = ids.length;
          });
        }
      } catch (_) {}
    }
  }

  void _togglePermission(int permId) {
    if (_selectedRole == null) return;
    final isSuper =
        _selectedRole!.isSystemRole &&
        _selectedRole!.name.toLowerCase() == 'superadmin';
    if (isSuper) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El Super Administrador posee todos los permisos de forma inherente.',
          ),
          backgroundColor: Color(0xFF2563EB),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (_selectedRolePermissionIds.contains(permId)) {
        _selectedRolePermissionIds.remove(permId);
      } else {
        _selectedRolePermissionIds.add(permId);
      }
    });
  }

  Future<void> _saveRolePermissions() async {
    if (_selectedRole?.id == null) return;
    setState(() => _isSavingPermissions = true);
    try {
      final saved = await _service.syncRolePermissions(
        roleId: _selectedRole!.id!,
        permissionIds: _selectedRolePermissionIds.toList(),
      );
      if (mounted) {
        setState(() {
          _rolePermissionCounts[_selectedRole!.id!] = saved.length;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permisos actualizados para ${_selectedRole!.name}'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error guardando permisos: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingPermissions = false);
    }
  }

  void _showCreateRoleDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Nuevo Rol RBAC',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  labelText: 'Nombre del Rol (ej. Operaciones)',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  labelText: 'Descripción funcional',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              try {
                final created = await _service.createRole(
                  AppRole(
                    name: name,
                    description: descCtrl.text.trim(),
                    isSystemRole: false,
                    createdAt: DateTime.now().toUtc(),
                  ),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                await _loadData();
                _selectRole(created);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: const Text('Crear Rol'),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(AppRole role) {
    final isSystem =
        role.isSystemRole || role.name.toLowerCase() == 'superadmin';
    final nameCtrl = TextEditingController(text: role.name);
    final descCtrl = TextEditingController(text: role.description);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Editar Rol',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                enabled: !isSystem,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  labelText: isSystem
                      ? 'Nombre (Protegido por Sistema)'
                      : 'Nombre del Rol',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  labelText: 'Descripción funcional',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updated = await _service.updateRole(
                  role.copyWith(
                    name: isSystem ? role.name : nameCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                  ),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                await _loadData();
                _selectRole(updated);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteRole(AppRole role) {
    if (role.isSystemRole || role.name.toLowerCase() == 'superadmin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Los roles base del sistema son inmutables y no pueden ser eliminados.',
          ),
          backgroundColor: Color(0xFF7C3AED),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Eliminar Rol',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Desea eliminar el rol "${role.name}"? Los usuarios y privilegios vinculados serán desasociados.',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () async {
              try {
                await _service.deleteRole(role.id!);
                if (ctx.mounted) Navigator.pop(ctx);
                await _loadData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  List<AppPermission> get _filteredPermissions {
    return _permissions.where((perm) {
      final meta = _getMeta(perm);
      final query = _searchQuery.toLowerCase().trim();

      final matchesQuery =
          query.isEmpty ||
          perm.code.toLowerCase().contains(query) ||
          meta.title.toLowerCase().contains(query) ||
          meta.friendlyDescription.toLowerCase().contains(query) ||
          perm.module.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_selectedModuleFilter == 'todos') return true;
      if (_selectedModuleFilter == 'roles') {
        return perm.module == 'roles' || perm.module == 'permissions';
      }
      return perm.module.toLowerCase() == _selectedModuleFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando políticas RBAC...',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1050;
        final isNarrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 32,
            vertical: isNarrow ? 20 : 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Ejecutiva Minimalista
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 24),

              // 2. Paneles de Roles y Permisos (Asimétrico 36 / 64)
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 36,
                      child: _buildRolesPanel(isDark),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 64,
                      child: _buildPermissionsCatalog(isDark),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildRolesPanel(isDark),
                    const SizedBox(height: 24),
                    _buildPermissionsCatalog(isDark),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // --- CABECERA EJECUTIVA ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final infoCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: [
            Text(
              'Roles & Políticas RBAC',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 18 : 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                '${_roles.length} roles • ${_permissions.length} privilegios',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Gobernanza de identidades corporativas, matriz de privilegios y control de acceso granular.',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 12.5 : 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final refreshBtn = OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark
            ? const Color(0xFFCBD5E1)
            : const Color(0xFF475569),
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _loadData,
      icon: const Icon(Icons.refresh, size: 15),
      label: Text(
        'Actualizar',
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 24,
        vertical: isNarrow ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoCol,
                const SizedBox(height: 14),
                refreshBtn,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoCol),
                const SizedBox(width: 16),
                refreshBtn,
              ],
            ),
    );
  }

  // --- PANEL IZQUIERDO: DIRECTORIO DE ROLES ---
  Widget _buildRolesPanel(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Directorio de Roles',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_roles.length}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showCreateRoleDialog,
                icon: const Icon(Icons.add, size: 14),
                label: Text(
                  'Nuevo Rol',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 16),

          if (_roles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No hay roles configurados.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            )
          else
            ..._roles.map((role) {
              final isSelected = _selectedRole?.id == role.id;
              return _buildRoleCard(role, isSelected, isDark);
            }),

          const SizedBox(height: 12),
          // Nota de integridad RBAC
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Los roles de tipo Sistema disponen de protección contra eliminación para garantizar la gobernanza del entorno.',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(AppRole role, bool isSelected, bool isDark) {
    final borderColor = isSelected
        ? const Color(0xFF2563EB)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
    final bgColor = isSelected
        ? (isDark
              ? const Color(0xFF1E293B).withValues(alpha: 0.4)
              : const Color(0xFFEFF6FF))
        : (isDark
              ? const Color(0xFF0B1120).withValues(alpha: 0.6)
              : const Color(0xFFF8FAFC));

    final isSuper =
        role.isSystemRole && role.name.toLowerCase() == 'superadmin';
    final count = isSuper
        ? _permissions.length
        : (_rolePermissionCounts[role.id] ?? 0);
    final total = _permissions.length;
    final progress = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectRole(role),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: isSuper
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              role.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (role.isSystemRole) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'SISTEMA',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF475569),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 15),
                          tooltip: 'Editar rol',
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          onPressed: () => _showEditRoleDialog(role),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (!role.isSystemRole &&
                            role.name.toLowerCase() != 'superadmin')
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 15),
                            tooltip: 'Eliminar rol',
                            color: const Color(0xFFEF4444),
                            onPressed: () => _confirmDeleteRole(role),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 26,
                              minHeight: 26,
                            ),
                          )
                        else
                          Tooltip(
                            message:
                                'Rol del sistema protegido contra eliminación',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                size: 14,
                                color: isDark
                                    ? const Color(0xFF475569)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  role.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                // Cobertura de permisos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cobertura de privilegios',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      '$count / $total',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: count > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSuper
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- PANEL DERECHO: CATÁLOGO DE PERMISOS ---
  Widget _buildPermissionsCatalog(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final filtered = _filteredPermissions;
    final isSuper =
        _selectedRole != null &&
        _selectedRole!.isSystemRole &&
        _selectedRole!.name.toLowerCase() == 'superadmin';

    final activeCount = isSuper
        ? _permissions.length
        : _selectedRolePermissionIds.length;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del catálogo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedRole != null
                          ? 'Privilegios Asignados • ${_selectedRole!.name}'
                          : 'Catálogo de Privilegios',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSuper
                          ? 'El Super Administrador posee todos los privilegios del sistema de forma inherente.'
                          : 'Selecciona o desmarca los privilegios operativos para este rol.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (_selectedRole != null && !isSuper)
                ElevatedButton.icon(
                  onPressed: _isSavingPermissions ? null : _saveRolePermissions,
                  icon: _isSavingPermissions
                      ? const SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check, size: 14),
                  label: Text(
                    _isSavingPermissions ? 'Guardando...' : 'Guardar Permisos',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$activeCount de ${_permissions.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Buscador rápido
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText:
                    'Buscar permiso por código o nombre (ej: catalog.manage, users.create)...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 17,
                  color: Color(0xFF64748B),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 15),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filtros de módulo tipo segmented tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('todos', 'Todos', _permissions.length, isDark),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'users',
                  'Usuarios',
                  _permissions.where((p) => p.module == 'users').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'roles',
                  'Roles & RBAC',
                  _permissions
                      .where(
                        (p) => p.module == 'roles' || p.module == 'permissions',
                      )
                      .length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'catalog',
                  'Catálogo & Tarifas',
                  _permissions.where((p) => p.module == 'catalog').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'audit',
                  'Auditoría',
                  _permissions.where((p) => p.module == 'audit').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'sessions',
                  'Sesiones',
                  _permissions.where((p) => p.module == 'sessions').length,
                  isDark,
                ),

                const SizedBox(width: 6),
                _buildFilterPill(
                  'system',
                  'Sistema',
                  _permissions.where((p) => p.module == 'system').length,
                  isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 14),

          // Lista de tarjetas de permisos
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off_outlined,
                      size: 32,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No se encontraron permisos para "$_searchQuery"',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _selectedModuleFilter = 'todos';
                        });
                      },
                      child: Text(
                        'Restablecer filtros',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final perm = filtered[index];
                return _buildPermissionCard(perm, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    String filterKey,
    String label,
    int count,
    bool isDark,
  ) {
    final isSelected = _selectedModuleFilter == filterKey;
    final activeBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final inactiveBg = isDark
        ? const Color(0xFF0B1120)
        : const Color(0xFFF8FAFC);
    final borderColor = isSelected
        ? (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1))
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedModuleFilter = filterKey),
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? (isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155))
                      : (isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(AppPermission perm, bool isDark) {
    final meta = _getMeta(perm);
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final isSuper =
        _selectedRole != null &&
        _selectedRole!.isSystemRole &&
        _selectedRole!.name.toLowerCase() == 'superadmin';
    final isGranted =
        isSuper ||
        (perm.id != null && _selectedRolePermissionIds.contains(perm.id));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSuper || perm.id == null
            ? null
            : () => _togglePermission(perm.id!),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isGranted
                ? (isDark
                      ? const Color(0xFF10B981).withValues(alpha: 0.05)
                      : const Color(0xFFECFDF5))
                : (isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isGranted
                  ? const Color(0xFF10B981).withValues(alpha: 0.4)
                  : borderColor,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isGranted
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : (isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  meta.icon,
                  size: 16,
                  color: isGranted
                      ? const Color(0xFF10B981)
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569)),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meta.title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            perm.code,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      meta.friendlyDescription,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              if (isSuper)
                Tooltip(
                  message:
                      'El Super Administrador posee este permiso de forma permanente.',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 11,
                          color: Color(0xFF7C3AED),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Heredado',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: isGranted,
                    activeThumbColor: const Color(0xFF10B981),
                    activeTrackColor: const Color(
                      0xFF10B981,
                    ).withValues(alpha: 0.3),
                    onChanged: (val) {
                      if (perm.id != null) {
                        _togglePermission(perm.id!);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
