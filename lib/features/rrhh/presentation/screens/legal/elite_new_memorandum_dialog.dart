import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_searchable_select.dart';

/// Modal para registrar y emitir un nuevo Memorándum Disciplinario.
class EliteNewMemorandumDialog extends ConsumerStatefulWidget {
  const EliteNewMemorandumDialog({super.key});

  @override
  ConsumerState<EliteNewMemorandumDialog> createState() =>
      _EliteNewMemorandumDialogState();
}

class _EliteNewMemorandumDialogState
    extends ConsumerState<EliteNewMemorandumDialog> {
  final _formKey = GlobalKey<FormState>();
  EliteEmployee? _selectedEmployee;
  DisciplinarySeverity _selectedSeverity = DisciplinarySeverity.grave;
  DateTime _selectedDate = DateTime.now();

  final _infractionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sanctionController = TextEditingController();

  final List<String> _infractionSuggestions = const [
    'Abandono de puesto sin relevo',
    'Marcación fuera de perímetro GPS',
    'Falta injustificada reiterada',
    'Atrasos reiterados en jornada',
    'Incumplimiento de normas de seguridad (EPP)',
    'Negligencia en custodia de bienes de cliente',
    'Falta de uniforme reglamentario en servicio',
    'Insubordinación o desacato a jefatura directa',
  ];

  @override
  void dispose() {
    _infractionController.dispose();
    _descriptionController.dispose();
    _sanctionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          content: Text(
            'Por favor seleccione un colaborador de la lista.',
            style: GoogleFonts.inter(fontSize: 12),
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final emp = _selectedEmployee!;
    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');
    final memoCode = 'MEMO-2026-${(now.millisecond % 50 + 18).toString().padLeft(3, '0')}';

    final newRecord = EliteDisciplinaryRecord(
      id: 'DISC-2026-$randomSuffix',
      employeeId: emp.id,
      employeeName: emp.fullName,
      serviceLineCode: emp.serviceLineCode,
      workplaceType: emp.workplaceType,
      date: _selectedDate,
      severity: _selectedSeverity,
      infractionType: _infractionController.text.trim(),
      description: _descriptionController.text.trim(),
      memorandumCode: memoCode,
      sanction: _sanctionController.text.trim(),
    );

    ref.read(rrhhDisciplinaryProvider.notifier).addRecord(newRecord);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0D9488),
        content: Text(
          'Memorándum $memoCode emitido exitosamente para ${emp.fullName}.',
          style: GoogleFonts.inter(fontSize: 12.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(rrhhEmployeesProvider);

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
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
                        border: Border.all(color: const Color(0xFF99F6E4)),
                      ),
                      child: const Icon(
                        Icons.post_add_outlined,
                        size: 18,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EMITIR NUEVO MEMORÁNDUM',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Elite Multiservicios S.R.L. • Régimen Laboral Interno',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 18),
                      color: const Color(0xFF64748B),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Form Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Selector de Colaborador (Exclusivamente EliteSearchableSelect)
                      Text(
                        'COLABORADOR INVOLUCRADO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      EliteSearchableSelect<EliteEmployee>(
                        value: _selectedEmployee,
                        items: employees,
                        placeholder: 'Buscar colaborador por nombre, CI o Centro...',
                        searchPlaceholder: 'Escriba nombre o documento...',
                        itemTitle: (emp) => emp.fullName,
                        itemSubtitle: (emp) => '${emp.ci} • ${emp.position}',
                        itemCostCenter: (emp) => emp.serviceLineCode,
                        onChanged: (val) {
                          setState(() {
                            _selectedEmployee = val;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      // 2. Fila: Gravedad y Fecha del Suceso
                      Row(
                        children: [
                          // Selector de Gravedad
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GRAVEDAD LEGAL',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF475569),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<DisciplinarySeverity>(
                                      value: _selectedSeverity,
                                      isExpanded: true,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(
                                              () => _selectedSeverity = val);
                                        }
                                      },
                                      items: DisciplinarySeverity.values
                                          .map((sev) {
                                        return DropdownMenuItem(
                                          value: sev,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: sev.badgeColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(sev.label),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Selector de Fecha
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FECHA DE LA FALTA',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF475569),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate: DateTime(2025, 1, 1),
                                      lastDate: DateTime(2027, 12, 31),
                                    );
                                    if (picked != null) {
                                      setState(() => _selectedDate = picked);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    height: 38,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 15,
                                          color: Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F172A),
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
                      ),

                      const SizedBox(height: 14),

                      // 3. Tipo de Infracción
                      Text(
                        'TIPO DE INFRACCIÓN / MOTIVO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _infractionController,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. Abandono de puesto sin relevo...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFF0D9488),
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Especifique la infracción';
                          }
                          return null;
                        },
                      ),

                      // Sugerencias rápidas tipo chip
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _infractionSuggestions.take(4).map((sug) {
                          return InkWell(
                            onTap: () {
                              _infractionController.text = sug;
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Text(
                                sug,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: const Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // 4. Descripción de los hechos
                      Text(
                        'RELACIÓN CIRCUNSTANCIADA DE LOS HECHOS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Describa lugar, horario, testigos e impacto operativo...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFF0D9488),
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingrese la descripción de los hechos';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // 5. Sanción Aplicada
                      Text(
                        'SANCIÓN DISCIPLINARIA APLICABLE',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _sanctionController,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Ej. Amonestación escrita / Suspensión de 1 día...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFF0D9488),
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Especifique la sanción aplicable';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Footer Actions
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
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
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 0),
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
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check, size: 15),
                      label: Text(
                        'Emitir y Notificar Memo',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        minimumSize: const Size(0, 32),
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
  }
}
