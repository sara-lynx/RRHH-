import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_companion.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_applicant_evaluation_dialog.dart';
import 'rrhh_interview_record_dialog.dart';
import 'rrhh_rejection_dialog.dart';
import 'rrhh_snack_bar.dart';
import '../views/rrhh_hiring_dossier_detail_view.dart';

/// Drawer lateral para evaluación integral en 3 fases y transiciones del postulante.
class RrhhRecruitmentApplicantDrawer extends StatefulWidget {
  final int applicantId;
  final VoidCallback? onStatusChanged;

  const RrhhRecruitmentApplicantDrawer({
    super.key,
    required this.applicantId,
    this.onStatusChanged,
  });

  static Future<bool?> show(
    BuildContext context,
    int applicantId, {
    VoidCallback? onStatusChanged,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (ctx, a1, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOutCubic)),
        child: child,
      ),
      pageBuilder: (ctx, _, _) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: RrhhRecruitmentApplicantDrawer(
            applicantId: applicantId,
            onStatusChanged: onStatusChanged,
          ),
        ),
      ),
    );
  }

  @override
  State<RrhhRecruitmentApplicantDrawer> createState() =>
      _RrhhRecruitmentApplicantDrawerState();
}

class _RrhhRecruitmentApplicantDrawerState
    extends State<RrhhRecruitmentApplicantDrawer> {
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMsg;

  RrhhApplicant? _applicant;
  RrhhApplicantCompanion? _companion;
  List<RrhhApplicant> _previousApplicants = [];

  // Estados de expansión de las secciones colapsables
  late bool _expandFase2;
  late bool _expandFase3;
  bool _expandInterview = true;
  bool _expandHistory = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final repo = RrhhRepository.current;
      final app = await repo.getApplicantById(widget.applicantId);
      final comp = await repo.getApplicantCompanion(widget.applicantId);

      List<RrhhApplicant> prevs = [];
      if (comp.previousApplicationIds.isNotEmpty) {
        final allMatches = await repo.findApplicantsByCi(app.identityCard);
        prevs = allMatches.where((a) => a.id != app.id).toList();
      }

      if (!mounted) return;

      final st = app.status.toUpperCase();
      _expandFase2 =
          (st == 'ENTREVISTA' || st == 'PRUEBAS' || st == 'SELECCIONADO');
      _expandFase3 = (st == 'SELECCIONADO');

      setState(() {
        _applicant = app;
        _companion = comp;
        _previousApplicants = prevs;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = 'Error al cargar expediente: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeStatus(
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  }) async {
    setState(() => _isActionRunning = true);
    try {
      final updated = await RrhhRepository.current.updateApplicantStatus(
        widget.applicantId,
        newStatus,
        notes: notes,
        discardReason: discardReason,
        isEligibleForRehire: isEligibleForRehire,
      );
      if (newStatus == 'SELECCIONADO') {
        try {
          var dossier = await RrhhRepository.current.getDossierByApplicantId(
            widget.applicantId,
          );
          dossier ??= await RrhhRepository.current.createDossierForApplicant(
            widget.applicantId,
          );
        } catch (_) {}
        if (_companion != null) {
          await RrhhRepository.current.saveApplicantCompanion(
            widget.applicantId,
            _companion!,
          );
        }
      }
      final comp = await RrhhRepository.current.getApplicantCompanion(
        widget.applicantId,
      );

      if (mounted) {
        final st = updated.status.toUpperCase();
        setState(() {
          _applicant = updated;
          _companion = comp;
          _isActionRunning = false;
          if (st == 'ENTREVISTA' || st == 'PRUEBAS' || st == 'SELECCIONADO') {
            _expandFase2 = true;
          }
          if (st == 'SELECCIONADO') {
            _expandFase3 = true;
          }
        });
        widget.onStatusChanged?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isActionRunning = false);
        RrhhSnackBar.showError(context, 'Error al cambiar estado: $e');
      }
    }
  }

  Future<void> _handleRejection() async {
    if (_applicant == null) return;
    final rejection = await RrhhRejectionDialog.show(
      context,
      applicantCode: _applicant!.code,
      applicantName: _applicant!.fullName,
    );

    if (rejection == null) return;

    await _changeStatus(
      'RECHAZADO',
      discardReason: rejection.fullReasonText,
      isEligibleForRehire: rejection.isEligibleForRehire,
    );
  }

  Future<void> _handleEditEvaluation() async {
    if (_applicant == null || _companion == null) return;

    final updatedEval = await RrhhApplicantEvaluationDialog.show(
      context,
      targetType: _applicant!.targetType,
      initialEvaluation: _companion!.evaluation,
      applicantCode: _applicant!.code,
      applicantName: _applicant!.fullName,
    );

    if (updatedEval != null) {
      final newComp = _companion!.copyWith(evaluation: updatedEval);
      await RrhhRepository.current.saveApplicantCompanion(
        widget.applicantId,
        newComp,
      );
      setState(() => _companion = newComp);
      widget.onStatusChanged?.call();
    }
  }

  Future<void> _handleDocumentToggle(String docKey, bool value) async {
    if (_companion == null || _applicant == null) return;

    var docs = _companion!.documents;
    switch (docKey) {
      case 'CI':
        docs = docs.copyWith(hasCiCopy: value);
        break;
      case 'FELCC':
        docs = docs.copyWith(hasFelcc: value);
        break;
      case 'AVISO_LUZ_AGUA':
        docs = docs.copyWith(hasUtilityBill: value);
        break;
      case 'CROQUIS':
        docs = docs.copyWith(hasHomeSketch: value);
        break;
      case 'FOTO':
        docs = docs.copyWith(hasPhoto3x4: value);
        break;
      case 'SUS':
        docs = docs.copyWith(hasSus: value);
        break;
    }

    final newComp = _companion!.copyWith(documents: docs);
    await RrhhRepository.current.saveApplicantCompanion(
      widget.applicantId,
      newComp,
    );
    setState(() => _companion = newComp);
  }

  Future<void> _handleInterviewRecord() async {
    if (_applicant == null || _companion == null) return;

    final record = await RrhhInterviewRecordDialog.show(
      context,
      applicantCode: _applicant!.code,
      applicantName: _applicant!.fullName,
      initialRecord: _companion!.interviewRecord,
    );

    if (record != null) {
      await RrhhRepository.current.addInterviewRecord(
        widget.applicantId,
        record,
      );
      await _loadData();
    }
  }

  Future<void> _handleReactivate() async {
    if (_applicant == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(
          'Reactivar Postulación',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '¿Deseas registrar una NUEVA postulación para ${_applicant!.fullName} vinculada al historial previo?',
          style: GoogleFonts.inter(
            color: const Color(0xFFCBD5E1),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reactivar como NUEVO'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final newApp = RrhhApplicant(
      code: '',
      fullName: _applicant!.fullName,
      identityCard: _applicant!.identityCard,
      phone: _applicant!.phone,
      email: _applicant!.email,
      birthDate: _applicant!.birthDate,
      targetType: _applicant!.targetType,
      targetArea: _applicant!.targetArea,
      areaId: _applicant!.areaId,
      targetPosition: _applicant!.targetPosition,
      positionId: _applicant!.positionId,
      specialty: _applicant!.specialty,
      specialtyId: _applicant!.specialtyId,
      applicationDate: DateTime.now(),
      status: 'NUEVO',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final newComp = RrhhApplicantCompanion(
      applicantId: 0,
      previousApplicationIds: [_applicant!.id ?? 0],
    );

    await RrhhRepository.current.createApplicant(newApp, companion: newComp);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(left: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0284C7)),
            )
          : _applicant == null
          ? Center(
              child: Text(
                _errorMsg ?? 'Postulante no encontrado',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Fase 1: Datos del postulante (Siempre visible)
                        _buildSectionFase1Personal(),
                        const SizedBox(height: 12),

                        // 2. Fase 2: Evaluación completa (Colapsable)
                        _buildSectionFase2Evaluation(),
                        const SizedBox(height: 12),

                        // 3. Fase 3: Documentos requeridos (Colapsable con checkboxes)
                        _buildSectionFase3Documents(),
                        const SizedBox(height: 12),

                        // 4. Registro de Entrevista (Visible si ENTREVISTA, PRUEBAS, SELECCIONADO, RECHAZADO)
                        if (_shouldShowInterviewSection) ...[
                          _buildSectionInterview(),
                          const SizedBox(height: 12),
                        ],

                        // 5. Historial de transiciones y postulaciones anteriores
                        _buildSectionTimelineAndPast(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
    );
  }

  bool get _shouldShowInterviewSection {
    final st = _applicant?.status.toUpperCase() ?? '';
    return st == 'ENTREVISTA' ||
        st == 'PRUEBAS' ||
        st == 'SELECCIONADO' ||
        st == 'RECHAZADO' ||
        st == 'CONTRATADO';
  }

  Widget _buildHeader() {
    final a = _applicant!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 14, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      a.code,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusBadge(a.status),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        a.targetType.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: a.targetType.toUpperCase() == 'CAMPO'
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFFA855F7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  a.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN 1: FASE 1 — DATOS DEL POSTULANTE (Siempre visible)
  // ---------------------------------------------------------------------------
  Widget _buildSectionFase1Personal() {
    final a = _applicant!;
    final b = a.birthDate != null
        ? '${a.birthDate!.day.toString().padLeft(2, '0')}/${a.birthDate!.month.toString().padLeft(2, '0')}/${a.birthDate!.year}'
        : 'No registrada';

    int? age;
    if (a.birthDate != null) {
      final now = DateTime.now();
      age =
          now.year -
          a.birthDate!.year -
          ((now.month < a.birthDate!.month ||
                  (now.month == a.birthDate!.month &&
                      now.day < a.birthDate!.day))
              ? 1
              : 0);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF38BDF8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FASE 1: DATOS GENERALES',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF38BDF8),
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'REGISTRADO',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _itemRow('Cédula de Identidad', a.identityCard, isLocked: true),
          _itemRow('Teléfono / Celular', a.phone),
          _itemRow('Correo Electrónico', a.email ?? 'No registrado'),
          _itemRow(
            'Fecha Nacimiento',
            '$b ${age != null ? "($age años)" : ""}',
          ),
          _itemRow('Área Aspirada', a.targetArea ?? 'No asignada'),
          _itemRow('Especialidad', a.specialty ?? 'General'),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN 2: FASE 2 — EVALUACIÓN COMPLETA (Colapsable)
  // ---------------------------------------------------------------------------
  Widget _buildSectionFase2Evaluation() {
    final a = _applicant!;
    final comp = _companion!;
    final isComplete = comp.evaluation.isCompleteFor(a.targetType);
    final isCampo = a.targetType.toUpperCase() == 'CAMPO';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : const Color(0xFF1E293B),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandFase2 = !_expandFase2),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isCampo
                        ? Icons.fact_check_outlined
                        : Icons.assignment_outlined,
                    color: const Color(0xFF818CF8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'FASE 2: EVALUACIÓN COMPLETA',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF818CF8),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isComplete
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B))
                              .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isComplete ? 'COMPLETA ✓' : 'PENDIENTE',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isComplete
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expandFase2
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expandFase2) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCampo) ...[
                    _itemRow(
                      'Formación / Educación',
                      comp.evaluation.education ?? 'Sin registrar',
                    ),
                    _itemRow(
                      'Exp. Operativa',
                      comp.evaluation.experienceSummary ?? 'Sin registrar',
                    ),
                    _itemRow(
                      'Habilidades',
                      comp.evaluation.technicalSkills.isEmpty
                          ? 'Ninguna'
                          : comp.evaluation.technicalSkills.join(', '),
                    ),
                    _itemRow(
                      'Turnos Rotativos',
                      comp.evaluation.rotatingShiftsAvailable
                          ? 'Disponible ✓'
                          : 'No disponible ✗',
                    ),
                    _itemRow(
                      'Sedes Externas',
                      comp.evaluation.clientBranchesAvailable
                          ? 'Disponible ✓'
                          : 'No disponible ✗',
                    ),
                    _itemRow(
                      'Aptitud Física',
                      comp.evaluation.physicalFitnessDeclared
                          ? 'Apto declarado ✓'
                          : 'Pendiente ✗',
                    ),
                    if (comp.evaluation.drivingLicense != null)
                      _itemRow(
                        'Licencia Conducir',
                        comp.evaluation.drivingLicense!,
                      ),
                  ] else ...[
                    _itemRow(
                      'Nivel Educativo',
                      comp.evaluation.educationLevel ?? 'Sin registrar',
                    ),
                    if (comp.evaluation.professionalTitle != null)
                      _itemRow(
                        'Título Profesional',
                        comp.evaluation.professionalTitle!,
                      ),
                    _itemRow(
                      'Exp. Administrativa',
                      comp.evaluation.experienceSummary ?? 'Sin registrar',
                    ),
                    _itemRow(
                      'Competencias',
                      comp.evaluation.technicalSkills.isEmpty
                          ? 'Ninguna'
                          : comp.evaluation.technicalSkills.join(', '),
                    ),
                    if (comp.evaluation.professionalCertifications != null)
                      _itemRow(
                        'Certificaciones',
                        comp.evaluation.professionalCertifications!,
                      ),
                    if (comp.evaluation.salaryExpectation != null &&
                        comp.evaluation.salaryExpectation! > 0)
                      _itemRow(
                        'Pretensión Salarial',
                        'Bs. ${comp.evaluation.salaryExpectation!.toStringAsFixed(0)}',
                      ),
                  ],

                  const SizedBox(height: 8),
                  _itemRow(
                    'Ref. Personal',
                    comp.evaluation.personalReferenceName != null
                        ? '${comp.evaluation.personalReferenceName} (${comp.evaluation.personalReferencePhone ?? ""})'
                        : 'No registrada',
                  ),
                  _itemRow(
                    'Ref. Laboral',
                    comp.evaluation.workReferenceName != null
                        ? '${comp.evaluation.workReferenceName} (${comp.evaluation.workReferencePhone ?? ""})'
                        : 'No registrada',
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF38BDF8),
                        side: const BorderSide(color: Color(0xFF0284C7)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: _handleEditEvaluation,
                      icon: const Icon(Icons.edit_note, size: 16),
                      label: Text(
                        isComplete
                            ? 'Modificar Evaluación'
                            : 'Completar Fase 2',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN 3: FASE 3 — DOCUMENTOS REQUERIDOS (Colapsable con checkboxes)
  // ---------------------------------------------------------------------------
  Widget _buildSectionFase3Documents() {
    final a = _applicant!;
    final comp = _companion!;
    final isComplete = comp.documents.isCompleteFor(a.targetType);
    final count = comp.documents.completedCount(a.targetType);
    final total = comp.documents.totalRequired(a.targetType);
    final isCampo = a.targetType.toUpperCase() == 'CAMPO';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : const Color(0xFF1E293B),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandFase3 = !_expandFase3),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.folder_shared_outlined,
                    color: Color(0xFFF59E0B),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'FASE 3: EXPEDIENTE DE DOCUMENTOS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF59E0B),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isComplete
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B))
                              .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$count / $total (${isComplete ? "COMPLETO ✓" : "INCOMPLETO"})',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isComplete
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expandFase3
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expandFase3) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  _docCheckboxTile(
                    'Fotocopia Cédula de Identidad *',
                    comp.documents.hasCiCopy,
                    (v) => _handleDocumentToggle('CI', v),
                  ),
                  _docCheckboxTile(
                    'Aviso de Cobranza Luz / Agua *',
                    comp.documents.hasUtilityBill,
                    (v) => _handleDocumentToggle('AVISO_LUZ_AGUA', v),
                  ),
                  _docCheckboxTile(
                    'Croquis Domiciliario Verificado *',
                    comp.documents.hasHomeSketch,
                    (v) => _handleDocumentToggle('CROQUIS', v),
                  ),
                  _docCheckboxTile(
                    'Fotografía 3x4 Fondo Rojo *',
                    comp.documents.hasPhoto3x4,
                    (v) => _handleDocumentToggle('FOTO', v),
                  ),
                  _docCheckboxTile(
                    'Constancia Afiliación SUS *',
                    comp.documents.hasSus,
                    (v) => _handleDocumentToggle('SUS', v),
                  ),
                  _docCheckboxTile(
                    isCampo
                        ? 'Certificado Antecedentes FELCC *'
                        : 'Certificado FELCC (Condicional a Seguridad)',
                    comp.documents.hasFelcc,
                    (v) => _handleDocumentToggle('FELCC', v),
                    isRequired: isCampo,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _docCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: value
                ? const Color(0xFF10B981).withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: value,
                  activeColor: const Color(0xFF10B981),
                  side: const BorderSide(color: Color(0xFF64748B)),
                  onChanged: (v) => onChanged(v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isRequired ? FontWeight.w500 : FontWeight.w400,
                    color: value ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              Icon(
                value ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 15,
                color: value
                    ? const Color(0xFF10B981)
                    : const Color(0xFF475569),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN 4: REGISTRO DE ENTREVISTA (Visible si ENTREVISTA / PRUEBAS / SELECCIONADO / RECHAZADO)
  // ---------------------------------------------------------------------------
  Widget _buildSectionInterview() {
    final comp = _companion!;
    final rec = comp.interviewRecord;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandInterview = !_expandInterview),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.record_voice_over_outlined,
                    color: Color(0xFFA855F7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'REGISTRO DE ENTREVISTA',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA855F7),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  if (rec != null)
                    _interviewResultBadge(rec.result)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64748B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SIN REGISTRO',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _expandInterview
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expandInterview) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: rec == null
                  ? Column(
                      children: [
                        Text(
                          'Aún no se ha asentado el registro formal de la entrevista.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                          ),
                          onPressed: _handleInterviewRecord,
                          icon: const Icon(
                            Icons.add_comment_outlined,
                            size: 15,
                          ),
                          label: Text(
                            'Registrar Entrevista',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _itemRow(
                          'Fecha y Hora',
                          '${rec.dateTime.day}/${rec.dateTime.month}/${rec.dateTime.year} — ${rec.dateTime.hour.toString().padLeft(2, '0')}:${rec.dateTime.minute.toString().padLeft(2, '0')}',
                        ),
                        _itemRow('Modalidad', rec.modality),
                        _itemRow(
                          'Entrevistadores',
                          rec.interviewers.join(', '),
                        ),
                        _itemRow('Resultado', rec.result),
                        if (rec.rejectionReason != null &&
                            rec.rejectionReason!.isNotEmpty)
                          _itemRow('Motivo No Apto', rec.rejectionReason!),
                        const SizedBox(height: 6),
                        Text(
                          'Conclusiones & Notas:',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rec.notes,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF38BDF8),
                              side: const BorderSide(color: Color(0xFF0284C7)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                            ),
                            onPressed: _handleInterviewRecord,
                            icon: const Icon(Icons.edit, size: 14),
                            label: Text(
                              'Editar Registro',
                              style: GoogleFonts.inter(fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN 5: HISTORIAL DE TRANSICIONES Y POSTULACIONES ANTERIORES
  // ---------------------------------------------------------------------------
  Widget _buildSectionTimelineAndPast() {
    final comp = _companion!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandHistory = !_expandHistory),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_outlined,
                    color: Color(0xFF94A3B8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'HISTORIAL Y TRAZABILIDAD',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Text(
                    '${comp.history.length} eventos',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expandHistory
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expandHistory) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Línea de tiempo
                  ...comp.history.reversed.map(
                    (entry) => _buildTimelineEntry(entry),
                  ),

                  // Postulaciones previas (CAMBIO 9)
                  if (_previousApplicants.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFF1E293B)),
                    const SizedBox(height: 6),
                    Text(
                      'POSTULACIONES ANTERIORES VINCULADAS',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF59E0B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._previousApplicants.map(
                      (prev) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${prev.code} • ${prev.applicationDate.day}/${prev.applicationDate.month}/${prev.applicationDate.year}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                _statusBadge(prev.status),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${prev.targetPosition} (${prev.targetType})',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            if (prev.discardReason != null &&
                                prev.discardReason!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Motivo: ${prev.discardReason}',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: const Color(0xFFFCA5A5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(RrhhStatusHistoryEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF38BDF8),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 1.5,
                height: 28,
                color: const Color(0xFF334155),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${entry.fromStatus} → ${entry.toStatus}',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${entry.timestamp.day}/${entry.timestamp.month} ${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Por: ${entry.author}',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                if (entry.notes != null && entry.notes!.isNotEmpty)
                  Text(
                    entry.notes!,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: const Color(0xFFCBD5E1),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BARRA INFERIOR DE ACCIONES POR ETAPA (CAMBIO 8)
  // ---------------------------------------------------------------------------
  Widget _buildBottomBar() {
    final a = _applicant!;
    final st = a.status.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Botón Rechazar común para etapas activas
              if (st != 'RECHAZADO' && st != 'CONTRATADO') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isActionRunning ? null : _handleRejection,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Rechazar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],

              // Acciones dinámicas según etapa:
              if (st == 'NUEVO')
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isActionRunning
                        ? null
                        : () => _changeStatus('EN_REVISION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF818CF8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Avanzar a Revisión',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (st == 'EN_REVISION')
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isActionRunning
                        ? null
                        : () => _changeStatus('ENTREVISTA'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Avanzar a Entrevista',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (st == 'ENTREVISTA') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isActionRunning
                        ? null
                        : () => _changeStatus('PRUEBAS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFA855F7),
                      side: const BorderSide(color: Color(0xFFA855F7)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'A Pruebas',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isActionRunning
                        ? null
                        : () => _changeStatus('SELECCIONADO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Seleccionar',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              if (st == 'PRUEBAS')
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isActionRunning
                        ? null
                        : () => _changeStatus('SELECCIONADO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Marcar como Seleccionado',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (st == 'SELECCIONADO')
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isActionRunning
                        ? null
                        : () async {
                            final nav = Navigator.of(context);
                            setState(() => _isActionRunning = true);
                            try {
                              var dossier = await RrhhRepository.current
                                  .getDossierByApplicantId(a.id!);
                              dossier ??= await RrhhRepository.current
                                  .createDossierForApplicant(a.id!);
                              if (!mounted) return;
                              nav.pop(true);
                              nav.push(
                                MaterialPageRoute(
                                  builder: (ctx) => Scaffold(
                                    backgroundColor: const Color(0xFF090D16),
                                    body: SafeArea(
                                      child: RrhhHiringDossierDetailView(
                                        dossierId: dossier!.id ?? 0,
                                        onBack: () => Navigator.of(ctx).pop(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (mounted) {
                                RrhhSnackBar.showError(
                                  context,
                                  'Error al abrir expediente: $e',
                                );
                              }
                            } finally {
                              if (mounted)
                                setState(() => _isActionRunning = false);
                            }
                          },
                    icon: const Icon(Icons.assignment_outlined, size: 16),
                    label: Text(
                      'Abrir Expediente de Contratación',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF334155),
                      disabledForegroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

              if (st == 'RECHAZADO')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isActionRunning ? null : _handleReactivate,
                    icon: const Icon(Icons.replay_outlined, size: 16),
                    label: Text(
                      'Reactivar como nuevo POST',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

              if (st == 'CONTRATADO')
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Colaborador Contratado (En Nómina Activa)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String label, String value, {bool isLocked = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Row(
              children: [
                if (isLocked)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.lock_outline,
                      size: 11,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'NUEVO':
        color = const Color(0xFF38BDF8);
        break;
      case 'EN_REVISION':
        color = const Color(0xFF818CF8);
        break;
      case 'ENTREVISTA':
        color = const Color(0xFFF59E0B);
        break;
      case 'PRUEBAS':
        color = const Color(0xFFA855F7);
        break;
      case 'SELECCIONADO':
        color = const Color(0xFF10B981);
        break;
      case 'CONTRATADO':
        color = const Color(0xFF059669);
        break;
      case 'RECHAZADO':
      default:
        color = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _interviewResultBadge(String result) {
    Color c = const Color(0xFF10B981);
    if (result == 'No Apto') c = const Color(0xFFEF4444);
    if (result == 'Dudoso') c = const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        result.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: c,
        ),
      ),
    );
  }
}
