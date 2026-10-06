import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_hire_form_state.dart';
import 'rrhh_hire_step_contract.dart';
import 'rrhh_hire_step_documents.dart';
import 'rrhh_hire_step_labor.dart';
import 'rrhh_hire_success_dialog.dart';
import 'rrhh_hire_ui_helpers.dart';

/// Modal Wizard de Contratación Formal (Pantalla 05) de 3 pasos (Opción C Adaptativa).
class RrhhEmployeeHireWizard extends StatefulWidget {
  final RrhhApplicant? applicant;
  final VoidCallback? onCompleted;

  const RrhhEmployeeHireWizard({super.key, this.applicant, this.onCompleted});

  static Future<void> show(
    BuildContext context, {
    RrhhApplicant? applicant,
    VoidCallback? onCompleted,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhEmployeeHireWizard(
        applicant: applicant,
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  State<RrhhEmployeeHireWizard> createState() => _RrhhEmployeeHireWizardState();
}

class _RrhhEmployeeHireWizardState extends State<RrhhEmployeeHireWizard> {
  final RrhhHireFormState _formState = RrhhHireFormState();
  int _currentStep = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _hasVisitedStep2 = false;
  String? _errorMessage;

  List<RrhhArea> _areas = [];
  List<RrhhPosition> _positions = [];
  List<RrhhSpecialty> _specialties = [];
  List<RrhhSchedule> _schedules = [];
  List<String> _campoSupervisors = [
    'Ricardo Montaño (Sup. Operaciones)',
    'Juan Carlos Pérez (Líder)',
  ];
  List<String> _oficinaSupervisors = [
    'Lic. Laura Mendoza (RRHH)',
    'Ing. Roberto Paz (Administración)',
  ];

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
  }

  Future<void> _loadCatalogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final repo = RrhhRepository.current;
      final results = await Future.wait([
        repo.listAreas(),
        repo.listPositions(),
        repo.listSpecialties(),
        repo.listSchedules(),
        repo.listEmployees(),
      ]);
      _areas = results[0] as List<RrhhArea>;
      _positions = results[1] as List<RrhhPosition>;
      _specialties = results[2] as List<RrhhSpecialty>;
      _schedules = results[3] as List<RrhhSchedule>;

      final allEmps = results[4] as List<dynamic>;
      final campoSups = allEmps
          .where((e) => e.employeeType == 'CAMPO')
          .map((e) => e.fullName as String)
          .toSet()
          .toList();
      final ofiSups = allEmps
          .where((e) => e.employeeType == 'OFICINA')
          .map((e) => e.fullName as String)
          .toSet()
          .toList();
      if (campoSups.isNotEmpty) _campoSupervisors = campoSups;
      if (ofiSups.isNotEmpty) _oficinaSupervisors = ofiSups;

      if (widget.applicant != null) {
        final comp = await repo.getApplicantCompanion(
          widget.applicant!.id ?? 0,
        );
        _formState.initFromApplicant(
          widget.applicant!,
          companion: comp,
          availableAreas: _areas,
          availablePositions: _positions,
          availableSpecialties: _specialties,
        );
      } else {
        _autoSelectDefaults();
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudieron cargar los catálogos: $e';
      });
    }
  }

  void _autoSelectDefaults() {
    final empTypeUpper = _formState.employeeType.trim().toUpperCase();
    final validAreaIds = _positions
        .where((p) => p.workplaceType.trim().toUpperCase() == empTypeUpper)
        .map((p) => p.areaId)
        .toSet();
    final availAreas = _areas
        .where((a) => validAreaIds.contains(a.id))
        .toList();
    if (availAreas.isNotEmpty) _formState.selectedArea = availAreas.first;

    final availPositions = _positions
        .where(
          (p) =>
              p.workplaceType.trim().toUpperCase() == empTypeUpper &&
              (p.areaId == _formState.selectedArea?.id),
        )
        .toList();
    if (availPositions.isNotEmpty) {
      _formState.selectedPosition = availPositions.first;
      if (_formState.selectedPosition?.suggestedSalary != null) {
        _formState.agreedSalary = _formState.selectedPosition!.suggestedSalary!;
      }
    }
    if (_specialties.isNotEmpty) {
      _formState.selectedSpecialty = _specialties.first;
    }
    final schedMatch = _schedules.where(
      (s) {
        final sType = s.targetType.trim().toUpperCase();
        return sType == 'AMBOS' || sType == empTypeUpper;
      },
    ).toList();
    if (schedMatch.isNotEmpty) _formState.selectedSchedule = schedMatch.first;
    final sups = empTypeUpper == 'CAMPO'
        ? _campoSupervisors
        : _oficinaSupervisors;
    if (sups.isNotEmpty) _formState.supervisor = sups.first;
  }

  Future<void> _handleTypeChange(String newType) async {
    if (_formState.employeeType == newType) return;

    if (_hasVisitedStep2 || _currentStep > 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: Text(
            '¿Cambiar tipo de trabajador?',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF8FAFC),
            ),
          ),
          content: Text(
            'Cambiar el tipo modificará los valores del contrato y restablecerá las selecciones de área y cargo. ¿Desea continuar?',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFF94A3B8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text('Continuar y Reiniciar'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    _formState.employeeType = newType;
    _formState.resetDependentSelections();
    _autoSelectDefaults();
    setState(() {});
  }

  Future<void> _submitHiring() async {
    if (!_formState.isStep3Valid()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final employeeData = _formState.buildEmployee(
        applicantId: widget.applicant?.id,
      );
      final hiredEmployee = await RrhhRepository.current.hireApplicant(
        applicantId: widget.applicant?.id,
        employeeData: employeeData,
      );
      if (!mounted) return;
      Navigator.pop(context);
      RrhhHireSuccessDialog.show(
        context,
        employee: hiredEmployee,
        onFinished: widget.onCompleted,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Error al registrar expediente: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840, maxHeight: 720),
        child: Stack(
          children: [
            Column(
              children: [
                _buildModalHeader(),
                buildHireStepperBar(
                  currentStep: _currentStep,
                  onStepTapped: (s) => setState(() => _currentStep = s),
                ),
                const Divider(height: 1, color: Color(0xFF1E293B)),
                Expanded(child: _buildBodyContent()),
                const Divider(height: 1, color: Color(0xFF1E293B)),
                _buildBottomBar(),
              ],
            ),
            if (_isSubmitting) _buildProcessingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    final isCampo = _formState.employeeType == 'CAMPO';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.how_to_reg_outlined,
              color: Color(0xFF60A5FA),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Contratación Formal e Incorporación en Nómina',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isCampo
                            ? const Color(0xFFD97706).withValues(alpha: 0.2)
                            : const Color(0xFF2563EB).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isCampo ? 'CAMPO' : 'OFICINA',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isCampo
                              ? const Color(0xFFFBBF24)
                              : const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.applicant != null
                      ? 'Postulante seleccionado: ${widget.applicant!.fullName} (${widget.applicant!.code})'
                      : 'Alta institucional directa adaptativa',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading)
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2563EB)),
      );
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFF87171),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadCatalogs,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    final sups = _formState.employeeType == 'CAMPO'
        ? _campoSupervisors
        : _oficinaSupervisors;
    switch (_currentStep) {
      case 0:
        return RrhhHireStepLabor(
          formState: _formState,
          areas: _areas,
          positions: _positions,
          specialties: _specialties,
          schedules: _schedules,
          availableSupervisors: sups,
          onTypeChanged: _handleTypeChange,
          onChanged: () => setState(() {}),
          isDirectHire: widget.applicant == null,
        );
      case 1:
        return RrhhHireStepContract(
          formState: _formState,
          onChanged: () => setState(() {}),
        );
      case 2:
      default:
        return RrhhHireStepDocuments(
          formState: _formState,
          onChanged: () => setState(() {}),
        );
    }
  }

  Widget _buildBottomBar() {
    final isLastStep = _currentStep == 2;
    final canAdvance = _currentStep == 0
        ? _formState.isStep1Valid()
        : (_currentStep == 1
              ? _formState.isStep2Valid()
              : _formState.isStep3Valid());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back, size: 14),
              label: const Text('Anterior'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF334155)),
              ),
            )
          else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          const Spacer(),
          if (!isLastStep)
            FilledButton.icon(
              onPressed: canAdvance
                  ? () {
                      if (_currentStep == 0) _hasVisitedStep2 = true;
                      setState(() => _currentStep++);
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward, size: 14),
              label: Text(
                _currentStep == 0
                    ? 'Siguiente: Contrato y Sueldo >'
                    : 'Siguiente: Documentos >',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                disabledBackgroundColor: const Color(0xFF1E293B),
                disabledForegroundColor: const Color(0xFF64748B),
              ),
            )
          else
            FilledButton.icon(
              onPressed: canAdvance ? _submitHiring : null,
              icon: const Icon(Icons.how_to_reg, size: 15),
              label: const Text('Confirmar y Crear Expediente'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                disabledBackgroundColor: const Color(0xFF1E293B),
                disabledForegroundColor: const Color(0xFF64748B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF2563EB)),
              const SizedBox(height: 16),
              Text(
                'Creando expediente institucional...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Aprovisionando credenciales y registrando en nómina',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
