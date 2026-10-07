import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_recruitment_models.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_recruitment_providers.dart';

/// Tab 3: Expedientes, Wizard de Contratación y Checklist Legal Boliviano.
class EliteHiringWizardTab extends ConsumerStatefulWidget {
  const EliteHiringWizardTab({super.key});

  @override
  ConsumerState<EliteHiringWizardTab> createState() =>
      _EliteHiringWizardTabState();
}

class _EliteHiringWizardTabState extends ConsumerState<EliteHiringWizardTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _openHiringWizard(BuildContext context, EliteApplicant applicant) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _HiringWizardDialog(applicant: applicant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allApplicants = ref.watch(rrhhApplicantsProvider);
    final pendingHiring = allApplicants
        .where((a) => a.stage == RecruitmentStage.seleccionados && !a.isHired)
        .toList();
    final hiredApplicants = allApplicants.where((a) => a.isHired).toList();

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // ===================================================================
          // 1. BARRA SUPERIOR DE CONTEXTO LEGAL & BUSCADOR (~46px)
          // ===================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.how_to_reg_outlined,
                    size: 18,
                    color: Color(0xFF047857),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legajos & Contratación Formal de Personal',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Gestión de expediente laboral según la Ley General del Trabajo de Bolivia',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Badge de pendientes
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.assignment_outlined,
                          size: 13, color: Color(0xFFB45309)),
                      const SizedBox(width: 6),
                      Text(
                        '${pendingHiring.length} por formalizar',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===================================================================
          // 2. CONTENIDO PRINCIPAL: LISTA DE EXPEDIENTES
          // ===================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: pendingHiring.isEmpty && hiredApplicants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open_outlined,
                            size: 42,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No hay postulantes en la etapa de Seleccionados',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mueva candidatos a "Seleccionados" en el Kanban para iniciar el proceso de contratación.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        // SECCIÓN 1: PENDIENTES DE CONTRATACIÓN
                        if (pendingHiring.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D9488),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'CANDIDATOS SELECCIONADOS LISTOS PARA CONTRATAR',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF334155),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...pendingHiring.map((applicant) => _buildDossierCard(
                                applicant,
                                isPending: true,
                              )),
                          const SizedBox(height: 20),
                        ],

                        // SECCIÓN 2: HISTORIAL DE CONTRATACIONES RECIENTES
                        if (hiredApplicants.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'CONTRATACIONES CONSOLIDADAS Y DADAS DE ALTA EN NÓMINA',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF64748B),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...hiredApplicants.map((applicant) => _buildDossierCard(
                                applicant,
                                isPending: false,
                              )),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDossierCard(EliteApplicant applicant, {required bool isPending}) {
    final checklist = applicant.checklist;
    final progress = checklist.completedCount / 6.0;
    final isField = applicant.workplaceType == EmployeeWorkplaceType.campo;
    final avatarBg =
        isField ? const Color(0xFFCCFBF1) : const Color(0xFFE0F2FE);
    final avatarColor =
        isField ? const Color(0xFF0F766E) : const Color(0xFF0369A1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPending ? const Color(0xFFCCFBF1) : const Color(0xFFE2E8F0),
          width: isPending ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040F172A),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBg,
            child: Text(
              _getInitials(applicant.fullName),
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: avatarColor,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Información del Candidato
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      applicant.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        applicant.code,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                    if (applicant.isHired) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Text(
                          'ALTA: ${applicant.hiredEmployeeCode}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'CI: ${applicant.ci} • Tel: ${applicant.phone} • Cargo: ${applicant.targetPosition}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sede: ${applicant.assignedSite} • Pretensión: Bs. ${applicant.expectedSalary.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Barra de Checklist Legal
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Checklist Legal Boliviano:',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      '${checklist.completedCount}/6 docs',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: checklist.isAllCompleted
                            ? const Color(0xFF047857)
                            : const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      checklist.isAllCompleted
                          ? const Color(0xFF10B981)
                          : const Color(0xFF0D9488),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Botón de Acción
          if (isPending)
            ElevatedButton.icon(
              onPressed: () => _openHiringWizard(context, applicant),
              icon: const Icon(Icons.edit_document, size: 14),
              label: Text(
                'Iniciar Contratación',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF0F172A),
                    content: Text(
                      'Colaborador ${applicant.fullName} ya fue dado de alta con el código ${applicant.hiredEmployeeCode} en el Directorio.',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline,
                  size: 14, color: Color(0xFF047857)),
              label: Text(
                'Ver en Directorio',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF047857),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFA7F3D0)),
                backgroundColor: const Color(0xFFECFDF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Diálogo interactivo del Wizard de Contratación en 3 Pasos.
class _HiringWizardDialog extends ConsumerStatefulWidget {
  final EliteApplicant applicant;

  const _HiringWizardDialog({required this.applicant});

  @override
  ConsumerState<_HiringWizardDialog> createState() =>
      _HiringWizardDialogState();
}

class _HiringWizardDialogState extends ConsumerState<_HiringWizardDialog> {
  int _currentStep = 0;

  // Paso 1: Datos Contractuales
  late EmployeeWorkplaceType _workplaceType;
  late String _serviceLineCode;
  late String _assignedSite;
  late TextEditingController _salaryController;
  ContractType _contractType = ContractType.indefinido;

  // Paso 2: Checklist Documental
  late LegalDocumentChecklist _checklist;

  @override
  void initState() {
    super.initState();
    _workplaceType = widget.applicant.workplaceType;
    _serviceLineCode = widget.applicant.serviceLineCode;
    _assignedSite = widget.applicant.assignedSite;
    _salaryController = TextEditingController(
      text: widget.applicant.expectedSalary.toStringAsFixed(0),
    );
    _checklist = widget.applicant.checklist;
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 680,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Cabecera del Wizard
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.how_to_reg_outlined,
                    size: 20,
                    color: Color(0xFF047857),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expediente de Contratación & Alta Laboral',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Postulante: ${widget.applicant.fullName} (${widget.applicant.code})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stepper de 3 Pasos
            Row(
              children: [
                _buildStepIndicator(
                    0, '1. Datos Laborales', Icons.badge_outlined),
                _buildStepDivider(),
                _buildStepIndicator(
                    1, '2. Checklist Legal', Icons.checklist_outlined),
                _buildStepDivider(),
                _buildStepIndicator(
                    2, '3. Alta en Nómina', Icons.verified_outlined),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),

            // Contenido del Paso Actual
            Expanded(
              child: switch (_currentStep) {
                0 => _buildStep1LaborData(),
                1 => _buildStep2LegalChecklist(),
                2 => _buildStep3SummaryAndConfirm(),
                _ => const SizedBox.shrink(),
              },
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),

            // Botones de Navegación del Wizard
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _currentStep--),
                    icon: const Icon(Icons.arrow_back, size: 14),
                    label: const Text('Anterior'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (_currentStep < 2)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Actualizar checklist si cambiamos de paso
                      ref
                          .read(rrhhApplicantsProvider.notifier)
                          .updateChecklist(widget.applicant.id, _checklist);
                      setState(() => _currentStep++);
                    },
                    icon: const Icon(Icons.arrow_forward, size: 14),
                    label: Text(
                      _currentStep == 0
                          ? 'Siguiente: Checklist Legal'
                          : 'Siguiente: Resumen y Alta',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _completeHiring,
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: Text(
                      'Aprobar Contratación y Dar de Alta',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title, IconData icon) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDone
                ? const Color(0xFF059669)
                : (isActive ? const Color(0xFF0D9488) : const Color(0xFFF1F5F9)),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Icon(
                  icon,
                  size: 13,
                  color: isActive ? Colors.white : const Color(0xFF64748B),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: const Color(0xFFE2E8F0),
      ),
    );
  }

  // ===========================================================================
  // PASO 1: DATOS LABORALES Y CONTRACTUALES
  // ===========================================================================
  Widget _buildStep1LaborData() {
    return ListView(
      children: [
        Text(
          'Definición de Términos Laborales e Imputación Contable',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),

        // Tipo de Personal (Oficina / Campo)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de Colaborador *',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildPillChoice(
                        label: 'Campo (Operativo)',
                        selected:
                            _workplaceType == EmployeeWorkplaceType.campo,
                        onTap: () => setState(() =>
                            _workplaceType = EmployeeWorkplaceType.campo),
                      ),
                      const SizedBox(width: 8),
                      _buildPillChoice(
                        label: 'Oficina (Administrativo)',
                        selected:
                            _workplaceType == EmployeeWorkplaceType.oficina,
                        onTap: () => setState(() =>
                            _workplaceType = EmployeeWorkplaceType.oficina),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Tipo de Contrato
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de Contrato *',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<ContractType>(
                    initialValue: _contractType,
                    isDense: true,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    items: ContractType.values.map((ct) {
                      return DropdownMenuItem(
                        value: ct,
                        child: Text(
                          ct.label,
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _contractType = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Centro de Costo y Sede Asignada
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Centro de Costo Asignado *',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _serviceLineCode,
                    isDense: true,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    items: EliteCostCenter.all.map((cc) {
                      return DropdownMenuItem(
                        value: cc,
                        child: Text(cc, style: GoogleFonts.inter(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _serviceLineCode = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Salario Base en Bs
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salario Base Acordado (Bs) *',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 38,
                    child: TextField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        prefixText: 'Bs. ',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPillChoice({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF0F766E) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PASO 2: CHECKLIST LEGAL OBLIGATORIO (BOLIVIA)
  // ===========================================================================
  Widget _buildStep2LegalChecklist() {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Documentos Obligatorios para Expediente Laboral',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _checklist.isAllCompleted
                    ? const Color(0xFFECFDF5)
                    : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _checklist.isAllCompleted
                      ? const Color(0xFFA7F3D0)
                      : const Color(0xFFFDE68A),
                ),
              ),
              child: Text(
                '${_checklist.completedCount} de 6 verificados',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _checklist.isAllCompleted
                      ? const Color(0xFF047857)
                      : const Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildCheckItem(
          title: 'Fotocopia de Cédula de Identidad (CI)',
          subtitle: 'Vigente y legible por ambos lados',
          value: _checklist.ciCopy,
          onChanged: (v) =>
              setState(() => _checklist = _checklist.copyWith(ciCopy: v)),
        ),
        _buildCheckItem(
          title: 'Factura de Servicio Básico (Luz o Agua)',
          subtitle: 'Con antigüedad menor a 90 días',
          value: _checklist.basicUtilityBill,
          onChanged: (v) => setState(
              () => _checklist = _checklist.copyWith(basicUtilityBill: v)),
        ),
        _buildCheckItem(
          title: 'Croquis de Domicilio Particular',
          subtitle: 'Ubicación clara con referencias y firma',
          value: _checklist.homeSketch,
          onChanged: (v) =>
              setState(() => _checklist = _checklist.copyWith(homeSketch: v)),
        ),
        _buildCheckItem(
          title: 'Certificado de Antecedentes FELCC',
          subtitle: 'Fuerza Especial de Lucha Contra el Crimen',
          value: _checklist.felccCertificate,
          onChanged: (v) => setState(
              () => _checklist = _checklist.copyWith(felccCertificate: v)),
        ),
        _buildCheckItem(
          title: 'Certificado de Antecedentes FELCN',
          subtitle: 'Fuerza Especial de Lucha Contra el Narcotráfico',
          value: _checklist.felcnCertificate,
          onChanged: (v) => setState(
              () => _checklist = _checklist.copyWith(felcnCertificate: v)),
        ),
        _buildCheckItem(
          title: 'Certificado de Seguro de Salud (CNS / SUS)',
          subtitle: 'Afiliación o baja patronal previa',
          value: _checklist.healthInsuranceCertificate,
          onChanged: (v) => setState(() => _checklist =
              _checklist.copyWith(healthInsuranceCertificate: v)),
        ),
      ],
    );
  }

  Widget _buildCheckItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: const Color(0xFF059669),
            onChanged: (val) => onChanged(val ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: value ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value ? 'ENTREGADO' : 'PENDIENTE',
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: value ? const Color(0xFF166534) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PASO 3: RESUMEN FINAL Y ALTA
  // ===========================================================================
  Widget _buildStep3SummaryAndConfirm() {
    final salary = double.tryParse(_salaryController.text.trim()) ??
        widget.applicant.expectedSalary;

    return ListView(
      children: [
        Text(
          'Confirmación del Expediente y Alta Institucional',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Al aprobar este trámite, el candidato será automáticamente incorporado al Directorio oficial de RRHH.',
          style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 14),

        // Resumen
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Colaborador:', widget.applicant.fullName),
              _buildSummaryRow('Cédula de Identidad:', widget.applicant.ci),
              _buildSummaryRow(
                  'Cargo Asignado:', widget.applicant.targetPosition),
              _buildSummaryRow('Tipo de Personal:', _workplaceType.label),
              _buildSummaryRow('Centro de Costo:', _serviceLineCode),
              _buildSummaryRow('Tipo de Contrato:', _contractType.label),
              _buildSummaryRow('Salario Base Mensual:',
                  'Bs. ${salary.toStringAsFixed(2)}'),
              _buildSummaryRow('Documentos Validados:',
                  '${_checklist.completedCount} de 6 entregados'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  void _completeHiring() {
    final salary = double.tryParse(_salaryController.text.trim()) ??
        widget.applicant.expectedSalary;

    // Actualizar checklist
    ref
        .read(rrhhApplicantsProvider.notifier)
        .updateChecklist(widget.applicant.id, _checklist);

    // Dar de alta en el Directorio oficial
    final empCode =
        ref.read(rrhhApplicantsProvider.notifier).approveHiringAndOnboard(
              ref: ref,
              applicantId: widget.applicant.id,
              contractType: _contractType,
              baseSalary: salary,
              serviceLineCode: _serviceLineCode,
              assignedSite: _assignedSite,
              workplaceType: _workplaceType,
            );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF047857),
        duration: const Duration(seconds: 4),
        content: Text(
          'Contratación formal aprobada. ${widget.applicant.fullName} dado de alta como $empCode en el Directorio.',
          style: GoogleFonts.inter(fontSize: 12.5),
        ),
      ),
    );
  }
}
