import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_searchable_select.dart';

/// Modal para registrar una nueva solicitud de permiso, baja médica o licencia.
class EliteLeaveRequestDialog extends ConsumerStatefulWidget {
  const EliteLeaveRequestDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const EliteLeaveRequestDialog(),
    );
  }

  @override
  ConsumerState<EliteLeaveRequestDialog> createState() =>
      _EliteLeaveRequestDialogState();
}

class _EliteLeaveRequestDialogState
    extends ConsumerState<EliteLeaveRequestDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEmployeeId;
  LeaveType _selectedLeaveType = LeaveType.bajaMedica;
  LeavePaymentStatus _paymentStatus = LeavePaymentStatus.conGoce;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _calculatedDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff >= 0 ? diff + 1 : 1;
  }

  Future<void> _pickDateRange() async {
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFDC2626),
          content: Text('Seleccione un colaborador obligatorio.'),
        ),
      );
      return;
    }

    final employees = ref.read(rrhhEmployeesProvider);
    final emp = employees.firstWhere((e) => e.id == _selectedEmployeeId);

    final newRequest = EliteLeaveRequest(
      id: 'LIC-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      serviceLineCode: emp.serviceLineCode,
      workplaceType: emp.workplaceType,
      leaveType: _selectedLeaveType,
      startDate: _startDate,
      endDate: _endDate,
      totalDays: _calculatedDays,
      reason: _reasonController.text.trim(),
      paymentStatus: _paymentStatus,
      status: LeaveRequestStatus.pendiente,
      source: emp.isOffice ? 'Portal Oficina' : 'APK Móvil Campo',
    );

    ref.read(rrhhLeaveRequestsProvider.notifier).addRequest(newRequest);

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
                'Solicitud registrada para ${emp.fullName} (${_selectedLeaveType.label} • $_calculatedDays días).',
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
    final employees = ref.watch(rrhhEmployeesProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
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
                      Icons.post_add_outlined,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva Solicitud de Permiso / Baja',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Registro conforme a la Ley General del Trabajo',
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

            // Formulario Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colaborador
                    Text(
                      'COLABORADOR',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    EliteSearchableSelect<EliteEmployee>(
                      value: _selectedEmployeeId != null
                          ? employees.where((e) => e.id == _selectedEmployeeId).firstOrNull
                          : null,
                      items: employees,
                      placeholder: 'Seleccione el colaborador...',
                      itemTitle: (emp) => emp.fullName,
                      itemSubtitle: (emp) => emp.position,
                      itemCostCenter: (emp) => emp.serviceLineCode,
                      itemId: (emp) => emp.ci,
                      filterFn: (emp, query) =>
                          emp.fullName.toLowerCase().contains(query) ||
                          emp.ci.toLowerCase().contains(query) ||
                          emp.serviceLineCode.toLowerCase().contains(query) ||
                          emp.position.toLowerCase().contains(query),
                      onChanged: (emp) => setState(() => _selectedEmployeeId = emp?.id),
                    ),
                    const SizedBox(height: 14),

                    // Tipo de Permiso y Condición de Pago
                    Row(
                      children: [
                        // Tipo de Permiso
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TIPO DE PERMISO / BAJA',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF475569),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<LeaveType>(
                                initialValue: _selectedLeaveType,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                                items: LeaveType.values.map((lt) {
                                  return DropdownMenuItem(
                                    value: lt,
                                    child: Text(
                                      lt.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: lt.badgeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedLeaveType = val;
                                      // Regla de negocio: Baja médica y duelo normalmente con goce
                                      if (val == LeaveType.bajaMedica ||
                                          val == LeaveType.duelo ||
                                          val == LeaveType.matrimonio) {
                                        _paymentStatus = LeavePaymentStatus.conGoce;
                                      } else {
                                        _paymentStatus = LeavePaymentStatus.sinGoce;
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Condición Salarial
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CONDICIÓN SALARIAL',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF475569),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<LeavePaymentStatus>(
                                initialValue: _paymentStatus,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                                items: LeavePaymentStatus.values.map((ps) {
                                  return DropdownMenuItem(
                                    value: ps,
                                    child: Text(
                                      ps.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ps.badgeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _paymentStatus = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Rango de Fechas
                    Text(
                      'VIGENCIA DEL PERMISO',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickDateRange,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_outlined,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${dateFormat.format(_startDate)}  al  ${dateFormat.format(_endDate)}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$_calculatedDays días',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D9488),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Motivo
                    Text(
                      'MOTIVO O DIAGNÓSTICO',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 2,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Ingrese el motivo de la solicitud.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText:
                            'Ej: Reposo médico otorgado por la CNS, asunto legal, etc...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF94A3B8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer de Acciones (~48px)
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
                    onPressed: _submit,
                    icon: const Icon(Icons.check, size: 14, color: Colors.white),
                    label: Text(
                      'Crear Solicitud',
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
}
