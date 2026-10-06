import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_hire_form_state.dart';
import 'rrhh_hire_ui_helpers.dart';

/// Paso 2 del Wizard: Contrato, Modalidad de Pago y Sueldo (Adaptativo Opción C).
class RrhhHireStepContract extends StatefulWidget {
  final RrhhHireFormState formState;
  final VoidCallback onChanged;

  const RrhhHireStepContract({
    super.key,
    required this.formState,
    required this.onChanged,
  });

  @override
  State<RrhhHireStepContract> createState() => _RrhhHireStepContractState();
}

class _RrhhHireStepContractState extends State<RrhhHireStepContract> {
  late final TextEditingController _salaryController;
  late final TextEditingController _obsController;

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController(
      text: widget.formState.agreedSalary > 0
          ? widget.formState.agreedSalary.toStringAsFixed(2)
          : '',
    );
    _obsController = TextEditingController(text: widget.formState.observations);
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.formState;
    final cfg = form.config;
    final isCampo = cfg.type == 'CAMPO';

    final contractItems = cfg.contractTypeOptions.map((opt) {
      String label = opt;
      if (opt == 'Plazo Fijo') label = 'A Plazo Fijo (1 año o determinado)';
      if (opt == 'Indefinido') label = 'A Plazo Indefinido';
      if (opt == 'Servicios') label = 'Por Servicios / Consultoría';
      return DropdownMenuItem(
        value: opt,
        child: Text(label, overflow: TextOverflow.ellipsis),
      );
    }).toList();

    final paymentItems = cfg.paymentModalityOptions.map((opt) {
      String label = opt;
      if (opt == 'JORNAL') label = 'Jornal Diario';
      if (opt == 'POR_HORAS') label = 'Por Horas Efectivas';
      if (opt == 'MENSUAL') label = 'Mensual (Planilla Oficial)';
      return DropdownMenuItem(
        value: opt,
        child: Text(label, overflow: TextOverflow.ellipsis),
      );
    }).toList();

    final scheduleItems = cfg.scheduleOptions.map((opt) {
      return DropdownMenuItem(
        value: opt['value']!,
        child: Text(opt['label']!, overflow: TextOverflow.ellipsis),
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner informativo adaptativo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isCampo
                        ? 'Configuración para Personal de Campo: Contratación por defecto a Plazo Fijo con liquidación de jornal operativo.'
                        : 'Configuración para Personal de Oficina: Contratación por defecto a Plazo Indefinido con liquidación mensual estándar.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF93C5FD),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          buildHireSectionHeader(
            'TÉRMINOS DEL CONTRATO (${cfg.roleBadgeText.toUpperCase()})',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 14) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  // Tipo de Contrato
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<String>(
                      label: 'Tipo de Contrato *',
                      value: form.contractType,
                      items: contractItems,
                      icon: Icons.history_edu_outlined,
                      onChanged: (val) {
                        if (val != null) {
                          form.contractType = val;
                          if (val == 'Plazo Fijo' &&
                              form.contractEndDate == null) {
                            form.contractEndDate = form.realStartDate.add(
                              const Duration(days: 365),
                            );
                          } else if (val != 'Plazo Fijo') {
                            form.contractEndDate = null;
                          }
                          widget.onChanged();
                          setState(() {});
                        }
                      },
                    ),
                  ),

                  // Fecha Fin de Contrato o Etiqueta "Sin Vencimiento"
                  if (form.contractType == 'Plazo Fijo')
                    SizedBox(
                      width: colWidth,
                      child: buildHireDatePickerField(
                        context: context,
                        label: 'Fecha Vencimiento Contrato *',
                        currentDate:
                            form.contractEndDate ??
                            form.realStartDate.add(const Duration(days: 365)),
                        icon: Icons.event_busy_outlined,
                        onDateSelected: (date) {
                          form.contractEndDate = date;
                          widget.onChanged();
                          setState(() {});
                        },
                      ),
                    )
                  else
                    SizedBox(
                      width: colWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vencimiento Contractual',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.all_inclusive,
                                  size: 16,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Sin vencimiento (Contrato Indefinido)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: const Color(0xFF10B981),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Modalidad de Pago
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<String>(
                      label: 'Modalidad de Pago *',
                      value: form.paymentModality,
                      items: paymentItems,
                      icon: Icons.payments_outlined,
                      onChanged: (val) {
                        if (val != null) {
                          form.paymentModality = val;
                          widget.onChanged();
                        }
                      },
                    ),
                  ),

                  // Jornada Base
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<String>(
                      label: 'Jornada Base Laboral *',
                      value: form.workScheduleType,
                      items: scheduleItems,
                      icon: Icons.schedule_outlined,
                      onChanged: (val) {
                        if (val != null) {
                          form.workScheduleType = val;
                          widget.onChanged();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          buildHireSectionHeader('REMUNERACIÓN PACTADA (CONFIDENCIAL)'),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Sueldo Base Acordado (Bs.) *',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.lock_outline,
                size: 12,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 4),
              Text(
                'Confidencial',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _salaryController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF10B981),
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val) ?? 0.0;
              form.agreedSalary = parsed;
              widget.onChanged();
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.monetization_on_outlined,
                size: 16,
                color: Color(0xFF10B981),
              ),
              prefixText: 'Bs. ',
              prefixStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF10B981),
              ),
              helperText:
                  form.selectedPosition?.suggestedSalary != null &&
                      (form.selectedPosition!.suggestedSalary ?? 0) > 0
                  ? 'Sueldo referencial para ${form.selectedPosition!.name}: Bs. ${form.selectedPosition!.suggestedSalary!.toStringAsFixed(2)}'
                  : null,
              helperStyle: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
              filled: true,
              fillColor: const Color(0xFF111827),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF10B981)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          buildHireSectionHeader('OBSERVACIONES CONTRACTUALES (OPCIONAL)'),
          const SizedBox(height: 8),
          TextField(
            controller: _obsController,
            maxLines: 2,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFFF8FAFC),
            ),
            onChanged: (val) {
              form.observations = val;
              widget.onChanged();
            },
            decoration: InputDecoration(
              hintText:
                  'Condiciones especiales, bonos de campo, acuerdos de traslado...',
              hintStyle: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
              filled: true,
              fillColor: const Color(0xFF111827),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
