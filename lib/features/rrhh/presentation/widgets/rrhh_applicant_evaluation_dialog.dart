import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_companion.dart';

/// Modal para completar o actualizar la Evaluación Completa (Fase 2)
/// adaptado estrictamente para personal de CAMPO o de OFICINA.
class RrhhApplicantEvaluationDialog extends StatefulWidget {
  final String targetType; // 'CAMPO' | 'OFICINA'
  final RrhhApplicantEvaluation initialEvaluation;
  final String applicantCode;
  final String applicantName;

  const RrhhApplicantEvaluationDialog({
    super.key,
    required this.targetType,
    required this.initialEvaluation,
    required this.applicantCode,
    required this.applicantName,
  });

  static Future<RrhhApplicantEvaluation?> show(
    BuildContext context, {
    required String targetType,
    required RrhhApplicantEvaluation initialEvaluation,
    required String applicantCode,
    required String applicantName,
  }) {
    return showDialog<RrhhApplicantEvaluation>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhApplicantEvaluationDialog(
        targetType: targetType,
        initialEvaluation: initialEvaluation,
        applicantCode: applicantCode,
        applicantName: applicantName,
      ),
    );
  }

  @override
  State<RrhhApplicantEvaluationDialog> createState() =>
      _RrhhApplicantEvaluationDialogState();
}

class _RrhhApplicantEvaluationDialogState
    extends State<RrhhApplicantEvaluationDialog> {
  final _formKey = GlobalKey<FormState>();

  // Campos Comunes
  late final TextEditingController _educationCtrl;
  late final TextEditingController _expSummaryCtrl;
  late final TextEditingController _skillsCtrl;
  late final TextEditingController _personalRefNameCtrl;
  late final TextEditingController _personalRefPhoneCtrl;
  late final TextEditingController _workRefNameCtrl;
  late final TextEditingController _workRefPhoneCtrl;

  // Específicos CAMPO
  late bool _rotatingShifts;
  late bool _clientBranches;
  late final TextEditingController _drivingLicenseCtrl;
  late bool _physicalFitness;

  // Específicos OFICINA
  String _educationLevel = 'Licenciatura';
  final List<String> _educationLevels = [
    'Bachiller',
    'Técnico',
    'Licenciatura',
    'Postgrado',
  ];
  late final TextEditingController _professionalTitleCtrl;
  late final TextEditingController _certificationsCtrl;
  late final TextEditingController _salaryExpectationCtrl;

  @override
  void initState() {
    super.initState();
    final ev = widget.initialEvaluation;
    _educationCtrl = TextEditingController(text: ev.education ?? '');
    _expSummaryCtrl = TextEditingController(text: ev.experienceSummary ?? '');
    _skillsCtrl = TextEditingController(text: ev.technicalSkills.join(', '));
    _personalRefNameCtrl = TextEditingController(
      text: ev.personalReferenceName ?? '',
    );
    _personalRefPhoneCtrl = TextEditingController(
      text: ev.personalReferencePhone ?? '',
    );
    _workRefNameCtrl = TextEditingController(text: ev.workReferenceName ?? '');
    _workRefPhoneCtrl = TextEditingController(
      text: ev.workReferencePhone ?? '',
    );

    _rotatingShifts = ev.rotatingShiftsAvailable;
    _clientBranches = ev.clientBranchesAvailable;
    _drivingLicenseCtrl = TextEditingController(text: ev.drivingLicense ?? '');
    _physicalFitness = ev.physicalFitnessDeclared;

    if (ev.educationLevel != null &&
        _educationLevels.contains(ev.educationLevel)) {
      _educationLevel = ev.educationLevel!;
    }
    _professionalTitleCtrl = TextEditingController(
      text: ev.professionalTitle ?? '',
    );
    _certificationsCtrl = TextEditingController(
      text: ev.professionalCertifications ?? '',
    );
    _salaryExpectationCtrl = TextEditingController(
      text: (ev.salaryExpectation != null && ev.salaryExpectation! > 0)
          ? ev.salaryExpectation!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _educationCtrl.dispose();
    _expSummaryCtrl.dispose();
    _skillsCtrl.dispose();
    _personalRefNameCtrl.dispose();
    _personalRefPhoneCtrl.dispose();
    _workRefNameCtrl.dispose();
    _workRefPhoneCtrl.dispose();
    _drivingLicenseCtrl.dispose();
    _professionalTitleCtrl.dispose();
    _certificationsCtrl.dispose();
    _salaryExpectationCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final skillsList = _skillsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final isCampo = widget.targetType.toUpperCase() == 'CAMPO';

    final evaluation = RrhhApplicantEvaluation(
      education: isCampo ? _educationCtrl.text.trim() : _educationLevel,
      experienceSummary: _expSummaryCtrl.text.trim(),
      technicalSkills: skillsList,
      personalReferenceName: _personalRefNameCtrl.text.trim().isEmpty
          ? null
          : _personalRefNameCtrl.text.trim(),
      personalReferencePhone: _personalRefPhoneCtrl.text.trim().isEmpty
          ? null
          : _personalRefPhoneCtrl.text.trim(),
      workReferenceName: _workRefNameCtrl.text.trim().isEmpty
          ? null
          : _workRefNameCtrl.text.trim(),
      workReferencePhone: _workRefPhoneCtrl.text.trim().isEmpty
          ? null
          : _workRefPhoneCtrl.text.trim(),
      // CAMPO
      rotatingShiftsAvailable: _rotatingShifts,
      clientBranchesAvailable: _clientBranches,
      drivingLicense: _drivingLicenseCtrl.text.trim().isEmpty
          ? null
          : _drivingLicenseCtrl.text.trim(),
      physicalFitnessDeclared: _physicalFitness,
      // OFICINA
      educationLevel: isCampo ? null : _educationLevel,
      professionalTitle: _professionalTitleCtrl.text.trim().isEmpty
          ? null
          : _professionalTitleCtrl.text.trim(),
      professionalCertifications: _certificationsCtrl.text.trim().isEmpty
          ? null
          : _certificationsCtrl.text.trim(),
      salaryExpectation: double.tryParse(_salaryExpectationCtrl.text.trim()),
    );

    Navigator.of(context).pop(evaluation);
  }

  @override
  Widget build(BuildContext context) {
    final isCampo = widget.targetType.toUpperCase() == 'CAMPO';

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 750),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color:
                            (isCampo
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFFA855F7))
                                .withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              (isCampo
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFFA855F7))
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        isCampo
                            ? Icons.fact_check_outlined
                            : Icons.assignment_outlined,
                        color: isCampo
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFFA855F7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Evaluación Completa (Fase 2)',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.applicantCode} • ${widget.applicantName} (${widget.targetType})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form body scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCampo) ...[
                          // FORMULARIO CAMPO
                          _buildField(
                            controller: _educationCtrl,
                            label: 'EDUCACIÓN / FORMACIÓN *',
                            hint:
                                'Ej: Bachiller en Humanidades, Libreta de Servicio Militar',
                            icon: Icons.school_outlined,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Requerido.'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _expSummaryCtrl,
                            label: 'EXPERIENCIA OPERATIVA PREVIA (RESUMEN) *',
                            hint:
                                'Empresas anteriores, funciones realizadas, tiempo...',
                            icon: Icons.work_history_outlined,
                            maxLines: 2,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Requerido.'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _skillsCtrl,
                            label:
                                'HABILIDADES TÉCNICAS ESPECÍFICAS (SEPARADAS POR COMA)',
                            hint:
                                'Ej: Manejo de hidrolavadoras, CCTV, Trabajo en altura',
                            icon: Icons.build_circle_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _drivingLicenseCtrl,
                            label: 'LICENCIA DE CONDUCIR (SI APLICA)',
                            hint: 'Ej: Categoría A, Categoría B, Profesional C',
                            icon: Icons.drive_eta_outlined,
                          ),
                          const SizedBox(height: 14),

                          // Disponibilidades operativas
                          _sectionTitle('CONDICIONES OPERATIVAS DECLARADAS'),
                          Material(
                            color: const Color(0xFF1E293B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFF334155)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  value: _rotatingShifts,
                                  dense: true,
                                  activeColor: const Color(0xFF0284C7),
                                  title: Text(
                                    'Disponibilidad para turnos rotativos (Mañana / Tarde / Noche)',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (v) => setState(
                                    () => _rotatingShifts = v ?? true,
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFF334155),
                                ),
                                CheckboxListTile(
                                  value: _clientBranches,
                                  dense: true,
                                  activeColor: const Color(0xFF0284C7),
                                  title: Text(
                                    'Disponibilidad para trabajar en sedes externas de clientes',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (v) => setState(
                                    () => _clientBranches = v ?? true,
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFF334155),
                                ),
                                CheckboxListTile(
                                  value: _physicalFitness,
                                  dense: true,
                                  activeColor: const Color(0xFF10B981),
                                  title: Text(
                                    'Aptitud física y de salud declarada para labores de campo *',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Obligatorio certificar condición física antes de contratar',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  onChanged: (v) => setState(
                                    () => _physicalFitness = v ?? true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // FORMULARIO OFICINA
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel('NIVEL EDUCATIVO *'),
                                    DropdownButtonFormField<String>(
                                      initialValue: _educationLevel,
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF1E293B),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(),
                                      items: _educationLevels
                                          .map(
                                            (lvl) => DropdownMenuItem(
                                              value: lvl,
                                              child: Text(
                                                lvl,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null)
                                          setState(() => _educationLevel = v);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildField(
                                  controller: _professionalTitleCtrl,
                                  label: 'TÍTULO PROFESIONAL (OPCIONAL)',
                                  hint:
                                      'Ej: Lic. en Contabilidad, Ing. Comercial',
                                  icon: Icons.school_outlined,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _expSummaryCtrl,
                            label: 'EXPERIENCIA ADMINISTRATIVA PREVIA *',
                            hint:
                                'Gestión documental, compras, atención cliente, RRHH...',
                            icon: Icons.work_history_outlined,
                            maxLines: 2,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Requerido.'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _skillsCtrl,
                            label:
                                'COMPETENCIAS TÉCNICAS (EXCEL, ERP, IDIOMAS, ETC.)',
                            hint:
                                'Ej: Excel avanzado, SIAT, ERP SAP, Redacción comercial',
                            icon: Icons.stars_outlined,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildField(
                                  controller: _certificationsCtrl,
                                  label:
                                      'CERTIFICACIONES PROFESIONALES (OPCIONAL)',
                                  hint: 'Ej: Diplomado en Tributación, Scrum',
                                  icon: Icons.card_membership_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _buildField(
                                  controller: _salaryExpectationCtrl,
                                  label: 'PRETENSIÓN (BS.)',
                                  hint: 'Ej: 3500',
                                  icon: Icons.payments_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),
                        // REFERENCIAS (Comunes)
                        _sectionTitle('REFERENCIAS PERSONALES Y LABORALES'),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildField(
                                controller: _personalRefNameCtrl,
                                label: 'REFERENCIA PERSONAL',
                                hint: 'Nombre y parentesco',
                                icon: Icons.person_outline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _buildField(
                                controller: _personalRefPhoneCtrl,
                                label: 'TELÉFONO',
                                hint: 'Ej: 78912345',
                                icon: Icons.phone_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildField(
                                controller: _workRefNameCtrl,
                                label: 'REFERENCIA LABORAL PREVIA',
                                hint: 'Jefe anterior o empresa',
                                icon: Icons.business_outlined,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _buildField(
                                controller: _workRefPhoneCtrl,
                                label: 'TELÉFONO',
                                hint: 'Ej: 71122334',
                                icon: Icons.phone_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF94A3B8),
                        side: const BorderSide(color: Color(0xFF334155)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _save,
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        'Guardar Evaluación',
                        style: GoogleFonts.inter(
                          fontSize: 13,
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
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: const Color(0xFF38BDF8),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
          decoration: _inputDecoration(
            hint: hint,
            prefixIcon: maxLines == 1
                ? Icon(icon, color: const Color(0xFF38BDF8), size: 16)
                : null,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      hintStyle: GoogleFonts.inter(
        fontSize: 12,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF0284C7)),
      ),
    );
  }
}
