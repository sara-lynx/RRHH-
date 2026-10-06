import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

/// Modal para creación de nuevo período de nómina mensual (Pantalla 12 — Bloque 4).
class RrhhNewPayrollPeriodDialog extends StatefulWidget {
  final RrhhRepository repository;

  const RrhhNewPayrollPeriodDialog({
    super.key,
    required this.repository,
  });

  @override
  State<RrhhNewPayrollPeriodDialog> createState() =>
      _RrhhNewPayrollPeriodDialogState();
}

class _RrhhNewPayrollPeriodDialogState
    extends State<RrhhNewPayrollPeriodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _isSubmitting = false;

  static const List<Map<String, dynamic>> _months = [
    {'value': 1, 'name': '01 — Enero'},
    {'value': 2, 'name': '02 — Febrero'},
    {'value': 3, 'name': '03 — Marzo'},
    {'value': 4, 'name': '04 — Abril'},
    {'value': 5, 'name': '05 — Mayo'},
    {'value': 6, 'name': '06 — Junio'},
    {'value': 7, 'name': '07 — Julio'},
    {'value': 8, 'name': '08 — Agosto'},
    {'value': 9, 'name': '09 — Septiembre'},
    {'value': 10, 'name': '10 — Octubre'},
    {'value': 11, 'name': '11 — Noviembre'},
    {'value': 12, 'name': '12 — Diciembre'},
  ];

  static const List<int> _years = [2024, 2025, 2026, 2027];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final newPeriod = await widget.repository.createPayrollPeriod(
        _selectedYear,
        _selectedMonth,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (mounted) {
        RrhhSnackBar.showSuccess(
          context,
          'Período ${newPeriod.code} creado exitosamente con sus novedades consolidadas.',
        );
        Navigator.of(context).pop(newPeriod);
      }
    } catch (e) {
      if (mounted) {
        RrhhSnackBar.showError(
          context,
          'No se pudo crear el período: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 520,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Selector de Mes
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mes a Liquidar *',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<int>(
                                initialValue: _selectedMonth,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1E293B),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                decoration: _inputDecoration(),
                                items: _months.map((m) {
                                  return DropdownMenuItem<int>(
                                    value: m['value'] as int,
                                    child: Text(m['name'] as String),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null)
                                    setState(() => _selectedMonth = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Selector de Año
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Año Fiscal *',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<int>(
                                initialValue: _selectedYear,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1E293B),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                decoration: _inputDecoration(),
                                items: _years.map((y) {
                                  return DropdownMenuItem<int>(
                                    value: y,
                                    child: Text('$y'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null)
                                    setState(() => _selectedYear = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Notas u Observaciones
                    Text(
                      'Notas u Observaciones del Período',
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
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        hint:
                            'ej. Cierre mensual regular previo a la remisión de la planilla contable...',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nota informativa sobre consolidación automática
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(
                            0xFF3B82F6,
                          ).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Color(0xFF60A5FA),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Al crear el período se consolidarán automáticamente los permisos aprobados, vacaciones gozadas, sanciones pecuniarias y desvinculaciones registradas para este mes.',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF93C5FD),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Acciones al pie
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                    Icons.receipt_long_rounded,
                    color: Color(0xFF60A5FA),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo Período de Nómina',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Apertura de ciclo para entrega de novedades a Contabilidad',
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
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Crear Período',
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

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }
}
