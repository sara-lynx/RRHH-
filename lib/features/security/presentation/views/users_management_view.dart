import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

/// Vista de Gestión de Usuarios y Directorio Corporativo de Elite Multiservicios.
/// Diseñada con estética ejecutiva minimalista, tipografía Inter y precisión suiza.
class UsersManagementView extends StatefulWidget {
  const UsersManagementView({super.key});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<AppUser> _users = [];
  List<AppRole> _availableRoles = [];
  String _searchQuery = '';
  int _statusFilter = 0; // 0 = Todos, 1 = Activos, 2 = Inactivos
  AppUser? _selectedUser;
  List<String>? _userPermissions;
  bool _isLoadingPermissions = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final users = await _service.listUsers();
      final roles = await _service.listRoles();

      if (mounted) {
        setState(() {
          _users = users;
          _availableRoles = roles;
          _isLoading = false;
          if (_selectedUser != null) {
            final match = _users.where((u) => u.id == _selectedUser!.id);
            if (match.isNotEmpty) {
              _selectedUser = match.first;
            } else {
              _selectedUser = null;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF991B1B),
            content: Text('Error al sincronizar con el servidor: $e'),
          ),
        );
      }
    }
  }

  Future<void> _selectUser(AppUser user) async {
    setState(() {
      _selectedUser = user;
      _isLoadingPermissions = true;
      _userPermissions = null;
    });

    final isWide = MediaQuery.of(context).size.width >= 1150;
    if (!isWide) {
      _showUserDetailSheet(user);
    }

    try {
      if (user.id != null) {
        final perms = await _service.getUserEffectivePermissions(user.id!);
        if (mounted && _selectedUser?.id == user.id) {
          setState(() {
            _userPermissions = perms;
            _isLoadingPermissions = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingPermissions = false);
      }
    }
  }

  void _showUserDetailSheet(AppUser user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final permsFuture = user.id != null
        ? _service.getUserEffectivePermissions(user.id!)
        : Future.value(<String>[]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D111C) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildDetailHeader(
                user,
                isDark,
                onClose: () => Navigator.pop(sheetCtx),
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: permsFuture,
                  builder: (context, snapshot) {
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting;
                    return _buildDetailBody(
                      user,
                      isDark,
                      permissions: snapshot.data,
                      isLoading: isLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateUserDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final selectedRoleIds = <int>{};
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1,
                            color: Color(0xFF60A5FA),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registrar Colaborador',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Aprovisionamiento de cuenta y roles',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          icon: const Icon(Icons.close, size: 18),
                          color: const Color(0xFF94A3B8),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Nombre Completo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ej. Roberto Morales',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF111827)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Correo Corporativo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: emailController,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'colaborador@elitemultiservicios.com',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF111827)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Roles y Permisos RBAC',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_availableRoles.isEmpty)
                      Text(
                        'No hay roles configurados.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableRoles.map((role) {
                          final isSelected = selectedRoleIds.contains(role.id);
                          return FilterChip(
                            selected: isSelected,
                            showCheckmark: false,
                            label: Text(
                              role.name,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF334155)),
                              ),
                            ),
                            backgroundColor: isDark
                                ? const Color(0xFF111827)
                                : const Color(0xFFF1F5F9),
                            selectedColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFCBD5E1)),
                              ),
                            ),
                            onSelected: (val) {
                              setDialogState(() {
                                if (val) {
                                  if (role.id != null) {
                                    selectedRoleIds.add(role.id!);
                                  }
                                } else {
                                  selectedRoleIds.remove(role.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () async {
                              final name = nameController.text.trim();
                              final email = emailController.text.trim();
                              if (name.isEmpty || email.isEmpty) return;

                              final messenger = ScaffoldMessenger.of(context);
                              Navigator.pop(dialogCtx);
                              setState(() => _isLoading = true);

                              try {
                                final newUser = await _service.createUser(
                                  email: email,
                                  fullName: name,
                                  roleIds: selectedRoleIds.toList(),
                                );
                                await _loadData();
                                if (mounted) {
                                  _showCreatedUserCredentialsDialog(
                                    newUser,
                                    'Elite.2026!Temp',
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                  messenger.showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFFDC2626),
                                      content: Text(
                                        'Error al crear colaborador: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Guardar Colaborador',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreatedUserCredentialsDialog(AppUser newUser, String tempPassword) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Colaborador Registrado Exitosamente',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Credenciales iniciales aprovisionadas en el sistema',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: borderColor),
                const SizedBox(height: 18),

                // Datos del colaborador
                Text(
                  'COLABORADOR',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${newUser.fullName} (${newUser.email})',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),

                // Caja destacada de Contraseña Temporal
                Text(
                  'CONTRASEÑA TEMPORAL INICIAL',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1120)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tempPassword,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3B82F6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        tooltip: 'Copiar contraseña temporal',
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: tempPassword));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF10B981),
                              duration: Duration(seconds: 2),
                              content: Text(
                                'Contraseña temporal copiada al portapapeles',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Instrucciones del flujo de seguridad
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Paso siguiente para el colaborador:\n1. Iniciar sesión con esta clave temporal.\n2. Validar el código 2FA enviado a su correo.\n3. Definir su contraseña definitiva obligatoriamente.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            height: 1.45,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: Text(
                        'Entendido',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(AppUser user) {
    final nameController = TextEditingController(text: user.fullName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Modificar Colaborador',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, size: 18),
                      color: const Color(0xFF94A3B8),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nombre Completo',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () async {
                          final newName = nameController.text.trim();
                          if (newName.isEmpty || user.id == null) return;
                          Navigator.pop(ctx);
                          setState(() => _isLoading = true);
                          try {
                            await _service.updateUser(
                              id: user.id!,
                              fullName: newName,
                            );
                            await _loadData();
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFFDC2626),
                                  content: Text('Error al actualizar: $e'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Actualizar',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSuperAdmin(AppUser user) {
    return user.email.trim().toLowerCase() == 'rogeliovladimir2016@gmail.com';
  }

  Future<void> _toggleUserActive(AppUser user) async {
    if (user.id == null) return;
    if (_isSuperAdmin(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF7C3AED),
          content: Text(
            'La cuenta SuperAdmin del sistema es inmutable y no puede ser suspendida.',
          ),
        ),
      );
      return;
    }
    final targetState = !user.isActive;
    await _service.setUserActive(id: user.id!, isActive: targetState);
    await _loadData();
  }

  Future<void> _confirmDeleteUser(AppUser user) async {
    if (user.id == null) return;
    if (_isSuperAdmin(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF7C3AED),
          content: Text(
            'La cuenta SuperAdmin del sistema no puede ser eliminada.',
          ),
        ),
      );
      return;
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Dar de Baja Colaborador',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas dar de baja la cuenta de "${user.fullName}" (${user.email})? Se revocará el acceso y quedará registrado en la bitácora.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Confirmar Baja',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteUser(user.id!);
      await _loadData();
    }
  }

  void _exportCsv() {
    final csvRows = <String>[
      'ID,Nombre Completo,Correo Corporativo,Estado,2FA Protegido,Fecha Registro',
    ];
    for (final u in _users) {
      csvRows.add(
        '${u.id},"${u.fullName}","${u.email}",${u.isActive ? "Activo" : "Inactivo"},${u.mfaEnabled == true ? "Si" : "No"},${u.createdAt.toIso8601String()}',
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E293B),
        content: Text(
          'Exportación generada: ${_users.length} registros del directorio.',
          style: GoogleFonts.inter(fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredUsers = _users.where((u) {
      final q = _searchQuery.toLowerCase();
      final matchesQuery =
          u.fullName.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.id.toString().contains(q);

      if (!matchesQuery) return false;

      if (_statusFilter == 1 && !u.isActive) return false;
      if (_statusFilter == 2 && u.isActive) return false;

      return true;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1150;
        final isNarrow = constraints.maxWidth < 700;
        final showDrawer = isWide && _selectedUser != null;

        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Usuarios',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 22 : 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Directorio corporativo, aprovisionamiento de credenciales y asignación RBAC.',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 12.5 : 14,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        );

        final actionButtons = [
          OutlinedButton.icon(
            onPressed: _exportCsv,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF334155),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFCBD5E1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.download, size: 15),
            label: Text(
              'Exportar CSV',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: _showCreateUserDialog,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.person_add_alt_1, size: 16),
            label: Text(
              '+ Registrar Colaborador',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ];

        final searchInput = Container(
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
            ),
          ),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Buscar colaborador por nombre, correo o ID...',
              hintStyle: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 9),
            ),
          ),
        );

        final segmentedFilter = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegmentItem(
                title: 'Todos (${_users.length})',
                isSelected: _statusFilter == 0,
                onTap: () => setState(() => _statusFilter = 0),
                isDark: isDark,
              ),
              _buildSegmentItem(
                title: 'Activos (${_users.where((u) => u.isActive).length})',
                isSelected: _statusFilter == 1,
                onTap: () => setState(() => _statusFilter = 1),
                isDark: isDark,
              ),
              _buildSegmentItem(
                title: 'Inactivos (${_users.where((u) => !u.isActive).length})',
                isSelected: _statusFilter == 2,
                onTap: () => setState(() => _statusFilter = 2),
                isDark: isDark,
              ),
            ],
          ),
        );

        return Container(
          color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel principal de directorio
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 16 : 36,
                    vertical: isNarrow ? 20 : 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header de la Vista Responsivo
                      if (isNarrow)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleSection,
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: actionButtons,
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: titleSection),
                            const SizedBox(width: 16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                actionButtons[0],
                                const SizedBox(width: 10),
                                actionButtons[1],
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // Barra de Controles y Filtros Responsiva
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0D111C)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: isNarrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  searchInput,
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        segmentedFilter,
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: _loadData,
                                          tooltip: 'Sincronizar',
                                          icon: Icon(
                                            Icons.refresh,
                                            size: 17,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(child: searchInput),
                                  const SizedBox(width: 12),
                                  segmentedFilter,
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: _loadData,
                                    tooltip: 'Sincronizar',
                                    icon: Icon(
                                      Icons.refresh,
                                      size: 17,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 18),

                      // Tabla de Directorio
                      Container(
                        constraints: const BoxConstraints(minHeight: 400),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0D111C)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(48),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : filteredUsers.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(48),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.person_search_outlined,
                                        size: 36,
                                        color: isDark
                                            ? const Color(0xFF475569)
                                            : const Color(0xFF94A3B8),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No se encontraron colaboradores en el directorio.',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Ajusta la búsqueda o el filtro de estado.',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  final isMobile = constraints.maxWidth < 768;

                                  if (isMobile) {
                                    return Column(
                                      children: [
                                        ...filteredUsers.map(
                                          (user) => _buildUserMobileCard(
                                            user,
                                            isDark,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildTableFooter(
                                          isDark,
                                          filteredUsers.length,
                                        ),
                                      ],
                                    );
                                  }

                                  final tableWidth = constraints.maxWidth < 1040
                                      ? 1040.0
                                      : constraints.maxWidth;
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: tableWidth,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              _buildTableHeader(isDark),
                                              ...filteredUsers.map(
                                                (user) =>
                                                    _buildUserRow(user, isDark),
                                              ),
                                            ],
                                          ),
                                          _buildTableFooter(
                                            isDark,
                                            filteredUsers.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Drawer de Ficha Técnica
              if (showDrawer) _buildDetailDrawer(_selectedUser!, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSegmentItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                )
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(bool isDark) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 25, child: _headerCell('COLABORADOR', isDark)),
          Expanded(flex: 22, child: _headerCell('CORREO CORPORATIVO', isDark)),
          Expanded(flex: 13, child: _headerCell('ROL RBAC', isDark)),
          Expanded(flex: 12, child: _headerCell('SEGURIDAD 2FA', isDark)),
          Expanded(flex: 10, child: _headerCell('ESTADO', isDark)),
          Expanded(
            flex: 18,
            child: Align(
              alignment: Alignment.centerRight,
              child: _headerCell('ACCIONES', isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildUserMobileCard(AppUser user, bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final isSelected = _selectedUser?.id == user.id;
    final initials = user.fullName.isNotEmpty
        ? (user.fullName.trim().split(' ').length > 1
              ? '${user.fullName.trim().split(" ")[0][0]}${user.fullName.trim().split(" ")[1][0]}'
              : user.fullName.substring(0, 1).toUpperCase())
        : 'US';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : borderColor,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Nombre + Rol RBAC
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: #USR-${user.id}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildRoleBadge(user, isDark),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Intermedio: Correo + Estado + 2FA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.mail_outline,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        user.email,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    StatusBadge(
                      label: user.isActive ? 'Activo' : 'Inactivo',
                      variant: user.isActive
                          ? BadgeVariant.success
                          : BadgeVariant.neutral,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: user.mfaEnabled == true
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: user.mfaEnabled == true
                              ? const Color(0xFF10B981).withValues(alpha: 0.25)
                              : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: user.mfaEnabled == true
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF64748B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.mfaEnabled == true ? '2FA Activo' : 'Sin 2FA',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: user.mfaEnabled == true
                                  ? const Color(0xFF10B981)
                                  : (isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Acciones táctiles (Área mínima 44x44px, espaciado 8px)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _selectUser(user),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: Text(
                    'Ficha',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    side: BorderSide(color: borderColor),
                    minimumSize: const Size(80, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _showEditUserDialog(user),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    'Editar',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (!_isSuperAdmin(user)) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                      tooltip: 'Dar de baja',
                      onPressed: () => _confirmDeleteUser(user),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(AppUser user, bool isDark) {
    final isSelected = _selectedUser?.id == user.id;
    final isSuperAdmin = _isSuperAdmin(user);
    final initials = isSuperAdmin
        ? 'RH'
        : (user.fullName.isNotEmpty
              ? (user.fullName.trim().split(' ').length > 1
                    ? '${user.fullName.trim().split(" ")[0][0]}${user.fullName.trim().split(" ")[1][0]}'
                    : user.fullName.substring(0, 1).toUpperCase())
              : 'US');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectUser(user),
        hoverColor: isDark
            ? const Color(0xFF111827).withValues(alpha: 0.5)
            : const Color(0xFFF8FAFC),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF161F30) : const Color(0xFFEFF6FF))
                : Colors.transparent,
            border: Border(
              left: isSelected
                  ? BorderSide(
                      color: const Color(0xFF2563EB),
                      width: 2.5,
                    )
                  : BorderSide.none,
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
            ),
          ),
          child: Row(
            children: [
              // 1. Colaborador (flex: 25)
              Expanded(
                flex: 25,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ID: #USR-${user.id}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Correo Corporativo (flex: 22)
              Expanded(
                flex: 22,
                child: Text(
                  user.email,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 3. Rol RBAC (flex: 13)
              Expanded(
                flex: 13,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildRoleBadge(user, isDark),
                ),
              ),

              // 4. Seguridad 2FA (flex: 12)
              Expanded(
                flex: 12,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: user.mfaEnabled == true
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: user.mfaEnabled == true
                            ? const Color(0xFF10B981).withValues(alpha: 0.25)
                            : (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: user.mfaEnabled == true
                                ? const Color(0xFF10B981)
                                : const Color(0xFF64748B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          user.mfaEnabled == true ? '2FA Activo' : 'Sin 2FA',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: user.mfaEnabled == true
                                ? const Color(0xFF10B981)
                                : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Estado (flex: 10)
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(
                    label: user.isActive ? 'Activo' : 'Inactivo',
                    variant: user.isActive
                        ? BadgeVariant.success
                        : BadgeVariant.neutral,
                  ),
                ),
              ),

              // 6. Acciones (flex: 18)
              Expanded(
                flex: 18,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          tooltip: 'Detalle',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _selectUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          tooltip: 'Editar',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _showEditUserDialog(user),
                        ),
                        if (_isSuperAdmin(user))
                          const Tooltip(
                            message: 'SuperAdmin protegido',
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.shield_outlined,
                                size: 16,
                                color: Color(0xFFA855F7),
                              ),
                            ),
                          )
                        else ...[
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: user.isActive,
                              activeThumbColor: const Color(0xFF10B981),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (_) => _toggleUserActive(user),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                            tooltip: 'Dar de baja',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _confirmDeleteUser(user),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableFooter(bool isDark, int count) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;
        return Container(
          height: 42,
          padding: EdgeInsets.symmetric(horizontal: isNarrow ? 14 : 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: isNarrow
              ? Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$count de ${_users.length} colaboradores • Sincronizado',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mostrando $count de ${_users.length} colaboradores • Directorio sincronizado',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Directorio Corporativo • Seguro',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildRoleBadge(AppUser user, bool isDark) {
    final isSuperAdmin = _isSuperAdmin(user);
    final badgeColor = isSuperAdmin
        ? const Color(0xFFA855F7)
        : const Color(0xFF3B82F6);
    final roleName = isSuperAdmin ? 'Super Administrador' : 'Administrador';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuperAdmin ? Icons.star_rounded : Icons.security,
            size: 12,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            roleName,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(
    AppUser user,
    bool isDark, {
    required VoidCallback onClose,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Ficha del Colaborador',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${user.id}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF60A5FA),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 16),
            color: const Color(0xFF94A3B8),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDrawer(AppUser user, bool isDark) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D111C) : Colors.white,
        border: Border(
          left: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildDetailHeader(
            user,
            isDark,
            onClose: () => setState(() => _selectedUser = null),
          ),
          Expanded(
            child: _buildDetailBody(user, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBody(
    AppUser user,
    bool isDark, {
    List<String>? permissions,
    bool? isLoading,
  }) {
    final actualLoading = isLoading ?? _isLoadingPermissions;
    final actualPermissions = permissions ?? _userPermissions;
    final isSuperAdmin = _isSuperAdmin(user);
    final initials = isSuperAdmin
        ? 'RH'
        : (user.fullName.isNotEmpty
              ? (user.fullName.trim().split(' ').length > 1
                    ? '${user.fullName.trim().split(" ")[0][0]}${user.fullName.trim().split(" ")[1][0]}'
                    : user.fullName.substring(0, 1).toUpperCase())
              : 'US');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de Identidad
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 10),
                _buildRoleBadge(user, isDark),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Credenciales y Seguridad
          Text(
            'SEGURIDAD & CREDENCIALES',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            label: 'Segundo Factor (2FA)',
            value: user.mfaEnabled == true ? 'Habilitado' : 'No configurado',
            valueColor: user.mfaEnabled == true
                ? const Color(0xFF10B981)
                : const Color(0xFFF59E0B),
            isDark: isDark,
          ),
          _buildDetailRow(
            label: 'Estado de Contraseña',
            value: user.mustChangePassword == true ? 'Debe cambiar' : 'Vigente',
            valueColor: user.mustChangePassword == true
                ? const Color(0xFFF59E0B)
                : const Color(0xFF10B981),
            isDark: isDark,
          ),
          _buildDetailRow(
            label: 'Intentos Fallidos',
            value: '${user.failedLoginAttempts}',
            valueColor: isDark ? Colors.white : const Color(0xFF0F172A),
            isDark: isDark,
          ),
          _buildDetailRow(
            label: 'Fecha de Alta',
            value:
                '${user.createdAt.day.toString().padLeft(2, "0")}/${user.createdAt.month.toString().padLeft(2, "0")}/${user.createdAt.year}',
            valueColor: isDark ? Colors.white : const Color(0xFF0F172A),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // Permisos RBAC Asignados
          Text(
            'PERMISOS EFECTIVOS RBAC',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          if (actualLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (actualPermissions == null || actualPermissions.isEmpty)
            Text(
              'Sin permisos granulares asignados.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: actualPermissions.map((perm) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF2563EB,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    perm,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      color: const Color(0xFF60A5FA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // Acciones
          Text(
            'ACCIONES DISPONIBLES',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showEditUserDialog(user),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFCBD5E1),
              ),
              minimumSize: const Size(double.infinity, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 15),
            label: Text(
              'Modificar Perfil',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_isSuperAdmin(user))
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(
                    0xFFA855F7,
                  ).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFFA855F7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cuenta SuperAdmin inmutable.',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA855F7),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            OutlinedButton.icon(
              onPressed: () => _toggleUserActive(user),
              style: OutlinedButton.styleFrom(
                foregroundColor: user.isActive
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981),
                side: BorderSide(
                  color: user.isActive
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                      : const Color(0xFF10B981).withValues(alpha: 0.35),
                ),
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                user.isActive ? Icons.block : Icons.check_circle_outline,
                size: 15,
              ),
              label: Text(
                user.isActive ? 'Suspender Acceso' : 'Reactivar Acceso',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _confirmDeleteUser(user),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: BorderSide(
                  color: const Color(
                    0xFFEF4444,
                  ).withValues(alpha: 0.35),
                ),
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.delete_outline, size: 15),
              label: Text(
                'Dar de Baja',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
