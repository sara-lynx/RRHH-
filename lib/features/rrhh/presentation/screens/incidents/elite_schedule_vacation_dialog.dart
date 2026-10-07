import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Modal para programar vacaciones según la Ley General del Trabajo.
class EliteScheduleVacationDialog extends ConsumerStatefulWidget {
  final EliteVacationRecord vacationRecord;

  const EliteScheduleVacationDialog({
    super.key,
    required this.vacationRecord,
  });

  static Future<void> show(
    BuildContext context,
    EliteVacationRecord vacationRecord,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          EliteScheduleVacationDialog(vacationRecord: vacationRecord),
    );
  }

  @override
  ConsumerState<EliteScheduleVacationDialog> createState() =>
      _EliteScheduleVacationDialogState();
}

class _EliteScheduleVacationDialogState
    extends ConsumerState<EliteScheduleVacationDialog> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));

  int get _requestedDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff >= 0 ? diff + 1 : 1;
  }

  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submit() {
    final available = widget.vacationRecord.daysRemaining;
    if (_requestedDays > available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          content: Text(
            'El período solicitado ($_requestedDays días) excede el saldo legal disponible ($available días).',
          ),
        ),
      );
      return;
    }

    ref.read(rrhhVacationsProvider.notifier).scheduleVacation(
          widget.vacationRecord.employeeId,
          _startDate,
          _endDate,
          _requestedDays,
        );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vacaciones programadas para ${widget.vacationRecord.employeeName} ($_requestedDays días). Saldo actualizado: ${available - _requestedDays} días.',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rec = widget.vacationRecord;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isExceeded = _requestedDays > rec.daysRemaining;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del Modal (~44px)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    child: const Icon(
                      Icons.beach_access_outlined,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programar Período de Vacación',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Cálculo automático de saldo según Ley General del Trabajo',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 16,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: const Color(0xFF64748B),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Contenido Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta Resumen del Colaborador
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rec.employeeName,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                rec.serviceLineCode,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${rec.employeeJobTitle} • Antigüedad: ${rec.yearsOfService} años (Ingreso: ${dateFormat.format(rec.hireDate)})',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildKpiMini('Días de Ley', '${rec.legalDaysTotal}d'),
                            const SizedBox(width: 10),
                            _buildKpiMini('Consumidos', '${rec.daysUsed}d'),
                            const SizedBox(width: 10),
                            _buildKpiMini(
                              'Disponible',
                              '${rec.daysRemaining}d',
                              highlight: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selector de Fechas
                  Text(
                    'PERÍODO SOLICITADO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickDates,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isExceeded
                              ? const Color(0xFFDC2626)
                              : const Color(0xFFCBD5E1),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${dateFormat.format(_startDate)}  al  ${dateFormat.format(_endDate)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isExceeded
                                  ? const Color(0xFFFEF2F2)
                                  : const Color(0xFFF0FDFA),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isExceeded
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFCCFBF1),
                              ),
                            ),
                            child: Text(
                              '$_requestedDays días solicitados',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isExceeded
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFF0D9488),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExceeded) ...[
                    const SizedBox(height: 6),
                    Text(
                      'No dispone de saldo suficiente para cubrir este rango.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Footer (~48px)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: isExceeded ? null : _submit,
                    icon: const Icon(Icons.check, size: 14, color: Colors.white),
                    label: Text(
                      'Confirmar Programación',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiMini(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: highlight
                ? const Color(0xFFCCFBF1)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: highlight
                    ? const Color(0xFF0F766E)
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
