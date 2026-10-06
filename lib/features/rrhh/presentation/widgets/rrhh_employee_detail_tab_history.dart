import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab 5: Línea de Tiempo e Historial de Eventos del Colaborador.
/// Muestra ascensos, contratos, modificaciones de horario y novedades en orden cronológico inverso,
/// con soporte expandible para detalles de cambios contractuales y modificaciones de ficha.
class RrhhEmployeeDetailTabHistory extends StatefulWidget {
  final List<RrhhTimelineEvent> events;

  const RrhhEmployeeDetailTabHistory({
    super.key,
    required this.events,
  });

  @override
  State<RrhhEmployeeDetailTabHistory> createState() =>
      _RrhhEmployeeDetailTabHistoryState();
}

class _RrhhEmployeeDetailTabHistoryState
    extends State<RrhhEmployeeDetailTabHistory> {
  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.history_toggle_off_outlined,
                size: 36,
                color: Color(0xFF64748B),
              ),
              const SizedBox(height: 10),
              Text(
                'Sin eventos registrados en la bitácora',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: const Color(0xFFCBD5E1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Las altas, modificaciones de contrato e incidencias se registrarán aquí.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Ordenar cronológicamente descendente (más reciente arriba por timestamp completo)
    final sorted = List<RrhhTimelineEvent>.from(widget.events)
      ..sort((a, b) {
        final cmp = b.createdAt.compareTo(a.createdAt);
        if (cmp != 0) return cmp;
        return b.date.compareTo(a.date);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'LÍNEA DE TIEMPO CRONOLÓGICA (${sorted.length} EVENTOS)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...sorted.asMap().entries.map((entry) {
            final idx = entry.key;
            final ev = entry.value;
            final isLast = idx == sorted.length - 1;

            return _buildTimelineItem(ev, idx, isLast: isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    RrhhTimelineEvent ev,
    int index, {
    required bool isLast,
  }) {
    final (catColor, catLabel) = _getCategoryStyle(ev.category);
    final isContractual =
        ev.category.toUpperCase() == 'CONTRATUAL' ||
        ev.category.toUpperCase() == 'CONTRATO';
    final hasDetailedLines = ev.description.contains('\n');
    final isExpanded = _expandedIndices.contains(index);

    // Separar primera línea de resumen de los detalles subsecuentes
    final lines = ev.description.split('\n');
    final firstLine = lines.first;
    final detailLines = lines.length > 1 ? lines.sublist(1).join('\n') : '';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna del nodo y línea vertical
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: catColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: catColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF1E293B),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Tarjeta del evento
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isContractual
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
                      : const Color(0xFF1E293B),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Categoría
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          catLabel,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: catColor,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(ev.date),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ev.title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstLine,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                      height: 1.35,
                    ),
                  ),

                  // Si tiene detalles adicionales, ofrecemos expandir/colapsar
                  if (hasDetailedLines) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedIndices.remove(index);
                          } else {
                            _expandedIndices.add(index);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 16,
                              color: const Color(0xFF38BDF8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isExpanded
                                  ? 'Ocultar detalles'
                                  : 'Ver detalles de modificaciones',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Text(
                          detailLines,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: const Color(0xFFCBD5E1),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ],

                  if (ev.registeredBy.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 12,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Registrado por: ${ev.registeredBy}',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'FICHA':
      case 'DATOS_PERSONALES':
        return (const Color(0xFF10B981), 'FICHA ACTUALIZADA');
      case 'CONTRATUAL':
      case 'CAMBIO_CONTRACTUAL':
        return (const Color(0xFFF59E0B), 'CAMBIO CONTRACTUAL');
      case 'CONTRATACION':
        return (const Color(0xFF10B981), 'CONTRATACIÓN');
      case 'HORARIO':
      case 'SALARIO':
        return (const Color(0xFF2563EB), 'CONTRATO');
      case 'INCIDENCIA':
      case 'DISCIPLINA':
        return (const Color(0xFFEF4444), 'DISCIPLINA');
      case 'VACACION':
      case 'PERMISO':
        return (const Color(0xFFF59E0B), 'NOVEDAD');
      case 'ASIGNACION':
        return (const Color(0xFF8B5CF6), 'ASIGNACIÓN');
      default:
        return (const Color(0xFF64748B), category.replaceAll('_', ' '));
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
