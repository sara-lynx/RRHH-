import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Modal para creación de nueva sede de cliente y configuración de geocerca GPS para la APK.
class EliteClientSiteFormDialog extends ConsumerStatefulWidget {
  const EliteClientSiteFormDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const EliteClientSiteFormDialog(),
    );
  }

  @override
  ConsumerState<EliteClientSiteFormDialog> createState() =>
      _EliteClientSiteFormDialogState();
}

class _EliteClientSiteFormDialogState
    extends ConsumerState<EliteClientSiteFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController(text: 'SITE-MULTIC');
  final _nameController = TextEditingController(text: 'Edificio Multicentro');
  final _latController = TextEditingController(text: '-17.7810');
  final _lngController = TextEditingController(text: '-63.1790');
  final _radiusController = TextEditingController(text: '80');
  final _requiredStaffController = TextEditingController(text: '2');
  final _assignedStaffController = TextEditingController(text: '2');

  String _costCenter = EliteCostCenter.lim;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    _requiredStaffController.dispose();
    _assignedStaffController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final sitesCount = ref.read(rrhhClientSitesProvider).length;
    final newSite = EliteClientSite(
      id: 'SITE-${(sitesCount + 1).toString().padLeft(3, '0')}',
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      serviceLineCode: _costCenter,
      latitude: double.tryParse(_latController.text.trim()) ?? -17.7810,
      longitude: double.tryParse(_lngController.text.trim()) ?? -63.1790,
      geofenceRadiusMeters:
          double.tryParse(_radiusController.text.trim()) ?? 80.0,
      requiredPersonnel:
          int.tryParse(_requiredStaffController.text.trim()) ?? 2,
      currentAssigned:
          int.tryParse(_assignedStaffController.text.trim()) ?? 2,
    );

    ref.read(rrhhClientSitesProvider.notifier).addClientSite(newSite);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          'Sede ${newSite.name} (${newSite.code}) guardada con geocerca de ${newSite.geofenceRadiusMeters.toInt()}m.',
          style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
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
                    child: const Icon(
                      Icons.add_location_alt_outlined,
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
                          'Nueva Sede de Cliente',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Parámetros GPS de geocerca para validación de la APK de campo',
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
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildTextField(
                            controller: _codeController,
                            label: 'Código de Sede',
                            hint: 'SITE-MULTIC',
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: _buildTextField(
                            controller: _nameController,
                            label: 'Nombre de la Sede / Cliente',
                            hint: 'Edificio Multicentro',
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Centro de Costo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Centro de Costo Vinculado',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          initialValue: _costCenter,
                          items: EliteCostCenter.all.map((cc) {
                            return DropdownMenuItem(
                              value: cc,
                              child: Text(
                                EliteCostCenter.getLabel(cc),
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _costCenter = val ?? _costCenter),
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
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
                              borderSide: const BorderSide(
                                color: Color(0xFF0D9488),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Coordenadas GPS y Radio
                    Text(
                      'GEOLOCALIZACIÓN Y GEOCERCA APK',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _latController,
                            label: 'Latitud GPS',
                            hint: '-17.7810',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _lngController,
                            label: 'Longitud GPS',
                            hint: '-63.1790',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _radiusController,
                            label: 'Radio (metros)',
                            hint: '80',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dotación
                    Text(
                      'DOTACIÓN DE PERSONAL EXIGIDA POR CONTRATO',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _requiredStaffController,
                            label: 'Personal Requerido',
                            hint: '2',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _assignedStaffController,
                            label: 'Personal Asignado Inicial',
                            hint: '2',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
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
                      'Guardar Sede',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          ),
        ),
      ],
    );
  }
}
