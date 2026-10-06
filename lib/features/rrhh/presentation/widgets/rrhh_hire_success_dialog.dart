import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_snack_bar.dart';

/// Modal de éxito mostrado al formalizar la contratación y generar el expediente.
class RrhhHireSuccessDialog extends StatelessWidget {
  final RrhhEmployee employee;
  final VoidCallback? onFinished;

  const RrhhHireSuccessDialog({
    super.key,
    required this.employee,
    this.onFinished,
  });

  static Future<void> show(
    BuildContext context, {
    required RrhhEmployee employee,
    VoidCallback? onFinished,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhHireSuccessDialog(
        employee: employee,
        onFinished: onFinished,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corporateEmail =
        (employee.corporateEmail != null &&
            employee.corporateEmail!.trim().isNotEmpty)
        ? employee.corporateEmail!.trim()
        : 'Pendiente de generación';
    final isCampo = employee.employeeType == 'CAMPO';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera con icono esmeralda de éxito
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Expediente Creado Exitosamente!',
                          style: GoogleFonts.inter(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF8FAFC),
                          ),
                        ),
                        Text(
                          isCampo
                              ? 'Colaborador de Campo ingresado a nómina operativa'
                              : 'Colaborador Administrativo ingresado a nómina',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFF1E293B)),
              const SizedBox(height: 18),

              // Resumen del nuevo colaborador
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CÓDIGO INSTITUCIONAL',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.6,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            employee.code,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF60A5FA),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      employee.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${employee.position}  •  ${employee.area} (${employee.employeeType})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Identificador y Correo Institucional
              _buildSectionTitle('CUENTA INSTITUCIONAL ASIGNADA'),
              const SizedBox(height: 8),

              // Usuario / Email
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.alternate_email,
                      size: 16,
                      color: Color(0xFF60A5FA),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correo Corporativo',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            corporateEmail,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF8FAFC),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (employee.corporateEmail != null &&
                        employee.corporateEmail!.trim().isNotEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.copy_outlined,
                          size: 16,
                          color: Color(0xFF94A3B8),
                        ),
                        tooltip: 'Copiar correo',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: employee.corporateEmail!),
                          );
                          RrhhSnackBar.showSuccess(
                            context,
                            'Correo copiado al portapapeles',
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Acciones del modal de éxito
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onFinished?.call();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF94A3B8),
                    ),
                    child: Text(
                      'Volver al Directorio',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onFinished?.call();
                      if (employee.id != null) {
                        RrhhEmployeeDetailDialog.show(context, employee.id!);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.folder_shared_outlined, size: 16),
                    label: Text(
                      'Ir al Expediente',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }
}
