import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_vacation_balance_chip.dart';

/// Modal para programar o editar un período de vacaciones (Pantalla 09).
class RrhhVacationEditDialog extends StatefulWidget {
  final RrhhVacationRecord? initialRecord;
  final int? preselectedEmployeeId;

  const RrhhVacationEditDialog({
    super.key,
    this.initialRecord,
    this.preselectedEmployeeId,
  });

  static Future<bool?> show(
    BuildContext context, {
    RrhhVacationRecord? initialRecord,
    int? preselectedEmployeeId,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhVacationEditDialog(
        initialRecord: initialRecord,
        preselectedEmployeeId: preselectedEmployeeId,
      ),
    );
  }

  @override
  State<RrhhVacationEditDialog> createState() => _RrhhVacationEditDialogState();
}

class _RrhhVacationEditDialogState extends State<RrhhVacationEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  List<RrhhVacationBalance> _balances = [];
  RrhhVacationBalance? _selectedBalance;

  late DateTime _startDate;
  late DateTime _endDate;
  String _countingMode = 'habiles'; // 'habiles' | 'calendario'

  bool get _isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (_isEditing) {
      final rec = widget.initialRecord!;
      _startDate = rec.startDate;
      _endDate = rec.endDate;
      _countingMode = rec.countingMode;
      _notesController.text = rec.notes ?? '';
    } else {
      _startDate = tomorrow;
      _endDate = tomorrow.add(const Duration(days: 4));
    }

    _loadBalances();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadBalances() async {
    setState(() => _isLoading = true);
    try {
      final repo = RrhhRepository.current;
      final balances = await repo.listVacationBalances();
      if (!mounted) return;

      RrhhVacationBalance? selected;
      final targetEmpId =
          widget.initialRecord?.employeeId ?? widget.preselectedEmployeeId;

      if (targetEmpId != null) {
        final matches = balances.where((b) => b.employeeId == targetEmpId);
        if (matches.isNotEmpty) {
          selected = matches.first;
        }
      }

      // Si no hay seleccionado y tenemos empleados con saldo, preseleccionamos el primero con saldo
      if (selected == null && balances.isNotEmpty) {
        final withBalance = balances.where((b) => b.pendingDays > 0);
        selected = withBalance.isNotEmpty ? withBalance.first : balances.first;
      }

      setState(() {
        _balances = balances;
        _selectedBalance = selected;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      RrhhSnackBar.showError(
        context,
        'Error al cargar saldos de empleados: $e',
      );
    }
  }

  int get _calculatedDays {
    return RrhhVacationCalculator.countDays(
      _startDate,
      _endDate,
      countingMode: _countingMode,
    );
  }

  int get _effectiveAvailableDays {
    if (_selectedBalance == null) return 0;
    // Si estamos editando el mismo registro, sumamos de vuelta los días que ya tenía este registro
    if (_isEditing &&
        widget.initialRecord!.employeeId == _selectedBalance!.employeeId) {
      return _selectedBalance!.pendingDays + widget.initialRecord!.daysCounted;
    }
    return _selectedBalance!.pendingDays;
  }

  bool get _isStartDateToday {
    final now = DateTime.now();
    return _startDate.year == now.year &&
        _startDate.month == now.month &&
        _startDate.day == now.day;
  }

  Future<void> _handleSave({required bool markInCourse}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBalance == null) {
      RrhhSnackBar.showWarning(context, 'Selecciona un colaborador.');
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      RrhhSnackBar.showError(
        context,
        'La fecha de fin no puede ser anterior a la fecha de inicio.',
      );
      return;
    }

    final days = _calculatedDays;
    if (days <= 0) {
      RrhhSnackBar.showError(
        context,
        'El período seleccionado debe contener al menos 1 día válido.',
      );
      return;
    }

    // Regla: No tener menos de 1 año de antigüedad
    if (_selectedBalance!.balanceStatus ==
        RrhhVacationBalanceStatus.sinDerecho) {
      RrhhSnackBar.showError(
        context,
        'El colaborador aún no cumple 1 año ininterrumpido de servicio (sin derecho legal de vacaciones).',
      );
      return;
    }

    // Regla: No exceder saldo disponible
    if (days > _effectiveAvailableDays) {
      RrhhSnackBar.showError(
        context,
        'Excede el saldo disponible ($_effectiveAvailableDays días disponibles, solicitados: $days).',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = RrhhRepository.current;
      final now = DateTime.now();

      // Validar solapamiento con otros goces activos
      final existingRecords = await repo.listVacationRecords(
        employeeId: _selectedBalance!.employeeId,
      );
      final hasOverlap = existingRecords.any((r) {
        if (_isEditing && r.id == widget.initialRecord!.id) return false;
        if (r.status == RrhhVacationRecordStatus.cancelado) return false;
        final overlaps =
            !(_endDate.isBefore(r.startDate) || _startDate.isAfter(r.endDate));
        return overlaps;
      });

      if (hasOverlap) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        RrhhSnackBar.showError(
          context,
          'Las fechas seleccionadas se solapan con otro período de vacación programado o en curso para este colaborador.',
        );
        return;
      }

      final status = markInCourse
          ? RrhhVacationRecordStatus.enCurso
          : (_isEditing
                ? widget.initialRecord!.status
                : RrhhVacationRecordStatus.programado);

      final record = RrhhVacationRecord(
        id: _isEditing ? widget.initialRecord!.id : 0,
        code: _isEditing ? widget.initialRecord!.code : '',
        employeeId: _selectedBalance!.employeeId,
        employeeCode: _selectedBalance!.employeeCode,
        employeeName: _selectedBalance!.employeeName,
        startDate: _startDate,
        endDate: _endDate,
        daysCounted: days,
        countingMode: _countingMode,
        status: status,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        createdAt: _isEditing ? widget.initialRecord!.createdAt : now,
        updatedAt: now,
        createdBy: _isEditing
            ? widget.initialRecord!.createdBy
            : 'Lic. Laura Mendoza',
      );

      if (_isEditing) {
        await repo.updateVacationRecord(record);
      } else {
        await repo.createVacationRecord(record);
      }

      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        markInCourse
            ? 'Vacaciones programadas y marcadas en curso exitosamente.'
            : (_isEditing
                  ? 'Período de vacaciones actualizado correctamente.'
                  : 'Vacaciones programadas exitosamente.'),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      RrhhSnackBar.showError(context, 'Error al guardar vacaciones: $e');
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final firstDate = DateTime(2020);
    final lastDate = DateTime(2035);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              surface: Color(0xFF0F172A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 820),
        child: _isLoading
            ? const SizedBox(
                height: 240,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildDialogHeader(),

                    // Body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Selector de Empleado
                            _buildEmployeeSelector(),
                            const SizedBox(height: 16),

                            // Card de Saldo Disponible del empleado seleccionado
                            if (_selectedBalance != null) ...[
                              _buildBalanceInfoCard(),
                              const SizedBox(height: 18),
                            ],

                            // 2. Rango de Fechas
                            _buildDatePickers(),
                            const SizedBox(height: 18),

                            // 3. Modo de cálculo (Segmented: Hábiles vs Calendario)
                            _buildCountingModeSelector(),
                            const SizedBox(height: 18),

                            // 4. Resumen de Días a gozar calculados
                            _buildDaysCalculatedPreview(),
                            const SizedBox(height: 18),

                            // 5. Notas opcionales
                            _buildNotesField(),
                          ],
                        ),
                      ),
                    ),

                    // Actions Footer
                    _buildActionsFooter(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.beach_access_outlined,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing
                            ? 'Editar Vacaciones'
                            : 'Programar Vacaciones',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Registro oficial del período de goce según Ley Laboral',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Empleado *',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              dropdownColor: const Color(0xFF0F172A),
              value: _selectedBalance?.employeeId,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF94A3B8),
              ),
              hint: Text(
                'Seleccione un colaborador...',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
              items: _balances.map((b) {
                final hasBalance =
                    b.pendingDays > 0 &&
                    b.balanceStatus != RrhhVacationBalanceStatus.sinDerecho;
                return DropdownMenuItem<int>(
                  value: b.employeeId,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${b.employeeCode} — ${b.employeeName}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: hasBalance
                                ? Colors.white
                                : const Color(0xFF94A3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${b.pendingDays} d',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: hasBalance
                              ? const Color(0xFF10B981)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _isEditing
                  ? null
                  : (val) {
                      if (val != null) {
                        setState(() {
                          _selectedBalance = _balances.firstWhere(
                            (b) => b.employeeId == val,
                          );
                        });
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceInfoCard() {
    final b = _selectedBalance!;
    final available = _effectiveAvailableDays;
    final isSinDerecho =
        b.balanceStatus == RrhhVacationBalanceStatus.sinDerecho;
    final isAgotado = available <= 0 && !isSinDerecho;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSinDerecho || isAgotado
            ? const Color(0xFFEF4444).withValues(alpha: 0.08)
            : const Color(0xFF1E293B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSinDerecho || isAgotado
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFF334155),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saldo disponible actual:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              RrhhVacationBalanceChip(status: b.balanceStatus),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '$available días hábiles disponibles',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: available > 0
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
              Text(
                '(Asignados: ${b.assignedDays}d | Gozados: ${b.usedDays}d)',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          if (isSinDerecho) ...[
            const SizedBox(height: 6),
            Text(
              '⚠️ Este colaborador no cumple 1 año ininterrumpido. No tiene derecho legal a vacaciones todavía.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFCA5A5),
              ),
            ),
          ] else if (isAgotado) ...[
            const SizedBox(height: 6),
            Text(
              '⚠️ Este colaborador no tiene saldo de vacaciones disponible en este período.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFCA5A5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePickers() {
    return Row(
      children: [
        // Fecha Inicio
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha Desde *',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickDate(isStart: true),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFF60A5FA),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _formatDate(_startDate),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Fecha Fin
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha Hasta *',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickDate(isStart: false),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event,
                        size: 16,
                        color: Color(0xFF60A5FA),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _formatDate(_endDate),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountingModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo de Cómputo de Días',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _countingMode = 'habiles'),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _countingMode == 'habiles'
                          ? const Color(0xFF2563EB)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Días Hábiles (Lunes a Viernes - Ley)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _countingMode == 'habiles'
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _countingMode = 'calendario'),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _countingMode == 'calendario'
                          ? const Color(0xFF2563EB)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Días Calendario (Continuos)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _countingMode == 'calendario'
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaysCalculatedPreview() {
    final days = _calculatedDays;
    final available = _effectiveAvailableDays;
    final isExceeded = days > available;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isExceeded
            ? const Color(0xFFEF4444).withValues(alpha: 0.1)
            : const Color(0xFF2563EB).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExceeded
              ? const Color(0xFFEF4444).withValues(alpha: 0.4)
              : const Color(0xFF2563EB).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  isExceeded ? Icons.error_outline : Icons.check_circle_outline,
                  color: isExceeded
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF38BDF8),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Días a gozar calculados:',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        '$days días (${_countingMode == 'habiles' ? 'hábiles' : 'calendario'})',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isExceeded
                              ? const Color(0xFFEF4444)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isExceeded)
            Text(
              'Excede por ${days - available} d',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            )
          else
            Text(
              'Saldo restante: ${available - days} d',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF34D399),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notas u observaciones (opcional)',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText:
                'Ej. Acordado con jefatura operativa, reemplazo asignado...',
            hintStyle: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFF64748B),
            ),
            filled: true,
            fillColor: const Color(0xFF111827),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsFooter() {
    final days = _calculatedDays;
    final available = _effectiveAvailableDays;
    final canSubmit =
        !_isSaving &&
        _selectedBalance != null &&
        _selectedBalance!.balanceStatus !=
            RrhhVacationBalanceStatus.sinDerecho &&
        days > 0 &&
        days <= available;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (!_isEditing && _isStartDateToday) ...[
            ElevatedButton(
              onPressed: canSubmit
                  ? () => _handleSave(markInCourse: true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Programar y marcar en curso',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          ElevatedButton(
            onPressed: canSubmit
                ? () => _handleSave(markInCourse: false)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isEditing ? 'Guardar Cambios' : 'Programar',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
