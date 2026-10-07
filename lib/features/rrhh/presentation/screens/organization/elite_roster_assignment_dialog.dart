import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_searchable_select.dart';

/// Modal para asignación o rotación de colaborador en un puesto / turno.
class EliteRosterAssignmentDialog extends ConsumerStatefulWidget {
  final EliteRosterAssignment? existingAssignment;

  const EliteRosterAssignmentDialog({
    super.key,
    this.existingAssignment,
  });

  static Future<void> show(
    BuildContext context, {
    EliteRosterAssignment? existingAssignment,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EliteRosterAssignmentDialog(
        existingAssignment: existingAssignment,
      ),
    );
  }

  @override
  ConsumerState<EliteRosterAssignmentDialog> createState() =>
      _EliteRosterAssignmentDialogState();
}

class _EliteRosterAssignmentDialogState
    extends ConsumerState<EliteRosterAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEmployeeId;
  String? _selectedSiteId;
  String? _selectedShiftId;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingAssignment;
    if (existing != null) {
      _selectedEmployeeId = existing.employeeId;
      _selectedSiteId = existing.siteId;
      _selectedShiftId = existing.shiftId;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployeeId == null ||
        _selectedSiteId == null ||
        _selectedShiftId == null) {
      return;
    }

    final employees = ref.read(rrhhEmployeesProvider);
    final sites = ref.read(rrhhClientSitesProvider);
    final shifts = ref.read(rrhhShiftsProvider);

    final emp = employees.firstWhere((e) => e.id == _selectedEmployeeId);
    final site = sites.firstWhere((s) => s.id == _selectedSiteId);
    final shift = shifts.firstWhere((s) => s.id == _selectedShiftId);

    if (widget.existingAssignment != null) {
      // Reasignación o rotación
      ref.read(rrhhRosterProvider.notifier).rotateEmployee(
            widget.existingAssignment!.id,
            site.id,
            site.name,
          );
      ref.read(rrhhRosterProvider.notifier).reassignShift(
            widget.existingAssignment!.id,
            shift.id,
            shift.name,
            shift.formattedSchedule,
          );
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF0D9488),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text(
            'Colaborador ${emp.fullName} rotado exitosamente a ${site.name}.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
          ),
        ),
      );
    } else {
      // Nueva asignación
      final count = ref.read(rrhhRosterProvider).length;
      final assignment = EliteRosterAssignment(
        id: 'ROST-${(count + 1).toString().padLeft(3, '0')}',
        employeeId: emp.id,
        employeeName: emp.fullName,
        serviceLineCode: emp.serviceLineCode,
        siteId: site.id,
        siteName: site.name,
        shiftId: shift.id,
        shiftName: shift.name,
        scheduleSummary: '${shift.formattedSchedule} (${shift.activeDays})',
        startDate: DateTime.now(),
      );

      ref.read(rrhhRosterProvider.notifier).addAssignment(assignment);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF0D9488),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text(
            'Puesto asignado a ${emp.fullName} en ${site.name}.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(rrhhEmployeesProvider);
    final sites = ref.watch(rrhhClientSitesProvider);
    final shifts = ref.watch(rrhhShiftsProvider);

    _selectedEmployeeId ??= employees.firstOrNull?.id;
    _selectedSiteId ??= sites.firstOrNull?.id;
    _selectedShiftId ??= shifts.firstOrNull?.id;

    final isEditing = widget.existingAssignment != null;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isEditing
                          ? Icons.sync_alt_outlined
                          : Icons.add_task_outlined,
                      size: 18,
                      color: const Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing
                              ? 'Rotar / Reasignar Puesto'
                              : 'Asignar Puesto en Malla',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Programación de cuadrante y cobertura de sede operativa',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colaborador
                    Text(
                      'Colaborador Asignado',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 4),
                    EliteSearchableSelect<EliteEmployee>(
                      value: _selectedEmployeeId != null
                          ? employees.where((e) => e.id == _selectedEmployeeId).firstOrNull
                          : null,
                      items: employees,
                      enabled: !isEditing,
                      placeholder: 'Seleccione un colaborador...',
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

                    // Sede / Cliente
                    Text(
                      'Sede de Cliente Asignada',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSiteId,
                      items: sites.map((st) {
                        return DropdownMenuItem(
                          value: st.id,
                          child: Text(
                            '${st.name} (${st.serviceLineCode} • Geocerca: ${st.geofenceRadiusMeters.toInt()}m)',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSiteId = val),
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 14),

                    // Turno
                    Text(
                      'Turno Programado',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedShiftId,
                      items: shifts.map((sh) {
                        return DropdownMenuItem(
                          value: sh.id,
                          child: Text(
                            '${sh.name} (${sh.formattedSchedule} • ${sh.activeDays})',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedShiftId = val),
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: _inputDecoration(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(
                      isEditing ? 'Confirmar Rotación' : 'Asignar Puesto',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
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
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
      ),
    );
  }
}
