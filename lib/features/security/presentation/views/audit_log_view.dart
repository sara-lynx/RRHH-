import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

/// Vista ejecutiva minimalista de Bitácora de Auditoría del Sistema.
/// Estilo sobrio, tipografía Inter y JetBrains Mono, trazabilidad criptográfica
/// y cumplimiento estricto de accesibilidad y tests.
class AuditLogView extends StatefulWidget {
  final SecurityApiService? service;

  const AuditLogView({super.key, this.service});

  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  late final SecurityApiService _service;
  bool _isLoading = true;

  // Estado de datos
  List<AuditLog> _logs = [];
  int _page = 1;
  final int _pageSize = 25;
  int _totalCount = 0;
  int _totalPages = 1;

  // Filtros
  final _searchController = TextEditingController();
  String _selectedAction = 'TODAS';
  String _selectedResult = 'TODOS';
  DateTimeRange? _selectedDateRange;

  final _actionOptions = const [
    'TODAS',
    'LOGIN_SUCCESS',
    'LOGIN_FAILED',
    'MFA_VERIFIED',
    'MFA_CHALLENGE_ISSUED',
    'LOGOUT',
    'PASSWORD_CHANGED',
    'USER_CREATED',
    'USER_UPDATED',
    'USER_DISABLED',
    'ROLE_UPDATED',
    'SESSION_REVOKED',
  ];

  final _resultOptions = const [
    'TODOS',
    'SUCCESS',
    'FAILURE',
    'BLOCKED',
  ];

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? SecurityApiService();
    _loadLogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs({int? newPage}) async {
    final pageToLoad = newPage ?? _page;
    setState(() => _isLoading = true);

    try {
      final actionFilter = _selectedAction == 'TODAS' ? null : _selectedAction;
      final resultFilter = _selectedResult == 'TODOS' ? null : _selectedResult;
      final searchFilter = _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim();

      final pageResponse = await _service.listAuditLogsPaged(
        page: pageToLoad,
        pageSize: _pageSize,
        action: actionFilter,
        result: resultFilter,
        fromDate: _selectedDateRange?.start.toUtc(),
        toDate: _selectedDateRange?.end
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1))
            .toUtc(),
        search: searchFilter,
      );

      if (mounted) {
        setState(() {
          _logs = pageResponse.items;
          _totalCount = pageResponse.totalCount;
          _totalPages = pageResponse.totalPages;
          _page = pageResponse.page;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedAction = 'TODAS';
      _selectedResult = 'TODOS';
      _selectedDateRange = null;
      _page = 1;
    });
    _loadLogs(newPage: 1);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      helpText: 'Seleccionar rango de auditoría',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      saveText: 'Guardar',
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _page = 1;
      });
      _loadLogs(newPage: 1);
    }
  }

  bool _isUuid(String? str) {
    if (str == null) return false;
    final clean = str.trim();
    return clean.length >= 32 && clean.contains('-');
  }

  String _cleanUserIdentifier(String? raw, {int? userId}) {
    if (raw == null || raw.trim().isEmpty) {
      if (userId != null) return 'Usuario #$userId';
      return 'Sistema / Proceso Interno';
    }
    final clean = raw.trim();
    if (_isUuid(clean)) {
      if (userId != null) return 'Usuario #$userId';
      return 'Usuario (${clean.substring(0, 8)})';
    }
    return clean;
  }

  String _cleanUserRoleLabel(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'Proceso Automatizado';
    final clean = raw.trim().toLowerCase();
    if (clean.contains('admin') || clean.contains('superadmin')) {
      return 'Super Administrador';
    }
    return 'Usuario Operativo';
  }

  String _cleanIpAddress(String? ip) {
    if (ip == null || ip.isEmpty) return '127.0.0.1';
    final trimmed = ip.trim();
    if (trimmed == '::1') return '127.0.0.1 (Localhost)';
    return trimmed;
  }

  String _cleanResource(String? resource) {
    if (resource == null || resource.isEmpty) return 'Operación General';
    if (resource == 'mfa_challenge') return 'Desafío MFA / 2FA';
    if (resource == 'auth_idp') return 'Servicio de Autenticación';
    if (resource.startsWith('session:')) {
      final parts = resource.split('/');
      final sessNum = parts[0].replaceAll('session:#', '');
      return 'Sesión #$sessNum';
    }
    if (resource.startsWith('user:')) {
      final num = resource.replaceAll('user:#', '');
      return 'Usuario #$num';
    }
    if (resource.startsWith('role:')) {
      final num = resource.replaceAll('role:#', '');
      return 'Rol #$num';
    }
    return resource;
  }

  (String, IconData, Color) _getActionDetails(String action) {
    switch (action.toUpperCase()) {
      case 'LOGIN_SUCCESS':
        return ('Inicio Exitoso', Icons.login, const Color(0xFF10B981));
      case 'LOGIN_FAILED':
        return ('Acceso Fallido', Icons.error_outline, const Color(0xFFEF4444));
      case 'MFA_VERIFIED':
        return (
          '2FA Verificado',
          Icons.verified_user_outlined,
          const Color(0xFF2563EB),
        );
      case 'MFA_CHALLENGE_ISSUED':
        return (
          'Desafío 2FA',
          Icons.mark_email_read_outlined,
          const Color(0xFF8B5CF6),
        );
      case 'LOGOUT':
        return ('Cierre de Sesión', Icons.logout, const Color(0xFF64748B));
      case 'PASSWORD_CHANGED':
        return ('Clave Cambiada', Icons.key_outlined, const Color(0xFFF59E0B));
      case 'USER_CREATED':
        return (
          'Usuario Creado',
          Icons.person_add_outlined,
          const Color(0xFF10B981),
        );
      case 'USER_UPDATED':
        return (
          'Usuario Modificado',
          Icons.manage_accounts_outlined,
          const Color(0xFF2563EB),
        );
      case 'USER_DISABLED':
        return (
          'Usuario Desactivado',
          Icons.person_off_outlined,
          const Color(0xFFEF4444),
        );
      case 'ROLE_UPDATED':
        return (
          'Rol Modificado',
          Icons.admin_panel_settings_outlined,
          const Color(0xFF8B5CF6),
        );
      case 'SESSION_REVOKED':
        return (
          'Sesión Revocada',
          Icons.power_settings_new_outlined,
          const Color(0xFFEF4444),
        );
      default:
        return (action, Icons.security_outlined, const Color(0xFF64748B));
    }
  }

  void _showLogDetail(AuditLog log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    String prettyJson = log.metadata ?? '';
    if (log.metadata != null && log.metadata!.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(log.metadata!);
        const encoder = JsonEncoder.withIndent('  ');
        prettyJson = encoder.convert(decoded);
      } catch (_) {
        prettyJson = log.metadata!;
      }
    }

    final cleanUser = _cleanUserIdentifier(
      log.userIdentifier,
      userId: log.userId,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
                    'Detalle de Evento: ${log.action}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Registro inmutable con trazabilidad SHA-256',
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
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('ID Registro', '#${log.id}', isDark),
                _detailRow('Acción Canónica', log.action, isDark),
                _detailRow('Usuario / Actor', cleanUser, isDark),
                _detailRow(
                  'Recurso Afectado',
                  _cleanResource(log.resource),
                  isDark,
                ),
                _detailRow(
                  'Dirección IP',
                  _cleanIpAddress(log.ipAddress),
                  isDark,
                ),
                _detailRow('Resultado', log.result, isDark),
                _detailRow(
                  'Fecha UTC',
                  '${log.timestamp.toIso8601String().replaceAll('T', ' ').substring(0, 19)} UTC',
                  isDark,
                ),
                const SizedBox(height: 16),
                Text(
                  'Metadatos Estructurados (JSON):',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF080D1A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: SelectableText(
                    prettyJson.isNotEmpty
                        ? prettyJson
                        : 'Sin metadatos adicionales.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      color: isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF0F172A),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prettyJson));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Metadatos copiados al portapapeles'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 14),
            label: Text(
              'Copiar JSON',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Cerrar',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String val, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$title:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
                fontSize: 12.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: isDark
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final startItem = _totalCount == 0 ? 0 : (_page - 1) * _pageSize + 1;
    final endItem = (_page * _pageSize) > _totalCount
        ? _totalCount
        : (_page * _pageSize);

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
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 18),

              // 2. Barra de Búsqueda y Filtros
              _buildFilterBar(isDark),
              const SizedBox(height: 18),

              // 3. Tabla de Bitácora (Scroll horizontal en móvil)
              _buildAuditTable(isDark, constraints.maxWidth),
              const SizedBox(height: 16),

              // 4. Footer de Paginación
              _buildPaginationFooter(isDark, startItem, endItem),
            ],
          ),
        );
      },
    );
  }

  // --- CABECERA ---
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
              'Bitácora de Auditoría del Sistema',
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
                '$_totalCount registros',
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
          'Trazabilidad criptográfica de accesos, operaciones de seguridad y eventos del sistema.',
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
      onPressed: () => _loadLogs(),
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

  // --- BARRA DE FILTROS ---
  Widget _buildFilterBar(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final hasFilters =
        _selectedAction != 'TODAS' ||
        _selectedResult != 'TODOS' ||
        _selectedDateRange != null ||
        _searchController.text.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 820;

        final searchInput = Container(
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _loadLogs(newPage: 1),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Buscar por usuario, IP, recurso o acción...',
              hintStyle: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 16,
                color: Color(0xFF64748B),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 14),
                      onPressed: () {
                        _searchController.clear();
                        _loadLogs(newPage: 1);
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        );

        final filterControls = [
          // Dropdown Acción
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedAction,
                dropdownColor: cardBg,
                borderRadius: BorderRadius.circular(8),
                items: _actionOptions.map((a) {
                  return DropdownMenuItem(
                    value: a,
                    child: Text(
                      a == 'TODAS' ? 'Acción: Todas' : a,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedAction = val);
                    _loadLogs(newPage: 1);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Dropdown Resultado
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedResult,
                dropdownColor: cardBg,
                borderRadius: BorderRadius.circular(8),
                items: _resultOptions.map((r) {
                  return DropdownMenuItem(
                    value: r,
                    child: Text(
                      r == 'TODOS' ? 'Resultado: Todos' : r,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedResult = val);
                    _loadLogs(newPage: 1);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Selector de Fechas
          OutlinedButton.icon(
            onPressed: _pickDateRange,
            icon: const Icon(Icons.calendar_today_outlined, size: 14),
            label: Text(
              _selectedDateRange == null
                  ? 'Fechas'
                  : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: BorderSide(
                color: _selectedDateRange != null
                    ? const Color(0xFF2563EB)
                    : borderColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          if (hasFilters) ...[
            const SizedBox(width: 4),
            IconButton(
              tooltip: 'Limpiar filtros',
              icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
              color: const Color(0xFFEF4444),
              onPressed: _clearFilters,
            ),
          ],
        ];

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
                    searchInput,
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: filterControls),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(flex: 3, child: searchInput),
                    const SizedBox(width: 10),
                    ...filterControls,
                  ],
                ),
        );
      },
    );
  }

  // --- TABLA DE AUDITORÍA ---
  Widget _buildAuditTable(bool isDark, double parentWidth) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final tableContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header de columnas
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
              Expanded(
                flex: 18,
                child: _tableHeaderLabel('FECHA Y HORA (UTC)'),
              ),
              Expanded(flex: 24, child: _tableHeaderLabel('USUARIO / ACTOR')),
              Expanded(flex: 20, child: _tableHeaderLabel('ACCIÓN')),
              Expanded(flex: 16, child: _tableHeaderLabel('RECURSO')),
              Expanded(flex: 12, child: _tableHeaderLabel('DIRECCIÓN IP')),
              Expanded(flex: 10, child: _tableHeaderLabel('RESULTADO')),
              const SizedBox(
                width: 70,
                child: Center(
                  child: Text(
                    'DETALLE',
                    softWrap: false,
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

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(50),
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
          )
        else if (_logs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(50),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.history_toggle_off,
                    size: 32,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No hay eventos de auditoría para mostrar.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
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
            itemCount: _logs.length,
            separatorBuilder: (ctx, index) => Divider(
              height: 1,
              color: borderColor,
            ),
            itemBuilder: (context, index) {
              final log = _logs[index];
              return _buildAuditRow(log, isDark);
            },
          ),
      ],
    );

    final isMobile = parentWidth < 768;

    if (isMobile) {
      if (_logs.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 32,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(height: 8),
                Text(
                  'No hay eventos que coincidan',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _logs.length,
        itemBuilder: (context, index) =>
            _buildAuditMobileCard(_logs[index], isDark),
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

  Widget _buildAuditMobileCard(AuditLog log, bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cleanUser = _cleanUserIdentifier(
      log.userIdentifier,
      userId: log.userId,
    );
    final cleanRes = _cleanResource(log.resource);
    final cleanIp = _cleanIpAddress(log.ipAddress);
    final (actionLabel, actionIcon, actionColor) = _getActionDetails(
      log.action,
    );
    final isSuccess = log.result.toUpperCase() == 'SUCCESS';

    final formattedDate =
        '${log.timestamp.day.toString().padLeft(2, '0')}/${log.timestamp.month.toString().padLeft(2, '0')}/${log.timestamp.year} ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')} UTC';

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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: actionColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(actionIcon, size: 15, color: actionColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: actionColor,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                label: log.result,
                variant: isSuccess ? BadgeVariant.success : BadgeVariant.danger,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            cleanUser,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                size: 13,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  cleanRes,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                cleanIp,
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
                formattedDate,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () => _showLogDetail(log),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Detalle',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAuditRow(AuditLog log, bool isDark) {
    final cleanUser = _cleanUserIdentifier(
      log.userIdentifier,
      userId: log.userId,
    );
    final userRole = _cleanUserRoleLabel(log.userIdentifier);
    final cleanIp = _cleanIpAddress(log.ipAddress);
    final cleanRes = _cleanResource(log.resource);
    final (actionLabel, actionIcon, actionColor) = _getActionDetails(
      log.action,
    );

    final formattedDate =
        '${log.timestamp.day.toString().padLeft(2, '0')}/${log.timestamp.month.toString().padLeft(2, '0')}/${log.timestamp.year} ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}';

    final isSuccess = log.result.toUpperCase() == 'SUCCESS';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLogDetail(log),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // 1. Fecha y Hora (UTC)
              Expanded(
                flex: 18,
                child: Text(
                  formattedDate,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                ),
              ),

              // 2. Usuario / Actor
              Expanded(
                flex: 24,
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
                          cleanUser.contains('admin')
                              ? 'AD'
                              : (cleanUser.isNotEmpty
                                    ? cleanUser[0].toUpperCase()
                                    : 'U'),
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
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
                            cleanUser,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            userRole,
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

              // 3. Acción
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(actionIcon, size: 13, color: actionColor),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            actionLabel,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: actionColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      log.action,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 4. Recurso
              Expanded(
                flex: 16,
                child: Text(
                  cleanRes,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 5. Dirección IP
              Expanded(
                flex: 12,
                child: Text(
                  cleanIp,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 6. Resultado
              Expanded(
                flex: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: StatusBadge(
                        label: log.result,
                        variant: isSuccess
                            ? BadgeVariant.success
                            : BadgeVariant.danger,
                      ),
                    ),
                  ],
                ),
              ),

              // 7. Detalle
              SizedBox(
                width: 70,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 17,
                      color: Color(0xFF64748B),
                    ),
                    tooltip: 'Ver detalle completo',
                    onPressed: () => _showLogDetail(log),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- FOOTER DE PAGINACIÓN ---
  Widget _buildPaginationFooter(bool isDark, int startItem, int endItem) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 620;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 14 : 20,
            vertical: isNarrow ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Mostrando $startItem a $endItem de $_totalCount registros',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _page > 1
                              ? () => _loadLogs(newPage: _page - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left, size: 16),
                          label: Text(
                            'Anterior',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$_page / $_totalPages',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _page < _totalPages
                              ? () => _loadLogs(newPage: _page + 1)
                              : null,
                          icon: const Icon(Icons.chevron_right, size: 16),
                          label: Text(
                            'Siguiente',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Mostrando $startItem a $endItem de $_totalCount registros',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _page > 1
                              ? () => _loadLogs(newPage: _page - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left, size: 16),
                          label: Text(
                            'Anterior',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Página $_page de $_totalPages',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _page < _totalPages
                              ? () => _loadLogs(newPage: _page + 1)
                              : null,
                          icon: const Icon(Icons.chevron_right, size: 16),
                          label: Text(
                            'Siguiente',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
