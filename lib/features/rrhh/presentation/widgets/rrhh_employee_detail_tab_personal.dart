import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_employee_detail_field.dart';

/// Tab 1: Datos Personales y Organizacionales del Colaborador.
/// Muestra datos biográficos y de contacto protegidos con candado 🔒.
class RrhhEmployeeDetailTabPersonal extends StatelessWidget {
  final RrhhEmployee employee;

  const RrhhEmployeeDetailTabPersonal({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(employee.birthDate);
    final birthDateStr = employee.birthDate != null
        ? '${_formatDate(employee.birthDate!)} ($age años)'
        : 'No especificada';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('IDENTIDAD & CONTACTO CONFIDENCIAL'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Cédula de Identidad',
                      value: employee.identityCard,
                      icon: Icons.badge_outlined,
                      isSensitive: true,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Nacimiento & Edad',
                      value: birthDateStr,
                      icon: Icons.cake_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Lugar de Nacimiento',
                      value: employee.birthPlace,
                      icon: Icons.place_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Teléfono Móvil',
                      value: employee.phone,
                      icon: Icons.phone_android_outlined,
                      isSensitive: true,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Dirección Domiciliaria',
                      value: employee.address,
                      icon: Icons.home_outlined,
                      isSensitive: true,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Contacto de Emergencia / Ref.',
                      value: employee.personalReference,
                      icon: Icons.family_restroom_outlined,
                      isSensitive: true,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Teléfono de Referencia',
                      value: employee.referencePhone,
                      icon: Icons.contact_phone_outlined,
                      isSensitive: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),

          _buildSectionHeader('ESTRUCTURA ORGANIZACIONAL & FECHAS'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Tipo de Colaborador',
                      value: employee.employeeType,
                      icon: Icons.work_outline,
                      valueColor: employee.employeeType == 'CAMPO'
                          ? const Color(0xFF10B981)
                          : const Color(0xFF60A5FA),
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Área Corporativa',
                      value: employee.area,
                      icon: Icons.account_tree_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Puesto / Cargo',
                      value: employee.position,
                      icon: Icons.assignment_ind_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Especialidad Operativa',
                      value: employee.specialty,
                      icon: Icons.military_tech_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Supervisor Directo',
                      value: employee.supervisor,
                      icon: Icons.supervisor_account_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Centro / Base Asignada',
                      value: employee.workplace,
                      icon: Icons.business_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Fecha de Ingreso Real',
                      value: _formatDate(employee.realStartDate),
                      icon: Icons.event_available_outlined,
                      valueColor: const Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Alta Fiscal (Min. Trabajo OIT)',
                      value: _formatDate(employee.fiscalStartDate),
                      icon: Icons.verified_user_outlined,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
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
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  int _calculateAge(DateTime? birth) {
    if (birth == null) return 0;
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }
}
