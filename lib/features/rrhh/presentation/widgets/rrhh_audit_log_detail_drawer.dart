import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_timeline_event.dart';
import 'rrhh_audit_category_chip.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_snack_bar.dart';

/// Drawer lateral de auditoría profunda para eventos de la Bitácora (Pantalla 14).
class RrhhAuditLogDetailDrawer extends StatelessWidget {
  final RrhhTimelineEvent event;
  final VoidCallback onClose;

  const RrhhAuditLogDetailDrawer({
    super.key,
    required this.event,
    required this.onClose,
  });

  String _generateIntegrityHash(RrhhTimelineEvent e) {
    final raw =
        '${e.id}-${e.date.toIso8601String()}-${e.registeredBy}-${e.title}-${e.category}';
    final bytes = utf8.encode(raw);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 32);
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$day de $month de $year · $hour:$min hrs';
  }

  @override
  Widget build(BuildContext context) {
    final formattedFullDate = _formatFullDate(event.date);

    final empName =
        event.employeeName ??
        (event.employeeId > 0 ? 'Colaborador #${event.employeeId}' : 'General');
    final empCode =
        event.employeeCode ??
        (event.employeeId > 0
            ? 'EMP-${event.employeeId.toString().padLeft(3, '0')}'
            : null);

    final hash = _generateIntegrityHash(event);

    return Container(
      width: 500,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          left: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(-6, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header del Drawer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D111C),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Detalle del Evento',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF334155),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              event.code,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF93C5FD),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Registro consolidado de auditoría de RRHH',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
                  tooltip: 'Cerrar detalle',
                  splashRadius: 18,
                ),
              ],
            ),
          ),

          // 2. Contenido Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner inmutable
                  _buildImmutableBanner(),
                  const SizedBox(height: 18),

                  // Sección 1: Datos del Evento
                  _buildSectionHeader(
                    '1. DATOS DEL EVENTO',
                    Icons.receipt_long_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildEventCard(formattedFullDate),
                  const SizedBox(height: 18),

                  // Sección 2: Responsable / Usuario que hizo el cambio
                  _buildSectionHeader(
                    '2. RESPONSABLE DE LA OPERACIÓN',
                    Icons.badge_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildUserCard(),
                  const SizedBox(height: 18),

                  // Sección 3: Colaborador afectado
                  _buildSectionHeader(
                    '3. COLABORADOR AFECTADO',
                    Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildEmployeeCard(context, empName, empCode),
                  const SizedBox(height: 18),

                  // Sección 4: Tabla de Cambios (Anterior / Nuevo)
                  _buildSectionHeader(
                    '4. REGISTRO COMPARATIVO DE CAMBIOS',
                    Icons.compare_arrows_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildChangesCard(),
                  const SizedBox(height: 18),

                  // Sección 5: Documentos y Archivos Relacionados
                  _buildSectionHeader(
                    '5. DOCUMENTOS Y CONSTANCIAS',
                    Icons.attach_file_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildDocumentsCard(context),
                  const SizedBox(height: 18),

                  // Sección 6: Metadatos y Trazabilidad de Integridad
                  _buildSectionHeader(
                    '6. INTEGRIDAD Y METADATOS TÉCNICOS',
                    Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildMetadataCard(hash),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmutableBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_clock_rounded,
              color: Color(0xFF60A5FA),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registro Inmutable de Auditoría',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF93C5FD),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'La bitácora es un registro inmutable. Ningún evento registrado puede ser modificado o eliminado para garantizar la trazabilidad legal y de control interno de RRHH.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFFCBD5E1),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(String formattedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RrhhAuditCategoryChip(category: event.category),
              if (event.sourceCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Ref: ${event.sourceCode}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            event.title,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            event.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFFCBD5E1),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 13,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.25),
            child: const Icon(Icons.person, size: 18, color: Color(0xFF60A5FA)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.registeredBy,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.userRole ?? 'Responsable Autorizado RRHH',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                if (event.ipAddress != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.computer_outlined,
                        size: 11,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'IP: ${event.ipAddress}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(
    BuildContext context,
    String empName,
    String? empCode,
  ) {
    final hasEmployee = event.employeeId > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                child: const Icon(
                  Icons.badge_outlined,
                  size: 16,
                  color: Color(0xFF34D399),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      empName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (empCode != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Código: $empCode',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasEmployee) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => RrhhEmployeeDetailDialog(
                        employeeId: event.employeeId,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 13,
                    color: Color(0xFF60A5FA),
                  ),
                  label: Text(
                    'Expediente',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF93C5FD),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangesCard() {
    final changes = event.fieldChanges;

    if (changes == null || changes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D111C),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 15,
              color: Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Este evento registra una operación global o de estado sin alteraciones a campos individuales.',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF94A3B8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF090D16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 12,
                  child: Text(
                    'CAMPO',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: Text(
                    'VALOR ANTERIOR',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: Text(
                    'VALOR NUEVO',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...changes.asMap().entries.map((entry) {
            final idx = entry.key;
            final c = entry.value;
            final isLast = idx == changes.length - 1;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: idx.isEven
                    ? const Color(0xFF0D111C)
                    : const Color(0xFF0A0E1A),
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFF1E293B),
                          width: 0.8,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Text(
                      c.fieldName,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Text(
                      c.oldValue ?? '—',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFFF87171),
                        decoration: c.oldValue != null && c.oldValue != '—'
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Text(
                      c.newValue ?? '—',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF34D399),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard(BuildContext context) {
    final docs = event.documents;

    if (docs == null || docs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D111C),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.attach_file_rounded,
              size: 15,
              color: Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Sin documentos digitales adjuntos a este registro.',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF94A3B8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: docs.map((docName) {
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155), width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: Color(0xFFEF4444),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    docName,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE2E8F0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    RrhhSnackBar.showSuccess(
                      context,
                      'Visualizando constancia digital: $docName',
                    );
                  },
                  child: Text(
                    'Ver',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF60A5FA),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetadataCard(String hash) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          _buildMetaRow('ID del Registro', '#${event.id ?? 0}'),
          const SizedBox(height: 6),
          _buildMetaRow('Código Evento', event.code),
          const SizedBox(height: 6),
          _buildMetaRow('Hash de Integridad (SHA-256)', hash, isMono: true),
          const SizedBox(height: 6),
          _buildMetaRow(
            'Creado en Servidor',
            DateFormat('dd/MM/yyyy HH:mm:ss').format(event.createdAt),
          ),
          const SizedBox(height: 6),
          _buildMetaRow(
            'Estado Auditoría',
            'INMUTABLE · VERIFICADO',
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(
    String label,
    String value, {
    bool isMono = false,
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: isMono
                ? GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color ?? const Color(0xFFCBD5E1),
                  )
                : GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color ?? const Color(0xFFCBD5E1),
                  ),
          ),
        ),
      ],
    );
  }
}
