import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_hire_form_state.dart';
import 'rrhh_hire_ui_helpers.dart';

/// Paso 1 del Wizard: Clasificación y Datos Laborales (Adaptativo según CAMPO vs OFICINA).
class RrhhHireStepLabor extends StatefulWidget {
  final RrhhHireFormState formState;
  final List<RrhhArea> areas;
  final List<RrhhPosition> positions;
  final List<RrhhSpecialty> specialties;
  final List<RrhhSchedule> schedules;
  final List<String> availableSupervisors;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onChanged;
  final bool isDirectHire;

  const RrhhHireStepLabor({
    super.key,
    required this.formState,
    required this.areas,
    required this.positions,
    required this.specialties,
    required this.schedules,
    required this.availableSupervisors,
    required this.onTypeChanged,
    required this.onChanged,
    this.isDirectHire = false,
  });

  @override
  State<RrhhHireStepLabor> createState() => _RrhhHireStepLaborState();
}

class _RrhhHireStepLaborState extends State<RrhhHireStepLabor> {
  bool _showAdvancedSpecialty = false;

  @override
  Widget build(BuildContext context) {
    final form = widget.formState;
    final empTypeUpper = form.employeeType.trim().toUpperCase();
    final isCampo = empTypeUpper == 'CAMPO';

    // 1. Áreas que tienen posiciones del tipo elegido
    final validAreaIds = widget.positions
        .where((p) => p.workplaceType.trim().toUpperCase() == empTypeUpper)
        .map((p) => p.areaId)
        .toSet();
    final filteredAreas = widget.areas
        .where((a) => validAreaIds.contains(a.id))
        .toList();

    // 2. Cargos filtrados por tipo + área seleccionada
    final filteredPositions = widget.positions.where((p) {
      if (p.workplaceType.trim().toUpperCase() != empTypeUpper) return false;
      if (form.selectedArea != null && p.areaId != form.selectedArea!.id) {
        return false;
      }
      return true;
    }).toList();

    // 3. Turnos filtrados por targetType (CAMPO / OFICINA / AMBOS)
    final filteredSchedules = widget.schedules.where((s) {
      final sType = s.targetType.trim().toUpperCase();
      return sType == 'AMBOS' || sType == empTypeUpper;
    }).toList();

    // 4. Instancias seguras coincidentes por ID para evitar fallos de referencia
    final safeArea = filteredAreas
        .where((a) => a.id == form.selectedArea?.id)
        .firstOrNull;
    final safePosition = filteredPositions
        .where((p) => p.id == form.selectedPosition?.id)
        .firstOrNull;
    final safeSchedule = filteredSchedules
        .where((s) => s.id == form.selectedSchedule?.id)
        .firstOrNull;

    // 4. Supervisores filtrados o sugeridos
    final supervisorOptions = widget.availableSupervisors.isNotEmpty
        ? widget.availableSupervisors
        : (isCampo
              ? ['Ricardo Montaño', 'Juan Carlos Pérez']
              : ['Lic. Laura Mendoza', 'Ing. Roberto Paz']);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isDirectHire) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF59E0B),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Estás dando de alta a un colaborador sin pasar por reclutamiento. Usa esta opción solo para reingresos o altas de emergencia autorizadas.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFDE68A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          buildHireSectionHeader('CLASIFICACIÓN LABORAL'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTypeCard(
                  label: 'Personal de Campo',
                  description: 'Operativo en sedes de clientes',
                  icon: Icons.engineering_outlined,
                  isSelected: isCampo,
                  onTap: () => widget.onTypeChanged('CAMPO'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTypeCard(
                  label: 'Personal de Oficina',
                  description: 'Administrativo y soporte central',
                  icon: Icons.business_outlined,
                  isSelected: !isCampo,
                  onTap: () => widget.onTypeChanged('OFICINA'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildHireSectionHeader(
            isCampo
                ? 'ESTRUCTURA OPERATIVA (CAMPO)'
                : 'ESTRUCTURA CORPORATIVA (OFICINA)',
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
                  // Área Departamental
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<RrhhArea>(
                      label: 'Departamento / Área *',
                      value: safeArea,
                      items: filteredAreas
                          .map(
                            (a) => DropdownMenuItem(
                              value: a,
                              child: Text(
                                a.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      hint: 'Seleccionar departamento...',
                      icon: Icons.domain_outlined,
                      onChanged: (area) {
                        form.selectedArea = area;
                        if (form.selectedPosition != null &&
                            form.selectedPosition!.areaId != area?.id) {
                          form.selectedPosition = null;
                        }
                        widget.onChanged();
                      },
                    ),
                  ),

                  // Cargo Contractual
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<RrhhPosition>(
                      label: 'Cargo Contractual *',
                      value: safePosition,
                      items: filteredPositions
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(
                                p.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      hint: form.selectedArea == null
                          ? 'Primero elija un área...'
                          : 'Seleccionar cargo...',
                      icon: Icons.badge_outlined,
                      onChanged: (pos) {
                        form.selectedPosition = pos;
                        if (pos?.suggestedSalary != null &&
                            (pos!.suggestedSalary ?? 0) > 0 &&
                            form.agreedSalary == 0) {
                          form.agreedSalary = pos.suggestedSalary!;
                        }
                        widget.onChanged();
                      },
                    ),
                  ),

                  // Si es CAMPO: Especialidad obligatoria
                  if (isCampo)
                    SizedBox(
                      width: colWidth,
                      child: buildHireDropdownField<RrhhSpecialty>(
                        label: 'Especialidad Operativa *',
                        value: form.selectedSpecialty,
                        items: widget.specialties
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        hint: 'Seleccionar especialidad...',
                        icon: Icons.psychology_outlined,
                        onChanged: (s) {
                          form.selectedSpecialty = s;
                          widget.onChanged();
                        },
                      ),
                    ),

                  // Turno Convenido
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<RrhhSchedule>(
                      label: isCampo
                          ? 'Turno Base Operativo *'
                          : 'Horario Administrativo *',
                      value: safeSchedule,
                      items: filteredSchedules
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                '${s.name} (${s.startTime} - ${s.endTime})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      hint: 'Seleccionar turno...',
                      icon: Icons.schedule_outlined,
                      onChanged: (s) {
                        form.selectedSchedule = s;
                        widget.onChanged();
                      },
                    ),
                  ),

                  // Supervisor Asignado
                  SizedBox(
                    width: colWidth,
                    child: buildHireDropdownField<String>(
                      label: isCampo
                          ? 'Supervisor de Campo *'
                          : 'Supervisor Directo *',
                      value: supervisorOptions.contains(form.supervisor)
                          ? form.supervisor
                          : (supervisorOptions.isNotEmpty
                                ? supervisorOptions.first
                                : null),
                      items: supervisorOptions
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      hint: 'Seleccionar supervisor...',
                      icon: Icons.supervisor_account_outlined,
                      onChanged: (val) {
                        if (val != null) {
                          form.supervisor = val;
                          widget.onChanged();
                        }
                      },
                    ),
                  ),

                  // Fecha de Ingreso Efectiva
                  SizedBox(
                    width: colWidth,
                    child: buildHireDatePickerField(
                      context: context,
                      label: 'Fecha de Ingreso Efectiva *',
                      currentDate: form.realStartDate,
                      icon: Icons.calendar_month_outlined,
                      onDateSelected: (date) {
                        form.realStartDate = date;
                        widget.onChanged();
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          // Para OFICINA: Especialidad es opcional / colapsable
          if (!isCampo) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () => setState(
                () => _showAdvancedSpecialty = !_showAdvancedSpecialty,
              ),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _showAdvancedSpecialty
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 18,
                      color: const Color(0xFF60A5FA),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Especialidad o Sub-área — Avanzado (opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF60A5FA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showAdvancedSpecialty) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 380,
                child: buildHireDropdownField<RrhhSpecialty>(
                  label: 'Especialidad / Perfil Funcional (Opcional)',
                  value: form.selectedSpecialty,
                  items: widget.specialties
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  hint: 'Ninguna / Especialidad general...',
                  icon: Icons.psychology_outlined,
                  onChanged: (s) {
                    form.selectedSpecialty = s;
                    widget.onChanged();
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String label,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB).withValues(alpha: 0.12)
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFF1E293B),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? const Color(0xFF60A5FA)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF64748B),
                  width: isSelected ? 4.5 : 1.5,
                ),
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
