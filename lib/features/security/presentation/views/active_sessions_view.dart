import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

/// Helper para clasificar y formatear la información de dispositivo y agente de usuario.
class ParsedDeviceInfo {
  final String browserName;
  final String osName;
  final IconData icon;
  final String friendlyTitle;

  const ParsedDeviceInfo({
    required this.browserName,
    required this.osName,
    required this.icon,
    required this.friendlyTitle,
  });

  static ParsedDeviceInfo parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return const ParsedDeviceInfo(
        browserName: 'Cliente Web',
        osName: 'Estación de Trabajo',
        icon: Icons.devices_outlined,
        friendlyTitle: 'Navegador Web / Cliente Conectado',
      );
    }

    final lower = raw.toLowerCase();

    // Detección de Sistema Operativo
    String os = 'Estación de Trabajo';
    IconData icon = Icons.laptop_outlined;

    if (lower.contains('windows')) {
      os = 'Windows 11 / PC';
      icon = Icons.laptop_windows_outlined;
    } else if (lower.contains('macintosh') ||
        lower.contains('mac os') ||
        lower.contains('macos')) {
      os = 'macOS / Apple';
      icon = Icons.laptop_mac_outlined;
    } else if (lower.contains('iphone') ||
        lower.contains('ipad') ||
        lower.contains('ios')) {
      os = 'iOS / Apple Móvil';
      icon = Icons.phone_iphone_outlined;
    } else if (lower.contains('android')) {
      os = 'Android Móvil';
      icon = Icons.phone_android_outlined;
    } else if (lower.contains('linux')) {
      os = 'Linux / Unix';
      icon = Icons.terminal_outlined;
    }

    // Detección de Navegador / Cliente
    String browser = 'Navegador Web';
    if (lower.contains('edg/') || lower.contains('edge/')) {
      browser = 'Microsoft Edge';
    } else if (lower.contains('chrome') && !lower.contains('edg')) {
      browser = 'Google Chrome';
    } else if (lower.contains('firefox')) {
      browser = 'Mozilla Firefox';
    } else if (lower.contains('safari') && !lower.contains('chrome')) {
      browser = 'Apple Safari';
    } else if (lower.contains('opera') || lower.contains('opr/')) {
      browser = 'Opera Browser';
    } else if (lower.contains('dart') || lower.contains('flutter')) {
      browser = 'Cliente Flutter Nativo';
    }

    return ParsedDeviceInfo(
      browserName: browser,
      osName: os,
      icon: icon,
      friendlyTitle: '$browser en $os',
    );
  }
}

/// Vista ejecutiva minimalista de Sesiones Activas
class ActiveSessionsView extends StatefulWidget {
  final SecurityApiService? service;

  const ActiveSessionsView({super.key, this.service});

  @override
  State<ActiveSessionsView> createState() => _ActiveSessionsViewState();
}

class _ActiveSessionsViewState extends State<ActiveSessionsView> {
  late final SecurityApiService _service;

  bool _isLoading = true;
  String? _errorMessage;

  List<UserSession> _allSessions = [];
  Map<int, AppUser> _usersMap = {};

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedMfaFilter = 'TODOS'; // 'TODOS', 'CON_MFA', 'SIN_MFA'

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? SecurityApiService();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<AppUser> users = [];
      try {
        users = await _service.listUsers();
      } catch (_) {
        users = [];
      }

      final usersMap = <int, AppUser>{};
      for (final u in users) {
        if (u.id != null) {
          usersMap[u.id!] = u;
        }
      }

      final sessionsList = <UserSession>[];

      if (users.isNotEmpty) {
        final sessionFutures = users
            .where((u) => u.id != null)
            .map((u) => _service.listUserSessions(u.id!));
        final results = await Future.wait(sessionFutures);
        for (final list in results) {
          sessionsList.addAll(list);
        }
      } else {
        final defaultSessions = await _service.listUserSessions(1);
        sessionsList.addAll(defaultSessions);
      }

      sessionsList.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));

      if (mounted) {
        setState(() {
          _usersMap = usersMap;
          _allSessions = sessionsList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al sincronizar sesiones activas: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _revokeSession(UserSession session) async {
    if (session.id == null) return;

    final user = _usersMap[session.userId];
    final userLabel = user?.fullName ?? 'Usuario #${session.userId}';
    final parsed = ParsedDeviceInfo.parse(session.deviceInfo);
    final ipClean = _sanitizeIp(session.ipAddress);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final borderColor = isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFE2E8F0);
        final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
          backgroundColor: cardBg,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.power_settings_new_outlined,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '¿Revocar sesión #${session.id}?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'El token de acceso será invalidado de inmediato. El usuario perderá la conexión activa en este dispositivo.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1120)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      _buildDialogRow(
                        Icons.person_outline,
                        'Usuario',
                        userLabel,
                        isDark,
                      ),
                      const SizedBox(height: 6),
                      _buildDialogRow(
                        parsed.icon,
                        'Dispositivo',
                        parsed.friendlyTitle,
                        isDark,
                      ),
                      const SizedBox(height: 6),
                      _buildDialogRow(
                        Icons.router_outlined,
                        'Dirección IP',
                        ipClean,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Confirmar Revocación',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final success = await _service.revokeSession(session.id!);
      if (success) {
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF059669),
              behavior: SnackBarBehavior.floating,
              content: Text('Sesión revocada exitosamente.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFDC2626),
              content: Text('No fue posible revocar la sesión.'),
            ),
          );
        }
      }
    }
  }

  Widget _buildDialogRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  void _showSessionDetailModal(UserSession session) {
    final user = _usersMap[session.userId];
    final parsed = ParsedDeviceInfo.parse(session.deviceInfo);
    final ipClean = _sanitizeIp(session.ipAddress);

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final borderColor = isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFE2E8F0);
        final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

        return AlertDialog(
          backgroundColor: cardBg,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.fingerprint_rounded,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ficha Técnica de Sesión #${session.id ?? "N/A"}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Trazabilidad criptográfica y parámetros de red',
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
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Identidad del Usuario Autenticado',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1120)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        _buildDetailKV(
                          'Nombre Completo',
                          user?.fullName ?? 'Super Administrador Principal',
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildDetailKV(
                          'Correo Electrónico',
                          user?.email ?? 'rogeliovladimir2016@gmail.com',
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildDetailKV(
                          'Identificador',
                          'User #${session.userId}',
                          isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dispositivo y Conectividad',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1120)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        _buildDetailKV(
                          'Dispositivo',
                          parsed.friendlyTitle,
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildDetailKV('Dirección IP', ipClean, isDark),
                        const SizedBox(height: 6),
                        _buildDetailKV(
                          'Protección 2FA',
                          session.mfaVerified == true
                              ? '2FA Verificado'
                              : 'Sin MFA',
                          isDark,
                          isSuccess: session.mfaVerified == true,
                        ),
                        const SizedBox(height: 6),
                        _buildDetailKV(
                          'Creada',
                          _formatDateTime(session.createdAt),
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildDetailKV(
                          'Última Actividad',
                          _formatDateTime(session.lastActivityAt),
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _revokeSession(session);
              },
              icon: const Icon(Icons.power_settings_new, size: 14),
              label: Text(
                'Revocar',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailKV(
    String key,
    String value,
    bool isDark, {
    bool? isSuccess,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        if (isSuccess != null)
          StatusBadge(
            label: value,
            variant: isSuccess ? BadgeVariant.success : BadgeVariant.warning,
          )
        else
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
      ],
    );
  }

  String _sanitizeIp(String? ip) {
    if (ip == null || ip.isEmpty) return '127.0.0.1 (Localhost)';
    final clean = ip.trim();
    if (clean == '::1' || clean == '0:0:0:0:0:0:0:1' || clean == 'localhost') {
      return '127.0.0.1 (Localhost / Servidor)';
    }
    return clean;
  }

  String _formatDateTime(DateTime dt) {
    final l = dt.toLocal();
    final y = l.year.toString();
    final m = l.month.toString().padLeft(2, '0');
    final d = l.day.toString().padLeft(2, '0');
    final h = l.hour.toString().padLeft(2, '0');
    final min = l.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  String _formatRelativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt.toLocal());

    if (diff.inSeconds < 60) return 'En línea ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return 'Hace ${diff.inDays}d';
  }

  List<UserSession> get _filteredSessions {
    return _allSessions.where((s) {
      if (_selectedMfaFilter == 'CON_MFA' && s.mfaVerified != true) {
        return false;
      }
      if (_selectedMfaFilter == 'SIN_MFA' && s.mfaVerified == true) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final user = _usersMap[s.userId];
        final userName = (user?.fullName ?? '').toLowerCase();
        final userEmail = (user?.email ?? '').toLowerCase();
        final ip = (s.ipAddress ?? '').toLowerCase();
        final device = (s.deviceInfo ?? '').toLowerCase();

        final matches =
            userName.contains(query) ||
            userEmail.contains(query) ||
            ip.contains(query) ||
            device.contains(query);
        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _filteredSessions;
    final totalCount = _allSessions.length;
    final mfaCount = _allSessions.where((s) => s.mfaVerified == true).length;
    final uniqueIps = _allSessions
        .map((s) => s.ipAddress ?? '127.0.0.1')
        .toSet()
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
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
              _buildHeader(isDark, totalCount, mfaCount, uniqueIps, isNarrow),
              const SizedBox(height: 18),

              // 2. Barra de Búsqueda y Filtros
              _buildFilterBar(isDark),
              const SizedBox(height: 18),

              // 3. Listado de Sesiones Activas (Scroll horizontal en móvil)
              if (_isLoading)
                _buildLoadingState(isDark)
              else if (_errorMessage != null)
                _buildErrorState(isDark)
              else if (filtered.isEmpty)
                _buildEmptyState(isDark)
              else
                _buildSessionsList(filtered, isDark, constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  // --- CABECERA ---
  Widget _buildHeader(
    bool isDark,
    int totalSessions,
    int mfaSessions,
    int uniqueIps,
    bool isNarrow,
  ) {
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
              'Monitoreo de Sesiones Activas',
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
                'CONTROL DE CONCURRENCIA & SESIONES',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Supervisión en tiempo real de terminales autenticadas y control de revocación inmediata.',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNarrow)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoCol,
                const SizedBox(height: 14),
                refreshBtn,
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoCol),
                const SizedBox(width: 16),
                refreshBtn,
              ],
            ),
          const SizedBox(height: 18),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 14),
          // 3 Indicadores Discretos
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildMetricChip(
                'Sesiones Activas',
                '$totalSessions concurrentes',
                isDark,
              ),
              _buildMetricChip(
                'Protección 2FA / MFA',
                '$mfaSessions con doble factor',
                isDark,
              ),
              _buildMetricChip(
                'IPs / Nodos Únicos',
                '$uniqueIps direcciones auditadas',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final bg = isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
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
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // --- FILTROS ---
  Widget _buildFilterBar(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 650;

        final searchField = Container(
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Buscar por usuario, correo, IP o dispositivo...',
              hintStyle: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 16,
                color: Color(0xFF64748B),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 14),
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
        );

        final mfaFilter = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMfaFilterOption('TODOS', 'Todas', isDark),
              _buildMfaFilterOption('CON_MFA', 'Con 2FA', isDark),
              _buildMfaFilterOption('SIN_MFA', 'Sin 2FA', isDark),
            ],
          ),
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: mfaFilter,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    mfaFilter,
                  ],
                ),
        );
      },
    );
  }

  Widget _buildMfaFilterOption(String key, String label, bool isDark) {
    final isSelected = _selectedMfaFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedMfaFilter = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // --- LISTADO DE SESIONES ---
  Widget _buildSessionsList(
    List<UserSession> sessions,
    bool isDark,
    double parentWidth,
  ) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final tableContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header de la tabla
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Row(
            children: [
              Expanded(flex: 22, child: _headerLabel('COLABORADOR')),
              Expanded(flex: 20, child: _headerLabel('DISPOSITIVO')),
              Expanded(flex: 16, child: _headerLabel('DIRECCIÓN IP')),
              Expanded(flex: 16, child: _headerLabel('ESTADO 2FA')),
              Expanded(flex: 12, child: _headerLabel('ACTIVIDAD')),
              const SizedBox(
                width: 140,
                child: Center(
                  child: Text(
                    'ACCIONES',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (ctx, index) =>
              Divider(height: 1, color: borderColor),
          itemBuilder: (ctx, index) {
            final session = sessions[index];
            return _buildSessionRow(session, isDark);
          },
        ),
      ],
    );

    final isMobile = parentWidth < 768;

    if (isMobile) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder: (ctx, index) =>
            _buildSessionMobileCard(sessions[index], isDark),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: tableContent,
    );
  }

  Widget _buildSessionMobileCard(UserSession session, bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final user = _usersMap[session.userId];
    final parsed = ParsedDeviceInfo.parse(session.deviceInfo);
    final ipClean = _sanitizeIp(session.ipAddress);
    final isMfa = session.mfaVerified == true;
    final userName = user?.fullName ?? 'Usuario #${session.userId}';
    final userEmail = user?.email ?? 'ID #${session.userId}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        userEmail,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge(
                label: isMfa ? '2FA Verificado' : 'Sin 2FA',
                variant: isMfa ? BadgeVariant.success : BadgeVariant.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(parsed.icon, size: 14, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  parsed.friendlyTitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ipClean,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actividad: ${_formatRelativeTime(session.lastActivityAt)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => _showSessionDetailModal(session),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(color: borderColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'Ficha',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.power_settings_new,
                      size: 16,
                      color: Color(0xFFEF4444),
                    ),
                    tooltip: 'Revocar Sesión',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _revokeSession(session),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerLabel(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSessionRow(UserSession session, bool isDark) {
    final user = _usersMap[session.userId];
    final parsed = ParsedDeviceInfo.parse(session.deviceInfo);
    final ipClean = _sanitizeIp(session.ipAddress);
    final isMfa = session.mfaVerified == true;
    final userName = user?.fullName ?? 'Usuario #${session.userId}';
    final userEmail = user?.email ?? 'ID #${session.userId}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // 1. Colaborador
          Expanded(
            flex: 22,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userEmail,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Dispositivo
          Expanded(
            flex: 20,
            child: Row(
              children: [
                Icon(parsed.icon, size: 15, color: const Color(0xFF64748B)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    parsed.friendlyTitle,
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
          ),

          // 3. Dirección IP
          Expanded(
            flex: 16,
            child: Text(
              ipClean,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 4. Estado 2FA
          Expanded(
            flex: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isMfa
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isMfa ? '2FA Verificado' : 'Sin MFA',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isMfa
                          ? const Color(0xFF10B981)
                          : (isDark
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD97706)),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 5. Actividad
          Expanded(
            flex: 12,
            child: Text(
              _formatRelativeTime(session.lastActivityAt),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ),

          // 6. Acciones
          SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showSessionDetailModal(session),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Ficha',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Revocar sesión',
                  icon: const Icon(Icons.power_settings_new_outlined, size: 16),
                  color: const Color(0xFFEF4444),
                  onPressed: () => _revokeSession(session),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return const Padding(
      padding: EdgeInsets.all(60),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF2563EB),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage ?? 'Ocurrió un error inesperado.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: _loadData,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.devices_outlined,
              size: 32,
              color: Color(0xFF64748B),
            ),
            const SizedBox(height: 10),
            Text(
              'No se encontraron sesiones activas.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
