import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/models/rrhh_applicant_companion.dart';
import '../../data/models/rrhh_catalog_item.dart';
import '../../data/models/rrhh_shift.dart';
import '../extensions/rrhh_model_extensions.dart';
import '../../data/repositories/rrhh_repository.dart';
import '../widgets/rrhh_snack_bar.dart';

/// Vista completa 360° del Expediente de Contratación (FASE C).
/// Conecta la selección del candidato con la formalización contractual.
class RrhhHiringDossierDetailView extends StatefulWidget {
  final int dossierId;
  final VoidCallback? onBack;
  final void Function(String employeeCode)? onEmployeeCreated;

  const RrhhHiringDossierDetailView({
    super.key,
    required this.dossierId,
    this.onBack,
    this.onEmployeeCreated,
  });

  @override
  State<RrhhHiringDossierDetailView> createState() =>
      _RrhhHiringDossierDetailViewState();
}

class _RrhhHiringDossierDetailViewState
    extends State<RrhhHiringDossierDetailView> {
  RrhhHiringDossier? _dossier;
  bool _isLoading = true;
  bool _isSaving = false;
  final Set<int> _expandedSections = {1}; // Sección 1 abierta por defecto
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
    5: GlobalKey(),
    6: GlobalKey(),
  };

  // Estado Sección 6
  bool _s6IsConfirmed = false;
  final TextEditingController _s6NotesCtrl = TextEditingController();

  // Catálogos cargados
  List<RrhhCatalogItem> _afpItems = [];
  List<RrhhCatalogItem> _healthInsuranceItems = [];
  List<RrhhCatalogItem> _contractTypeItems = [];
  List<RrhhCatalogItem> _paymentModalityItems = [];
  List<RrhhCatalogItem> _bonusCatalogItems = [];
  List<RrhhCatalogItem> _deductionCatalogItems = [];
  List<RrhhShift> _shifts = [];
  List<RrhhBaseSchedule> _schedules = [];
  List<RrhhArea> _areas = [];
  List<RrhhPosition> _positions = [];
  List<RrhhEmployeeSummaryDto> _supervisors = [];

  // Section 2 controllers
  String? _s2AfpId;
  String? _s2AfpName;
  final TextEditingController _s2AfpNumberCtrl = TextEditingController();
  String? _s2HealthInsuranceId;
  String? _s2HealthInsuranceName;
  final TextEditingController _s2NotesCtrl = TextEditingController();

  // Section 3 controllers
  final TextEditingController _s3AddressCtrl = TextEditingController();
  String? _s3MaritalStatus;
  final TextEditingController _s3ChildrenCtrl = TextEditingController(
    text: '0',
  );
  final TextEditingController _s3EmergNameCtrl = TextEditingController();
  final TextEditingController _s3EmergPhoneCtrl = TextEditingController();
  String? _s3EmergRelation;

  // Section 4 controllers & state
  String? _s4ContractTypeId;
  String? _s4ContractTypeName;
  String _s4WorkdayType = 'Completa'; // 'Completa' | 'Parcial' | 'Por horas'
  String? _s4PaymentModalityId;
  String? _s4PaymentModalityName;
  final TextEditingController _s4BaseSalaryCtrl = TextEditingController();
  String _s4Currency = 'BOB'; // 'BOB' | 'USD'
  DateTime? _s4StartDate;
  DateTime? _s4EndDate;
  List<RrhhEmployeeBonus> _s4Bonuses = [];
  List<RrhhEmployeeDeduction> _s4Deductions = [];

  // Section 5 controllers & state
  String? _s5AreaId;
  String? _s5AreaName;
  String? _s5PositionId;
  String? _s5PositionName;
  String? _s5ShiftId;
  String? _s5ShiftName;
  String? _s5ScheduleId;
  String? _s5ScheduleName;
  final TextEditingController _s5BaseLocationCtrl = TextEditingController(
    text: 'Oficina Central Santa Cruz',
  );
  String? _s5SupervisorId;
  String? _s5SupervisorName;
  DateTime? _s5EffectiveStartDate;

  // Datos originales del postulante para rastreo de origen / pre-carga
  RrhhApplicant? _applicant;
  String? _applicantAddress;
  String? _applicantEmergName;
  String? _applicantEmergPhone;
  String? _applicantTargetArea;
  String? _applicantTargetPosition;
  String? _applicantTargetType;
  double? _applicantExpectedSalary;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadCatalogs();
    await _loadDossier();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _s2AfpNumberCtrl.dispose();
    _s2NotesCtrl.dispose();
    _s3AddressCtrl.dispose();
    _s3ChildrenCtrl.dispose();
    _s3EmergNameCtrl.dispose();
    _s3EmergPhoneCtrl.dispose();
    _s4BaseSalaryCtrl.dispose();
    _s5BaseLocationCtrl.dispose();
    _s6NotesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    final repo = RrhhRepository.current;
    final results = await Future.wait([
      repo.listCatalogItems(RrhhCatalogType.afps),
      repo.listCatalogItems(RrhhCatalogType.healthInsurances),
      repo.listCatalogItems(RrhhCatalogType.contractTypes),
      repo.listCatalogItems(RrhhCatalogType.paymentModalities),
      repo.listCatalogItems(RrhhCatalogType.bonuses),
      repo.listCatalogItems(RrhhCatalogType.deductions),
      repo.listShifts(),
      repo.listBaseSchedules(),
      repo.listAreas(),
      repo.listPositions(),
      repo.listEmployees(),
    ]);

    if (mounted) {
      setState(() {
        _afpItems = (results[0] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _healthInsuranceItems = (results[1] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _contractTypeItems = (results[2] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _paymentModalityItems = (results[3] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _bonusCatalogItems = (results[4] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _deductionCatalogItems = (results[5] as List<RrhhCatalogItem>)
            .where((i) => i.isActive)
            .toList();
        _shifts = (results[6] as List<RrhhShift>)
            .where((s) => s.isActive)
            .toList();
        _schedules = (results[7] as List<RrhhBaseSchedule>)
            .where((s) => s.isActive)
            .toList();
        _areas = (results[8] as List<RrhhArea>)
            .where((a) => a.isActive)
            .toList();
        _positions = (results[9] as List<RrhhPosition>)
            .where((p) => p.isActive)
            .toList();
        _supervisors = (results[10] as List<RrhhEmployeeSummaryDto>)
            .where((e) => e.status == 'ACTIVO')
            .toList();

        // Normalizar selecciones previas si coinciden con los catálogos recién cargados
        if (_s4ContractTypeId != null && _contractTypeItems.isNotEmpty) {
          final m = _contractTypeItems.where(
            (c) =>
                c.code == _s4ContractTypeId ||
                c.name.trim().toLowerCase() ==
                    _s4ContractTypeId!.trim().toLowerCase(),
          );
          if (m.isNotEmpty) {
            _s4ContractTypeId = m.first.code;
            _s4ContractTypeName = m.first.name;
          }
        }
        if (_s4PaymentModalityId != null && _paymentModalityItems.isNotEmpty) {
          final m = _paymentModalityItems.where(
            (p) =>
                p.code == _s4PaymentModalityId ||
                p.name.trim().toLowerCase() ==
                    _s4PaymentModalityId!.trim().toLowerCase(),
          );
          if (m.isNotEmpty) {
            _s4PaymentModalityId = m.first.code;
            _s4PaymentModalityName = m.first.name;
          }
        }
        if (_s2AfpId != null && _afpItems.isNotEmpty) {
          final m = _afpItems.where(
            (a) =>
                a.code == _s2AfpId ||
                a.name.trim().toLowerCase() == _s2AfpId!.trim().toLowerCase(),
          );
          if (m.isNotEmpty) {
            _s2AfpId = m.first.code;
            _s2AfpName = m.first.name;
          }
        }
        if (_s2HealthInsuranceId != null && _healthInsuranceItems.isNotEmpty) {
          final m = _healthInsuranceItems.where(
            (h) =>
                h.code == _s2HealthInsuranceId ||
                h.name.trim().toLowerCase() ==
                    _s2HealthInsuranceId!.trim().toLowerCase(),
          );
          if (m.isNotEmpty) {
            _s2HealthInsuranceId = m.first.code;
            _s2HealthInsuranceName = m.first.name;
          }
        }
      });
    }
  }

  void _populateSection2From(RrhhHiringDossier d) {
    _s2AfpId = d.afpId;
    _s2AfpName = d.afpName;
    if (_s2AfpId != null && _afpItems.isNotEmpty) {
      final m = _afpItems.where(
        (a) =>
            a.code == _s2AfpId ||
            a.name.trim().toLowerCase() == _s2AfpId!.trim().toLowerCase(),
      );
      if (m.isNotEmpty) {
        _s2AfpId = m.first.code;
        _s2AfpName = m.first.name;
      }
    }
    _s2AfpNumberCtrl.text = d.afpNumber ?? '';
    _s2HealthInsuranceId = d.healthInsuranceId;
    _s2HealthInsuranceName = d.healthInsuranceName;
    if (_s2HealthInsuranceId != null && _healthInsuranceItems.isNotEmpty) {
      final m = _healthInsuranceItems.where(
        (h) =>
            h.code == _s2HealthInsuranceId ||
            h.name.trim().toLowerCase() ==
                _s2HealthInsuranceId!.trim().toLowerCase(),
      );
      if (m.isNotEmpty) {
        _s2HealthInsuranceId = m.first.code;
        _s2HealthInsuranceName = m.first.name;
      }
    }
    _s2NotesCtrl.text = d.section2Notes ?? '';
  }

  void _populateSection3From(RrhhHiringDossier d) {
    _s3AddressCtrl.text = d.fullAddress ?? '';
    _s3MaritalStatus = d.maritalStatus;
    _s3ChildrenCtrl.text = (d.childrenCount ?? 0).toString();
    _s3EmergNameCtrl.text = d.emergencyContactName ?? '';
    _s3EmergPhoneCtrl.text = d.emergencyContactPhone ?? '';
    _s3EmergRelation = d.emergencyContactRelation;
  }

  void _populateSection4From(RrhhHiringDossier d) {
    _s4ContractTypeId = d.contractTypeId;
    _s4ContractTypeName = d.contractTypeName;
    if (_s4ContractTypeId != null && _contractTypeItems.isNotEmpty) {
      final m = _contractTypeItems.where(
        (c) =>
            c.code == _s4ContractTypeId ||
            c.name.trim().toLowerCase() ==
                _s4ContractTypeId!.trim().toLowerCase(),
      );
      if (m.isNotEmpty) {
        _s4ContractTypeId = m.first.code;
        _s4ContractTypeName = m.first.name;
      }
    }
    _s4WorkdayType = d.workdayType ?? 'Completa';
    _s4PaymentModalityId = d.paymentModalityId;
    _s4PaymentModalityName = d.paymentModalityName;
    if (_s4PaymentModalityId != null && _paymentModalityItems.isNotEmpty) {
      final m = _paymentModalityItems.where(
        (p) =>
            p.code == _s4PaymentModalityId ||
            p.name.trim().toLowerCase() ==
                _s4PaymentModalityId!.trim().toLowerCase(),
      );
      if (m.isNotEmpty) {
        _s4PaymentModalityId = m.first.code;
        _s4PaymentModalityName = m.first.name;
      }
    }
    _s4BaseSalaryCtrl.text = d.baseSalary != null
        ? d.baseSalary!.toStringAsFixed(0)
        : '';
    _s4Currency = d.currency;
    _s4StartDate = d.contractStartDate;
    _s4EndDate = d.contractEndDate;
    _s4Bonuses = d.bonuses != null
        ? List<RrhhEmployeeBonus>.from(d.bonuses!)
        : [];
    _s4Deductions = d.deductions != null
        ? List<RrhhEmployeeDeduction>.from(d.deductions!)
        : [];
  }

  void _populateSection5From(RrhhHiringDossier d) {
    _s5AreaId = d.areaId?.toString();
    _s5AreaName = d.areaName ?? d.targetArea;
    _s5PositionId = d.positionId?.toString();
    _s5PositionName = d.positionName ?? d.targetPosition;
    _s5ShiftId = d.shiftId;
    _s5ShiftName = d.shiftName;
    _s5ScheduleId = d.scheduleId;
    _s5ScheduleName = d.scheduleName;
    _s5BaseLocationCtrl.text =
        d.baseLocation ??
        (d.workplaceType == 'CAMPO'
            ? 'Puesto Campo / Clientes'
            : 'Oficina Central Santa Cruz');
    _s5SupervisorId = d.supervisorEmployeeId;
    _s5SupervisorName = d.supervisorName;
    _s5EffectiveStartDate = d.effectiveStartDate ?? d.contractStartDate;
  }

  Future<void> _loadDossier() async {
    setState(() => _isLoading = true);
    final d = await RrhhRepository.current.getDossierById(widget.dossierId);
    RrhhApplicant? app;
    RrhhApplicantCompanion? comp;
    if (d != null && d.applicantId != null) {
      try {
        app = await RrhhRepository.current.getApplicantById(d.applicantId!);
        comp = await RrhhRepository.current.getApplicantCompanion(
          d.applicantId!,
        );
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _dossier = d;
        _isLoading = false;

        if (app != null || comp != null) {
          _applicant = app;
          if (app != null) {
            RrhhDossierApplicantInfoRegistry.register(app);
          }
          _applicantAddress = app?.address;
          _applicantEmergName =
              comp?.evaluation.personalReferenceName ??
              app?.referencePerson ??
              app?.emergencyContact;
          _applicantEmergPhone =
              comp?.evaluation.personalReferencePhone ??
              app?.referencePhone ??
              app?.emergencyPhone;
          _applicantTargetArea = app?.targetArea;
          _applicantTargetPosition = app?.targetPosition;
          _applicantTargetType = app?.targetType;
          _applicantExpectedSalary =
              comp?.evaluation.salaryExpectation ??
              d?.applicantExpectedSalary ??
              (app != null &&
                      app.expectedSalary != null &&
                      app.expectedSalary! > 0
                  ? app.expectedSalary
                  : null);
        } else if (d != null) {
          _applicantExpectedSalary = d.applicantExpectedSalary;
        }

        if (d != null) {
          _populateSection2From(d);
          _populateSection3From(d);
          _populateSection4From(d);
          _populateSection5From(d);

          // Pre-carga automática en campos si estaban vacíos en el expediente
          if (_s3AddressCtrl.text.isEmpty &&
              _applicantAddress != null &&
              _applicantAddress!.isNotEmpty) {
            _s3AddressCtrl.text = _applicantAddress!;
          }
          if (_s3EmergNameCtrl.text.isEmpty &&
              _applicantEmergName != null &&
              _applicantEmergName!.isNotEmpty) {
            _s3EmergNameCtrl.text = _applicantEmergName!;
          }
          if (_s3EmergPhoneCtrl.text.isEmpty &&
              _applicantEmergPhone != null &&
              _applicantEmergPhone!.isNotEmpty) {
            _s3EmergPhoneCtrl.text = _applicantEmergPhone!;
          }

          if (_s5AreaId == null && _applicantTargetArea != null) {
            for (final area in _areas) {
              if (area.name.toLowerCase().contains(
                    _applicantTargetArea!.toLowerCase(),
                  ) ||
                  _applicantTargetArea!.toLowerCase().contains(
                    area.name.toLowerCase(),
                  )) {
                _s5AreaId = area.id?.toString();
                _s5AreaName = area.name;
                break;
              }
            }
          }
          if (_s5PositionId == null && _applicantTargetPosition != null) {
            for (final pos in _positions) {
              if (pos.name.toLowerCase().contains(
                    _applicantTargetPosition!.toLowerCase(),
                  ) ||
                  _applicantTargetPosition!.toLowerCase().contains(
                    pos.name.toLowerCase(),
                  )) {
                _s5PositionId = pos.id?.toString();
                _s5PositionName = pos.name;
                break;
              }
            }
          }

          if (d.closingNotes != null) _s6NotesCtrl.text = d.closingNotes!;
          if (d.status == 'cerrado' || d.section6Status == 'completa') {
            _s6IsConfirmed = true;
          }
        }
      });
    }
  }

  void _toggleSection(int section) {
    setState(() {
      if (_expandedSections.contains(section)) {
        _expandedSections.remove(section);
      } else {
        _expandedSections.add(section);
      }
    });
  }

  void _navigateToSection(int secNum) {
    setState(() {
      _expandedSections.add(secNum);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = _sectionKeys[secNum]?.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          alignment: 0.05,
        );
      }
    });
  }

  Future<void> _updateDoc(RrhhDossierDocument updated) async {
    if (_dossier == null) return;
    final docs = Map<String, RrhhDossierDocument>.from(_dossier!.documents);
    docs[updated.code] = updated;

    setState(() {
      _dossier = _dossier!.copyWith(documentChecklist: docs.values.toList());
    });

    await RrhhRepository.current.updateDossierSection1(
      _dossier!.id ?? widget.dossierId,
      docs,
    );
  }

  Future<void> _markDocumentReceived(RrhhDossierDocument doc) async {
    final updated = doc.copyWith(
      status: 'recibido',
      receivedAt: DateTime.now(),
    );
    await _updateDoc(updated);
    if (mounted) {
      RrhhSnackBar.showInfo(
        context,
        'Documento ${doc.name} marcado como Recibido',
      );
    }
  }

  Future<void> _markDocumentValidated(RrhhDossierDocument doc) async {
    final updated = doc.copyWith(
      status: 'validado',
      receivedAt: doc.receivedAt ?? DateTime.now(),
    );
    await _updateDoc(updated);
    if (mounted) {
      RrhhSnackBar.showSuccess(
        context,
        'Documento ${doc.name} Validado exitosamente',
      );
    }
  }

  Future<void> _showRejectDialog(RrhhDossierDocument doc) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Text(
          'Rechazar Documento: ${doc.code}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFEF4444),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indique el motivo obligatorio del rechazo de ${doc.name}:',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF111827),
                hintText: 'Ej: Documento ilegible, caducado o incompleto...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFEF4444)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.of(ctx).pop(controller.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Confirmar Rechazo',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (reason != null && mounted) {
      final updated = doc.copyWith(
        status: 'rechazado',
        notes: reason,
      );
      await _updateDoc(updated);
      if (mounted) {
        RrhhSnackBar.showError(
          context,
          'Documento ${doc.code} rechazado: $reason',
        );
      }
    }
  }

  Future<void> _showAttachDialog(RrhhDossierDocument doc) async {
    final suggested =
        '${doc.code.toLowerCase()}_${_dossier!.applicantCode.toLowerCase().replaceAll('-', '_')}.pdf';
    final controller = TextEditingController(text: suggested);

    final fileName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Row(
          children: [
            const Icon(Icons.attach_file, color: Color(0xFF2563EB), size: 20),
            const SizedBox(width: 8),
            Text(
              'Adjuntar archivo digital: ${doc.code}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccione o confirme el archivo digital escaneado:',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF111827),
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Color(0xFF38BDF8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.of(ctx).pop(controller.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Adjuntar Archivo',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (fileName != null && mounted) {
      final updated = doc.copyWith(
        status: doc.status == 'pendiente' ? 'recibido' : doc.status,
        receivedAt: doc.receivedAt ?? DateTime.now(),
        scannedFileUrl: fileName,
      );
      await _updateDoc(updated);
      if (mounted) {
        RrhhSnackBar.showInfo(context, 'Archivo adjuntado: $fileName');
      }
    }
  }

  Future<void> _saveSection1() async {
    if (_dossier == null) return;
    setState(() => _isSaving = true);
    await RrhhRepository.current.updateDossierSection1(
      _dossier!.id ?? widget.dossierId,
      _dossier!.documents,
    );
    await _loadDossier();
    if (mounted) {
      setState(() => _isSaving = false);
      RrhhSnackBar.showSuccess(
        context,
        'Cambios guardados en el Expediente',
      );
    }
  }

  Future<void> _completeSection1() async {
    if (_dossier == null) return;
    if (!_dossier!.areAllRequiredDocumentsValidated) {
      RrhhSnackBar.showWarning(
        context,
        'No se puede completar: faltan documentos obligatorios por validar.',
      );
      return;
    }

    setState(() => _isSaving = true);
    final updated = _dossier!.copyWith(section1Status: 'completa');
    await RrhhRepository.current.updateDossierSection1(
      updated.id ?? widget.dossierId,
      updated.documents,
      sectionStatus: 'completa',
    );
    await _loadDossier();

    if (mounted) {
      setState(() {
        _isSaving = false;
        _expandedSections.remove(1); // Colapsar sección tras completar
      });
      RrhhSnackBar.showSuccess(
        context,
        'Sección 1 completada. Puedes continuar con la Sección 2 (se habilitará en la próxima fase).',
      );
    }
  }

  Future<void> _toggleDossierStatus() async {
    if (_dossier == null) return;
    final newStatus = _dossier!.status == 'pausado' ? 'abierto' : 'pausado';
    await RrhhRepository.current.updateDossierStatus(
      _dossier!.id ?? widget.dossierId,
      newStatus,
    );
    await _loadDossier();
    if (mounted) {
      if (newStatus == 'pausado') {
        RrhhSnackBar.showWarning(context, 'Expediente pausado temporalmente');
      } else {
        RrhhSnackBar.showSuccess(context, 'Expediente reanudado');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);

    if (_isLoading) {
      return Container(
        color: bgColor,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2563EB)),
        ),
      );
    }

    if (_dossier == null) {
      return Container(
        color: bgColor,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_off_outlined,
                size: 48,
                color: Color(0xFF64748B),
              ),
              const SizedBox(height: 12),
              Text(
                'Expediente no encontrado',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Volver a Contrataciones en Curso'),
              ),
            ],
          ),
        ),
      );
    }

    final d = _dossier!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(d, isDark),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildApplicantSummaryCard(d, isDark),
                  if (d.status == 'cerrado') ...[
                    const SizedBox(height: 16),
                    _buildClosedDossierBanner(d, isDark),
                  ],
                  const SizedBox(height: 20),
                  KeyedSubtree(
                    key: _sectionKeys[1],
                    child: _buildSection1Accordion(d, isDark),
                  ),
                  const SizedBox(height: 12),
                  KeyedSubtree(
                    key: _sectionKeys[2],
                    child: _buildSection2Accordion(d, isDark),
                  ),
                  const SizedBox(height: 12),
                  KeyedSubtree(
                    key: _sectionKeys[3],
                    child: _buildSection3Accordion(d, isDark),
                  ),
                  const SizedBox(height: 12),
                  KeyedSubtree(
                    key: _sectionKeys[4],
                    child: _buildSection4Accordion(d, isDark),
                  ),
                  const SizedBox(height: 12),
                  KeyedSubtree(
                    key: _sectionKeys[5],
                    child: _buildSection5Accordion(d, isDark),
                  ),
                  const SizedBox(height: 12),
                  KeyedSubtree(
                    key: _sectionKeys[6],
                    child: _buildSection6Accordion(d, isDark),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(RrhhHiringDossier d, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF090D16) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                child: Text(
                  'Personal',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                child: Text(
                  'Contrataciones en Curso',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                d.applicantCode,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title + Action row
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: const Icon(Icons.arrow_back, size: 14),
                label: const Text('Volver a Contrataciones en Curso'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF475569),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFCBD5E1),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Expediente de Contratación — ${d.applicantName}',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildDossierStatusChip(d),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${d.applicantCode} · ${_applicantTargetArea ?? d.targetArea ?? "Área no asignada"} / ${_applicantTargetPosition ?? d.targetPosition ?? "Cargo no asignado"} (${_applicantTargetType ?? d.workplaceType ?? "CAMPO"})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                color: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF1E293B)),
                ),
                onSelected: (val) {
                  if (val == 'toggle_status') {
                    _toggleDossierStatus();
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'toggle_status',
                    child: Row(
                      children: [
                        Icon(
                          d.status == 'pausado'
                              ? Icons.play_arrow_outlined
                              : Icons.pause_circle_outline,
                          size: 16,
                          color: d.status == 'pausado'
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          d.status == 'pausado'
                              ? 'Reanudar expediente'
                              : 'Pausar expediente',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantSummaryCard(RrhhHiringDossier d, bool isDark) {
    final initials = d.applicantName.trim().isNotEmpty
        ? d.applicantName
              .trim()
              .split(' ')
              .take(2)
              .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
              .join()
        : 'P';

    final ci = _applicant?.identityCard ?? d.applicantCi;
    final phone = _applicant?.phone ?? d.applicantPhone;
    final email = (_applicant?.email != null && _applicant!.email!.isNotEmpty)
        ? _applicant!.email!
        : (d.applicantEmail ?? 'Sin correo');

    String areaName =
        _applicantTargetArea ??
        _applicant?.targetArea ??
        d.targetArea ??
        'Área no asignada';
    if (d.areaId != null) {
      for (final a in _areas) {
        if (a.id == d.areaId) {
          areaName = a.name;
          break;
        }
      }
    }
    String posName =
        _applicantTargetPosition ??
        _applicant?.targetPosition ??
        d.targetPosition ??
        'Cargo no asignado';
    if (d.positionId != null) {
      for (final p in _positions) {
        if (p.id == d.positionId) {
          posName = p.name;
          break;
        }
      }
    }
    final appDate = _applicant?.applicationDate ?? d.applicationDate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF2563EB),
                child: Text(
                  initials,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  children: [
                    _miniInfo('Cédula de Identidad', ci),
                    _miniInfo('Teléfono de Contacto', phone),
                    _miniInfo('Correo Personal', email),
                    _miniInfo('Área / Cargo', '$areaName • $posName'),
                    _miniInfo(
                      'Fecha de Postulación',
                      '${appDate.day}/${appDate.month}/${appDate.year}',
                    ),
                    _miniInfo(
                      'Paso a Seleccionado',
                      '${d.createdAt.day}/${d.createdAt.month}/${d.createdAt.year}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Progreso de Formalización: ${d.progressLabel}',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: d.completedSectionsCount >= 5
                      ? const Color(0xFF10B981)
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                ),
              ),
              const Spacer(),
              Text(
                '${(d.progressFraction * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: d.completedSectionsCount >= 5
                      ? const Color(0xFF10B981)
                      : const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: d.progressFraction,
              minHeight: 5,
              backgroundColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                d.completedSectionsCount >= 5
                    ? const Color(0xFF10B981)
                    : const Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ],
    );
  }

  Widget _buildSection1Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(1);
    final isComplete =
        d.section1Status == 'completa' || d.section1Status == 'completo';
    final isClosed = d.status == 'cerrado';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        children: [
          // Section Header (Click to toggle)
          InkWell(
            onTap: () => _toggleSection(1),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFF10B981)
                          : const Color(0xFF2563EB).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isComplete
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '1',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. Recepción de Documentos',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${d.validatedRequiredDocsCount}/${d.totalRequiredDocsCount} obligatorios validados • Checklist adaptado a perfil ${d.workplaceType}',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSectionStatusChip(d.section1Status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: d.totalRequiredDocsCount > 0
                                ? (d.validatedRequiredDocsCount /
                                          d.totalRequiredDocsCount)
                                      .clamp(0.0, 1.0)
                                : 0.0,
                            minHeight: 6,
                            backgroundColor: const Color(0xFF1E293B),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isComplete
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '${d.validatedRequiredDocsCount} de ${d.totalRequiredDocsCount} validados',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isComplete
                              ? const Color(0xFF10B981)
                              : const Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Documents Table
                  _buildDocumentsTable(d, isDark),
                  const SizedBox(height: 20),

                  // Footer Actions
                  if (!isClosed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _saveSection1,
                          icon: const Icon(Icons.save_outlined, size: 14),
                          label: const Text('Guardar cambios'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF94A3B8),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed:
                              (_isSaving ||
                                  !d.areAllRequiredDocumentsValidated ||
                                  isComplete)
                              ? null
                              : _completeSection1,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 15,
                          ),
                          label: Text(
                            isComplete
                                ? 'Sección 1 Completada'
                                : 'Marcar sección como completa',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1E293B),
                            disabledForegroundColor: const Color(0xFF475569),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentsTable(RrhhHiringDossier d, bool isDark) {
    final docsList = d.documents.values.toList();

    return Column(
      children: [
        // Header row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'DOCUMENTO',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  'REQUISITO',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 180,
                child: Text(
                  'ESTADO',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  'RECEPCIÓN',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'NOTAS / ARCHIVO',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 72,
                child: Text(
                  'ACCIONES',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docsList.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, color: Color(0xFF1E293B)),
          itemBuilder: (context, idx) {
            return _buildDocumentRow(
              docsList[idx],
              isClosed: d.status == 'cerrado',
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentRow(RrhhDossierDocument doc, {bool isClosed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Documento (Nombre + Código) — flex: 5
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    doc.code,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    doc.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Requisito — fixed 80
          SizedBox(
            width: 80,
            child: _buildRequirementChip(doc.requirementType),
          ),
          // Estado — fixed 180
          SizedBox(
            width: 180,
            child: _buildDocStatusChip(doc),
          ),
          // Fecha recepción — fixed 100
          SizedBox(
            width: 100,
            child: Text(
              doc.receivedAt != null
                  ? '${doc.receivedAt!.day.toString().padLeft(2, '0')}/${doc.receivedAt!.month.toString().padLeft(2, '0')}/${doc.receivedAt!.year}'
                  : '—',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          // Notas / Archivo — flex: 3
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (doc.scannedFileUrl != null &&
                    doc.scannedFileUrl!.isNotEmpty) ...[
                  const Icon(
                    Icons.attach_file,
                    size: 13,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Tooltip(
                      message: doc.scannedFileUrl!,
                      child: Text(
                        doc.scannedFileUrl!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF38BDF8),
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ] else if (doc.notes != null && doc.notes!.isNotEmpty) ...[
                  Flexible(
                    child: Tooltip(
                      message: doc.notes!,
                      child: Text(
                        doc.notes!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: doc.status == 'rechazado'
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFFCBD5E1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    '—',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Acciones — fixed 72 (primary icon + overflow menu)
          SizedBox(
            width: 72,
            child: isClosed
                ? const Center(
                    child: Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Primary action: contextual to document status
                      if (doc.status == 'pendiente' ||
                          doc.status == 'rechazado')
                        _actionIconButton(
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF10B981),
                          tooltip: 'Validar Documento',
                          onPressed: () => _markDocumentValidated(doc),
                        )
                      else if (doc.status == 'recibido')
                        _actionIconButton(
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF10B981),
                          tooltip: 'Validar Documento',
                          onPressed: () => _markDocumentValidated(doc),
                        ),
                      // Overflow menu with remaining actions
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                          padding: EdgeInsets.zero,
                          iconSize: 16,
                          color: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF1E293B)),
                          ),
                          onSelected: (action) {
                            switch (action) {
                              case 'recibir':
                                _markDocumentReceived(doc);
                                break;
                              case 'validar':
                                _markDocumentValidated(doc);
                                break;
                              case 'rechazar':
                                _showRejectDialog(doc);
                                break;
                              case 'adjuntar':
                                _showAttachDialog(doc);
                                break;
                            }
                          },
                          itemBuilder: (ctx) => [
                            if (doc.status == 'pendiente' ||
                                doc.status == 'rechazado')
                              PopupMenuItem(
                                value: 'recibir',
                                height: 36,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.mark_email_read_outlined,
                                      size: 15,
                                      color: Color(0xFF38BDF8),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Marcar Recibido',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (doc.status != 'validado')
                              PopupMenuItem(
                                value: 'validar',
                                height: 36,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 15,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Validar',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (doc.status != 'rechazado')
                              PopupMenuItem(
                                value: 'rechazar',
                                height: 36,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.cancel_outlined,
                                      size: 15,
                                      color: Color(0xFFEF4444),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rechazar',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            PopupMenuItem(
                              value: 'adjuntar',
                              height: 36,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.attach_file,
                                    size: 15,
                                    color: Color(0xFFA855F7),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Adjuntar Archivo',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _actionIconButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
      ),
    );
  }

  Widget _buildRequirementChip(String reqType) {
    Color bg;
    Color fg;
    String label;

    switch (reqType) {
      case 'obligatorio':
        bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        fg = const Color(0xFFF87171);
        label = 'Obligatorio';
        break;
      case 'condicional':
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
        fg = const Color(0xFFC4B5FD);
        label = 'Condicional';
        break;
      case 'no_aplica':
      default:
        bg = const Color(0xFF334155).withValues(alpha: 0.25);
        fg = const Color(0xFF94A3B8);
        label = 'No aplica';
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: fg.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _buildDocStatusChip(RrhhDossierDocument doc) {
    Color dotColor;
    String label;

    switch (doc.status) {
      case 'validado':
        dotColor = const Color(0xFF10B981);
        label = doc.validatedInRecruitment
            ? '✓ Validado en reclutamiento'
            : 'Validado';
        break;
      case 'recibido':
        dotColor = const Color(0xFF38BDF8);
        label = 'Recibido';
        break;
      case 'rechazado':
        dotColor = const Color(0xFFEF4444);
        label = 'Rechazado';
        break;
      case 'pendiente':
      default:
        dotColor = const Color(0xFFF59E0B);
        label = 'Pendiente';
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: dotColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: dotColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: dotColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionStatusChip(String status) {
    Color color;
    String label;
    final normalized = status.toLowerCase();
    switch (normalized) {
      case 'completa':
      case 'completo':
        color = const Color(0xFF10B981);
        label = 'Completa';
        break;
      case 'en_proceso':
      case 'en proceso':
        color = const Color(0xFF38BDF8);
        label = 'En proceso';
        break;
      case 'pendiente':
      default:
        color = const Color(0xFFF59E0B);
        label = 'Pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDossierStatusChip(RrhhHiringDossier d) {
    Color color;
    String label = d.dossierStatusLabel;

    if (d.status == 'cerrado') {
      color = const Color(0xFF10B981);
    } else if (d.status == 'pausado') {
      color = const Color(0xFF64748B);
    } else if (d.completedSectionsCount >= 5) {
      color = const Color(0xFF10B981);
    } else if (d.completedSectionsCount >= 3) {
      color = const Color(0xFF38BDF8);
    } else {
      color = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // ==========================================================================
  // SECCIÓN 2 — Afiliación a Seguridad Social (AFP y Caja Médica)
  // ==========================================================================

  bool get _isSection2Valid =>
      _s2AfpId != null &&
      _s2AfpNumberCtrl.text.trim().length >= 6 &&
      _s2HealthInsuranceId != null;

  Widget _buildSection2Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(2);
    final isComplete = d.section2Status == 'completa';
    final isClosed = d.status == 'cerrado';
    final isReadOnly = isComplete || isClosed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(2),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFF2563EB).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isComplete
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: Color(0xFF10B981),
                          )
                        : Text(
                            '2',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2. Afiliación a Seguridad Social (AFP y Caja Médica)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          d.afpName != null
                              ? '${d.afpName} · ${d.healthInsuranceName ?? "Sin caja"}'
                              : 'Selecciona AFP y caja médica para completar la afiliación.',
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
                  _buildSectionStatusChip(d.section2Status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AFP Dropdown
                  _buildFormLabel('AFP / Gestora *'),
                  const SizedBox(height: 6),
                  _buildDropdownField<String>(
                    value: _s2AfpId,
                    hint: 'Selecciona AFP',
                    items: _afpItems
                        .map(
                          (a) => DropdownMenuItem(
                            value: a.code,
                            child: Text(
                              a.name,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: isReadOnly
                        ? null
                        : (val) {
                            final item = _afpItems.firstWhere(
                              (a) => a.code == val,
                            );
                            setState(() {
                              _s2AfpId = val;
                              _s2AfpName = item.name;
                            });
                          },
                  ),
                  const SizedBox(height: 14),

                  // AFP Number
                  _buildFormLabel('Número de asegurado AFP *'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _s2AfpNumberCtrl,
                    hint: 'Ej: GP-1234567',
                    enabled: !isReadOnly,
                  ),
                  if (_s2AfpNumberCtrl.text.isNotEmpty &&
                      _s2AfpNumberCtrl.text.trim().length < 6)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Mínimo 6 caracteres',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: const Color(0xFFFCA5A5),
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),

                  // Health Insurance Dropdown
                  _buildFormLabel('Caja / Seguro de Salud *'),
                  const SizedBox(height: 6),
                  _buildDropdownField<String>(
                    value: _s2HealthInsuranceId,
                    hint: 'Selecciona caja o seguro',
                    items: _healthInsuranceItems
                        .map(
                          (h) => DropdownMenuItem(
                            value: h.code,
                            child: Text(
                              h.name,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: isReadOnly
                        ? null
                        : (val) {
                            final item = _healthInsuranceItems.firstWhere(
                              (h) => h.code == val,
                            );
                            setState(() {
                              _s2HealthInsuranceId = val;
                              _s2HealthInsuranceName = item.name;
                            });
                          },
                  ),
                  const SizedBox(height: 14),

                  // Notes
                  _buildFormLabel('Notas sobre la afiliación (opcional)'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _s2NotesCtrl,
                    hint: 'Ej: Pendiente de actualización de datos...',
                    maxLines: 2,
                    enabled: !isReadOnly,
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  if (!isReadOnly)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _saveSection2Draft,
                          icon: const Icon(Icons.save_outlined, size: 14),
                          label: Text(
                            'Guardar borrador',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF94A3B8),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _isSection2Valid && !_isSaving
                              ? _markSection2Complete
                              : null,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 14,
                          ),
                          label: Text(
                            'Marcar sección como completa',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF334155),
                            disabledForegroundColor: const Color(0xFF64748B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveSection2Draft() async {
    if (_dossier == null) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection2(
        _dossier!.id ?? widget.dossierId,
        afpId: _s2AfpId,
        afpName: _s2AfpName,
        afpNumber: _s2AfpNumberCtrl.text.trim(),
        healthInsuranceId: _s2HealthInsuranceId,
        healthInsuranceName: _s2HealthInsuranceName,
        section2Notes: _s2NotesCtrl.text.trim(),
        sectionStatus: 'en_proceso',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showInfo(
          context,
          'Sección 2 guardada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _markSection2Complete() async {
    if (_dossier == null || !_isSection2Valid) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection2(
        _dossier!.id ?? widget.dossierId,
        afpId: _s2AfpId,
        afpName: _s2AfpName,
        afpNumber: _s2AfpNumberCtrl.text.trim(),
        healthInsuranceId: _s2HealthInsuranceId,
        healthInsuranceName: _s2HealthInsuranceName,
        section2Notes: _s2NotesCtrl.text.trim(),
        sectionStatus: 'completa',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showSuccess(
          context,
          '✅ Sección 2 completada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ==========================================================================
  // SECCIÓN 3 — Datos Personales Complementarios y Contacto de Emergencia
  // ==========================================================================

  static const List<String> _maritalStatusOptions = [
    'Soltero',
    'Casado',
    'Divorciado',
    'Viudo',
    'Unión Libre',
  ];

  static const List<String> _relationOptions = [
    'Cónyuge',
    'Madre',
    'Padre',
    'Hermano/a',
    'Hijo/a',
    'Tío/a',
    'Abuelo/a',
    'Amigo/a',
    'Otro',
  ];

  bool get _isSection3Valid =>
      _s3AddressCtrl.text.trim().isNotEmpty &&
      _s3MaritalStatus != null &&
      _s3EmergNameCtrl.text.trim().isNotEmpty &&
      _s3EmergPhoneCtrl.text.trim().length == 8 &&
      _s3EmergRelation != null;

  Widget _buildSection3Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(3);
    final isComplete = d.section3Status == 'completa';
    final isClosed = d.status == 'cerrado';
    final isReadOnly = isComplete || isClosed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(3),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFF2563EB).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isComplete
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: Color(0xFF10B981),
                          )
                        : Text(
                            '3',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3. Datos Personales Complementarios y Contacto de Emergencia',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          d.fullAddress != null
                              ? '${d.maritalStatus ?? ""} · ${d.emergencyContactName ?? "Sin contacto"}'
                              : 'Completa los datos personales y de emergencia.',
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
                  _buildSectionStatusChip(d.section3Status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bloque A: Datos personales ──
                  Text(
                    'DATOS PERSONALES',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Address
                  _buildFormLabel(
                    'Dirección completa *',
                    isPreloaded:
                        _applicantAddress != null &&
                        _applicantAddress!.isNotEmpty,
                    isEdited:
                        _applicantAddress != null &&
                        _applicantAddress!.isNotEmpty &&
                        _s3AddressCtrl.text.trim() != _applicantAddress!.trim(),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _s3AddressCtrl,
                    hint: 'Barrio Sirari, C/ Las Begonias #24, Santa Cruz',
                    enabled: !isReadOnly,
                  ),
                  const SizedBox(height: 14),

                  // Marital Status + Children in a row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Estado civil *'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s3MaritalStatus,
                              hint: 'Seleccionar',
                              items: _maritalStatusOptions
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) =>
                                        setState(() => _s3MaritalStatus = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Nº de hijos'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _s3ChildrenCtrl,
                              hint: '0',
                              enabled: !isReadOnly,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque B: Contacto de emergencia ──
                  Text(
                    'CONTACTO DE EMERGENCIA',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name + Phone in a row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel(
                              'Nombre del contacto *',
                              isPreloaded:
                                  _applicantEmergName != null &&
                                  _applicantEmergName!.isNotEmpty,
                              isEdited:
                                  _applicantEmergName != null &&
                                  _applicantEmergName!.isNotEmpty &&
                                  _s3EmergNameCtrl.text.trim() !=
                                      _applicantEmergName!.trim(),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _s3EmergNameCtrl,
                              hint: 'Nombre completo',
                              enabled: !isReadOnly,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel(
                              'Teléfono *',
                              isPreloaded:
                                  _applicantEmergPhone != null &&
                                  _applicantEmergPhone!.isNotEmpty,
                              isEdited:
                                  _applicantEmergPhone != null &&
                                  _applicantEmergPhone!.isNotEmpty &&
                                  _s3EmergPhoneCtrl.text.trim() !=
                                      _applicantEmergPhone!.trim(),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _s3EmergPhoneCtrl,
                              hint: '77712345',
                              enabled: !isReadOnly,
                              keyboardType: TextInputType.phone,
                            ),
                            if (_s3EmergPhoneCtrl.text.isNotEmpty &&
                                _s3EmergPhoneCtrl.text.trim().length != 8)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '8 dígitos requeridos',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFFFCA5A5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Relation dropdown
                  _buildFormLabel('Parentesco *'),
                  const SizedBox(height: 6),
                  _buildDropdownField<String>(
                    value: _s3EmergRelation,
                    hint: 'Seleccionar parentesco',
                    items: _relationOptions
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: isReadOnly
                        ? null
                        : (val) => setState(() => _s3EmergRelation = val),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  if (!isReadOnly)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _saveSection3Draft,
                          icon: const Icon(Icons.save_outlined, size: 14),
                          label: Text(
                            'Guardar borrador',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF94A3B8),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _isSection3Valid && !_isSaving
                              ? _markSection3Complete
                              : null,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 14,
                          ),
                          label: Text(
                            'Marcar sección como completa',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF334155),
                            disabledForegroundColor: const Color(0xFF64748B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveSection3Draft() async {
    if (_dossier == null) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection3(
        _dossier!.id ?? widget.dossierId,
        fullAddress: _s3AddressCtrl.text.trim(),
        maritalStatus: _s3MaritalStatus,
        childrenCount: int.tryParse(_s3ChildrenCtrl.text) ?? 0,
        emergencyContactName: _s3EmergNameCtrl.text.trim(),
        emergencyContactPhone: _s3EmergPhoneCtrl.text.trim(),
        emergencyContactRelation: _s3EmergRelation,
        sectionStatus: 'en_proceso',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showInfo(
          context,
          'Sección 3 guardada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _markSection3Complete() async {
    if (_dossier == null || !_isSection3Valid) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection3(
        _dossier!.id ?? widget.dossierId,
        fullAddress: _s3AddressCtrl.text.trim(),
        maritalStatus: _s3MaritalStatus,
        childrenCount: int.tryParse(_s3ChildrenCtrl.text) ?? 0,
        emergencyContactName: _s3EmergNameCtrl.text.trim(),
        emergencyContactPhone: _s3EmergPhoneCtrl.text.trim(),
        emergencyContactRelation: _s3EmergRelation,
        sectionStatus: 'completa',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showSuccess(
          context,
          '✅ Sección 3 completada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ==========================================================================
  // SECCIÓN 4 — Condiciones Contractuales y Modalidad de Pago
  // ==========================================================================

  bool get _isContractTemporary {
    if (_s4ContractTypeName == null) return false;
    final name = _s4ContractTypeName!.toLowerCase();
    return name.contains('temporal') ||
        name.contains('obra') ||
        name.contains('plazo fijo') ||
        name.contains('determinado') ||
        name.contains('eventual');
  }

  bool get _isSection4Valid {
    if (_s4ContractTypeId == null) return false;
    if (_s4StartDate == null) return false;
    if (_isContractTemporary) {
      if (_s4EndDate == null) return false;
      if (!_s4EndDate!.isAfter(_s4StartDate!)) return false;
    }
    if (_s4PaymentModalityId == null) return false;
    final salary = double.tryParse(_s4BaseSalaryCtrl.text.trim()) ?? 0;
    if (salary <= 0) return false;
    return true;
  }

  Future<void> _saveSection4Draft() async {
    if (_dossier == null) return;
    setState(() => _isSaving = true);
    try {
      final salary = double.tryParse(_s4BaseSalaryCtrl.text.trim());
      final updated = await RrhhRepository.current.updateDossierSection4(
        _dossier!.id ?? widget.dossierId,
        contractTypeId: _s4ContractTypeId,
        contractTypeName: _s4ContractTypeName,
        workdayType: _s4WorkdayType,
        paymentModalityId: _s4PaymentModalityId,
        paymentModalityName: _s4PaymentModalityName,
        baseSalary: salary,
        currency: _s4Currency,
        contractStartDate: _s4StartDate,
        contractEndDate: _isContractTemporary ? _s4EndDate : null,
        bonuses: _s4Bonuses,
        deductions: _s4Deductions,
        sectionStatus: _dossier!.section4Status == 'completa'
            ? 'completa'
            : 'en_proceso',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showInfo(
          context,
          'Borrador de Sección 4 guardado',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _completeSection4() async {
    if (_dossier == null || !_isSection4Valid) return;
    setState(() => _isSaving = true);
    try {
      final salary = double.tryParse(_s4BaseSalaryCtrl.text.trim());
      final updated = await RrhhRepository.current.updateDossierSection4(
        _dossier!.id ?? widget.dossierId,
        contractTypeId: _s4ContractTypeId,
        contractTypeName: _s4ContractTypeName,
        workdayType: _s4WorkdayType,
        paymentModalityId: _s4PaymentModalityId,
        paymentModalityName: _s4PaymentModalityName,
        baseSalary: salary,
        currency: _s4Currency,
        contractStartDate: _s4StartDate,
        contractEndDate: _isContractTemporary ? _s4EndDate : null,
        bonuses: _s4Bonuses,
        deductions: _s4Deductions,
        sectionStatus: 'completa',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showSuccess(
          context,
          '✅ Sección 4 completada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showAddCustomBonusDialog() async {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '200');
    String type = 'Fija mensual';
    bool isPercentage = false;

    final result = await showDialog<RrhhEmployeeBonus>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF1E293B)),
              ),
              title: Text(
                'Agregar Bonificación Personalizada',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
              content: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('Concepto del bono *'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: nameCtrl,
                      hint: 'Ej: Bono de Productividad Extra',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('Monto *'),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: amountCtrl,
                                hint: '0.00',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('Tipo'),
                              const SizedBox(height: 6),
                              _buildDropdownField<String>(
                                value: type,
                                hint: 'Tipo',
                                items:
                                    ['Fija mensual', 'Por evento', 'Variable']
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(
                                              t,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setDlgState(() => type = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () =>
                          setDlgState(() => isPercentage = !isPercentage),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isPercentage,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (v) =>
                                setDlgState(() => isPercentage = v ?? false),
                          ),
                          Text(
                            'El valor representa un porcentaje (%)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    if (name.isEmpty || amt <= 0) return;
                    Navigator.of(ctx).pop(
                      RrhhEmployeeBonus(
                        code:
                            'BONO-CUSTOM-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        name: name,
                        type: type,
                        amount: amt,
                        isPercentage: isPercentage,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Agregar',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _s4Bonuses.add(result);
      });
    }
  }

  Future<void> _showAddCustomDeductionDialog() async {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '100');
    String type = 'Fijo';
    bool isPercentage = false;

    final result = await showDialog<RrhhEmployeeDeduction>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF1E293B)),
              ),
              title: Text(
                'Agregar Descuento Personalizado',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
              content: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('Concepto del descuento *'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: nameCtrl,
                      hint: 'Ej: Préstamo Empresarial Interno',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('Monto *'),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: amountCtrl,
                                hint: '0.00',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('Tipo'),
                              const SizedBox(height: 6),
                              _buildDropdownField<String>(
                                value: type,
                                hint: 'Tipo',
                                items: ['Fijo', 'Porcentaje', 'Por evento']
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          t,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setDlgState(() => type = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () =>
                          setDlgState(() => isPercentage = !isPercentage),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isPercentage,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (v) =>
                                setDlgState(() => isPercentage = v ?? false),
                          ),
                          Text(
                            'El valor representa un porcentaje (%)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    if (name.isEmpty || amt <= 0) return;
                    Navigator.of(ctx).pop(
                      RrhhEmployeeDeduction(
                        code:
                            'DESC-CUSTOM-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        name: name,
                        type: type,
                        amount: amt,
                        isPercentage: isPercentage,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Agregar',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _s4Deductions.add(result);
      });
    }
  }

  Widget _buildSection4Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(4);
    final isComplete = d.section4Status == 'completa';
    final isClosed = d.status == 'cerrado';
    final isReadOnly = isComplete || isClosed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(4),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFF2563EB).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isComplete
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: Color(0xFF10B981),
                          )
                        : Text(
                            '4',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4. Condiciones Contractuales y Modalidad de Pago',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          d.contractTypeName != null
                              ? '${d.contractTypeName} (${d.workdayType ?? "Completa"}) · ${d.currency} ${d.baseSalary != null ? d.baseSalary!.toStringAsFixed(0) : "0"} · ${d.paymentModalityName ?? "Sin modalidad"}'
                              : 'Define tipo de contrato, jornada laboral, fechas, salario y bonificaciones.',
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
                  _buildSectionStatusChip(d.section4Status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bloque A: Tipo de contrato y jornada ──
                  Text(
                    'BLOQUE A — TIPO DE CONTRATO Y JORNADA',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Tipo de contrato *'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s4ContractTypeId,
                              hint: 'Seleccionar tipo de contrato',
                              items: _contractTypeItems
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.code,
                                      child: Text(
                                        c.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      final item = _contractTypeItems
                                          .firstWhere((c) => c.code == val);
                                      setState(() {
                                        _s4ContractTypeId = val;
                                        _s4ContractTypeName = item.name;
                                        if (!_isContractTemporary) {
                                          _s4EndDate = null;
                                        }
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Jornada laboral *'),
                            const SizedBox(height: 6),
                            _buildWorkdaySelector(!isReadOnly),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque B: Vigencia ──
                  Text(
                    'BLOQUE B — VIGENCIA DEL CONTRATO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDateField(
                          context: context,
                          label: 'Fecha de inicio de contrato *',
                          value: _s4StartDate,
                          enabled: !isReadOnly,
                          onDateSelected: (picked) {
                            setState(() {
                              _s4StartDate = picked;
                              if (_s5EffectiveStartDate == null ||
                                  _s5EffectiveStartDate!.isBefore(picked)) {
                                _s5EffectiveStartDate = picked;
                              }
                            });
                          },
                        ),
                      ),
                      if (_isContractTemporary) ...[
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildDateField(
                            context: context,
                            label: 'Fecha de fin de contrato *',
                            value: _s4EndDate,
                            enabled: !isReadOnly,
                            firstDate: _s4StartDate ?? DateTime(2020),
                            errorText:
                                (_s4EndDate != null &&
                                    _s4StartDate != null &&
                                    !_s4EndDate!.isAfter(_s4StartDate!))
                                ? 'Debe ser posterior a la fecha de inicio'
                                : null,
                            onDateSelected: (picked) {
                              setState(() => _s4EndDate = picked);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque C: Salario y modalidad ──
                  Text(
                    'BLOQUE C — SALARIO Y MODALIDAD DE PAGO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Modalidad de pago *'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s4PaymentModalityId,
                              hint: 'Seleccionar modalidad',
                              items: _paymentModalityItems
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p.code,
                                      child: Text(
                                        p.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      final item = _paymentModalityItems
                                          .firstWhere((p) => p.code == val);
                                      setState(() {
                                        _s4PaymentModalityId = val;
                                        _s4PaymentModalityName = item.name;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel(
                              'Salario base acordado *',
                              subtitleSuggestion:
                                  (_applicantExpectedSalary != null &&
                                      _applicantExpectedSalary! > 0)
                                  ? 'Sugerencia basada en pretensión: Bs. ${_applicantExpectedSalary!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _s4BaseSalaryCtrl,
                              hint: 'Ej: 3500',
                              enabled: !isReadOnly,
                              keyboardType: TextInputType.number,
                            ),
                            if (_s4BaseSalaryCtrl.text.isNotEmpty &&
                                (double.tryParse(
                                          _s4BaseSalaryCtrl.text.trim(),
                                        ) ??
                                        0) <=
                                    0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'El salario debe ser mayor a 0',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFFFCA5A5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Moneda'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s4Currency,
                              hint: 'BOB',
                              items: ['BOB', 'USD']
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        setState(() => _s4Currency = val);
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque D: Bonificaciones autorizadas ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BLOQUE D — BONIFICACIONES AUTORIZADAS (OPCIONAL)',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Marca las bonificaciones que apliquen al postulante',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      if (!isReadOnly)
                        TextButton.icon(
                          onPressed: _showAddCustomBonusDialog,
                          icon: const Icon(Icons.add, size: 14),
                          label: Text(
                            'Bonificación personalizada',
                            style: GoogleFonts.inter(fontSize: 11.5),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF38BDF8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildBonusesSection(isReadOnly),
                  const SizedBox(height: 22),

                  // ── Bloque E: Descuentos autorizados ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BLOQUE E — DESCUENTOS AUTORIZADOS (OPCIONAL)',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Deducciones y aportes regulares asignados',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      if (!isReadOnly)
                        TextButton.icon(
                          onPressed: _showAddCustomDeductionDialog,
                          icon: const Icon(Icons.add, size: 14),
                          label: Text(
                            'Descuento personalizado',
                            style: GoogleFonts.inter(fontSize: 11.5),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF38BDF8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildDeductionsSection(isReadOnly),
                  const SizedBox(height: 22),

                  // Action buttons
                  if (!isReadOnly)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _saveSection4Draft,
                          icon: const Icon(Icons.save_outlined, size: 14),
                          label: Text(
                            'Guardar borrador',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF94A3B8),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: (_isSaving || !_isSection4Valid)
                              ? null
                              : _completeSection4,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 15,
                          ),
                          label: Text(
                            'Marcar sección como completa',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1E293B),
                            disabledForegroundColor: const Color(0xFF475569),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '✅ Sección 4 completada y registrada en el expediente.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _dossier = _dossier!.copyWith(
                                section4Status: 'en_proceso',
                              );
                            });
                          },
                          icon: const Icon(Icons.edit_outlined, size: 13),
                          label: Text(
                            'Modificar sección',
                            style: GoogleFonts.inter(fontSize: 11.5),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF38BDF8),
                            side: const BorderSide(color: Color(0xFF1E293B)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkdaySelector(bool enabled) {
    final options = ['Completa', 'Parcial', 'Por horas'];
    return Row(
      children: options.map((opt) {
        final isSelected = _s4WorkdayType == opt;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: enabled
                  ? () => setState(() => _s4WorkdayType = opt)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                      : const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF1E293B),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  opt,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBonusesSection(bool isComplete) {
    if (_bonusCatalogItems.isEmpty && _s4Bonuses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Text(
          'No hay bonificaciones disponibles en el catálogo.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
      );
    }

    final allItems =
        <({String code, String name, String type, double? defaultAmt})>[];
    for (final c in _bonusCatalogItems) {
      allItems.add((
        code: c.code,
        name: c.name,
        type: c.subType ?? 'Fija mensual',
        defaultAmt: c.defaultAmount,
      ));
    }
    // Also include custom bonuses not in catalog
    for (final b in _s4Bonuses) {
      if (!allItems.any((it) => it.code == b.code)) {
        allItems.add((
          code: b.code,
          name: b.name,
          type: b.type,
          defaultAmt: b.amount,
        ));
      }
    }

    return Column(
      children: allItems.map((item) {
        final existingIdx = _s4Bonuses.indexWhere((b) => b.code == item.code);
        final isSelected = existingIdx != -1;
        final selectedBonus = isSelected ? _s4Bonuses[existingIdx] : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF131C2E)
                : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB).withValues(alpha: 0.4)
                  : const Color(0xFF1E293B),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: isComplete
                        ? null
                        : (val) {
                            setState(() {
                              if (val == true) {
                                _s4Bonuses.add(
                                  RrhhEmployeeBonus(
                                    code: item.code,
                                    name: item.name,
                                    type: item.type,
                                    amount: item.defaultAmt ?? 250.0,
                                    isPercentage: false,
                                  ),
                                );
                              } else {
                                _s4Bonuses.removeWhere(
                                  (b) => b.code == item.code,
                                );
                              }
                            });
                          },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        Text(
                          'Tipo base: ${item.type} · Ref: ${item.code}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected && selectedBonus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        selectedBonus.isPercentage
                            ? '${selectedBonus.amount ?? 0}%'
                            : 'Bs. ${(selectedBonus.amount ?? 0).toStringAsFixed(0)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                ],
              ),
              if (isSelected && selectedBonus != null && !isComplete) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFF1E293B)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 120,
                      height: 34,
                      child: TextField(
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Monto',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF94A3B8),
                          ),
                          prefixText: selectedBonus.isPercentage
                              ? '% '
                              : 'Bs. ',
                          prefixStyle: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        controller:
                            TextEditingController(
                                text: (selectedBonus.amount ?? 0)
                                    .toStringAsFixed(0),
                              )
                              ..selection = TextSelection.collapsed(
                                offset: (selectedBonus.amount ?? 0)
                                    .toStringAsFixed(0)
                                    .length,
                              ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final n = double.tryParse(val) ?? 0;
                          selectedBonus.amount = n;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedBonus.type,
                          dropdownColor: const Color(0xFF0F172A),
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Frecuencia',
                            labelStyle: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF94A3B8),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          items: ['Fija mensual', 'Por evento', 'Variable']
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedBonus.type = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeductionsSection(bool isComplete) {
    if (_deductionCatalogItems.isEmpty && _s4Deductions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Text(
          'No hay deducciones disponibles en el catálogo.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
      );
    }

    final allItems = <({String code, String name, String type})>[];
    for (final c in _deductionCatalogItems) {
      allItems.add((
        code: c.code,
        name: c.name,
        type: c.subType ?? 'Fijo',
      ));
    }
    for (final d in _s4Deductions) {
      if (!allItems.any((it) => it.code == d.code)) {
        allItems.add((
          code: d.code,
          name: d.name,
          type: d.type,
        ));
      }
    }

    return Column(
      children: allItems.map((item) {
        final existingIdx = _s4Deductions.indexWhere(
          (d) => d.code == item.code,
        );
        final isSelected = existingIdx != -1;
        final selectedDed = isSelected ? _s4Deductions[existingIdx] : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF131C2E)
                : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                  : const Color(0xFF1E293B),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    activeColor: const Color(0xFFEF4444),
                    onChanged: isComplete
                        ? null
                        : (val) {
                            setState(() {
                              if (val == true) {
                                _s4Deductions.add(
                                  RrhhEmployeeDeduction(
                                    code: item.code,
                                    name: item.name,
                                    type: item.type,
                                    amount: 100.0,
                                    isPercentage: item.type
                                        .toLowerCase()
                                        .contains('porcent'),
                                  ),
                                );
                              } else {
                                _s4Deductions.removeWhere(
                                  (d) => d.code == item.code,
                                );
                              }
                            });
                          },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        Text(
                          'Tipo base: ${item.type} · Ref: ${item.code}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected && selectedDed != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        selectedDed.isPercentage
                            ? '-${selectedDed.amount ?? 0}%'
                            : '-Bs. ${(selectedDed.amount ?? 0).toStringAsFixed(0)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF87171),
                        ),
                      ),
                    ),
                ],
              ),
              if (isSelected && selectedDed != null && !isComplete) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFF1E293B)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 120,
                      height: 34,
                      child: TextField(
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Monto',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF94A3B8),
                          ),
                          prefixText: selectedDed.isPercentage ? '% ' : 'Bs. ',
                          prefixStyle: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        controller:
                            TextEditingController(
                                text: (selectedDed.amount ?? 0).toStringAsFixed(
                                  0,
                                ),
                              )
                              ..selection = TextSelection.collapsed(
                                offset: (selectedDed.amount ?? 0)
                                    .toStringAsFixed(0)
                                    .length,
                              ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final n = double.tryParse(val) ?? 0;
                          selectedDed.amount = n;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedDed.type,
                          dropdownColor: const Color(0xFF0F172A),
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Tipo',
                            labelStyle: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF94A3B8),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          items: ['Fijo', 'Porcentaje', 'Por evento']
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedDed.type = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==========================================================================
  // SECCIÓN 5 — Asignación Organizacional, Turno y Sede Base
  // ==========================================================================

  bool get _isSection5Valid {
    if (_s5AreaId == null) return false;
    if (_s5PositionId == null) return false;
    if (_s5ShiftId == null) return false;
    if (_s5BaseLocationCtrl.text.trim().isEmpty) return false;
    if (_s5EffectiveStartDate == null) return false;
    if (_s4StartDate != null) {
      final s4Ymd = DateTime(
        _s4StartDate!.year,
        _s4StartDate!.month,
        _s4StartDate!.day,
      );
      final s5Ymd = DateTime(
        _s5EffectiveStartDate!.year,
        _s5EffectiveStartDate!.month,
        _s5EffectiveStartDate!.day,
      );
      if (s5Ymd.isBefore(s4Ymd)) return false;
    }
    return true;
  }

  Future<void> _saveSection5Draft() async {
    if (_dossier == null) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection5(
        _dossier!.id ?? widget.dossierId,
        areaId: _s5AreaId,
        areaName: _s5AreaName,
        positionId: _s5PositionId,
        positionName: _s5PositionName,
        shiftId: _s5ShiftId,
        shiftName: _s5ShiftName,
        scheduleId: _s5ScheduleId,
        scheduleName: _s5ScheduleName,
        baseLocation: _s5BaseLocationCtrl.text.trim(),
        supervisorEmployeeId: _s5SupervisorId,
        supervisorName: _s5SupervisorName,
        effectiveStartDate: _s5EffectiveStartDate,
        sectionStatus: _dossier!.section5Status == 'completa'
            ? 'completa'
            : 'en_proceso',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showInfo(
          context,
          'Borrador de Sección 5 guardado',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _completeSection5() async {
    if (_dossier == null || !_isSection5Valid) return;
    setState(() => _isSaving = true);
    try {
      final updated = await RrhhRepository.current.updateDossierSection5(
        _dossier!.id ?? widget.dossierId,
        areaId: _s5AreaId,
        areaName: _s5AreaName,
        positionId: _s5PositionId,
        positionName: _s5PositionName,
        shiftId: _s5ShiftId,
        shiftName: _s5ShiftName,
        scheduleId: _s5ScheduleId,
        scheduleName: _s5ScheduleName,
        baseLocation: _s5BaseLocationCtrl.text.trim(),
        supervisorEmployeeId: _s5SupervisorId,
        supervisorName: _s5SupervisorName,
        effectiveStartDate: _s5EffectiveStartDate,
        sectionStatus: 'completa',
      );
      if (mounted) {
        setState(() => _dossier = updated);
        RrhhSnackBar.showSuccess(
          context,
          '✅ Sección 5 completada',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildSection5Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(5);
    final isComplete = d.section5Status == 'completa';
    final isClosed = d.status == 'cerrado';
    final isReadOnly = isComplete || isClosed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(5),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFF2563EB).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isComplete
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: Color(0xFF10B981),
                          )
                        : Text(
                            '5',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5. Asignación Organizacional, Turno y Sede Base',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          d.areaName != null
                              ? '${d.areaName} / ${d.positionName ?? ""} · ${d.shiftName ?? "Sin turno"} · ${d.baseLocation ?? ""}'
                              : 'Asigna área, cargo, turno laboral, horario base, sede y supervisor.',
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
                  _buildSectionStatusChip(d.section5Status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bloque A: Área y Cargo ──
                  Text(
                    'BLOQUE A — ÁREA Y CARGO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel(
                              'Área de la empresa *',
                              isPreloaded:
                                  _applicantTargetArea != null &&
                                  _applicantTargetArea!.isNotEmpty,
                              isEdited:
                                  _applicantTargetArea != null &&
                                  _applicantTargetArea!.isNotEmpty &&
                                  (_s5AreaName != null &&
                                      !_s5AreaName!.toLowerCase().contains(
                                        _applicantTargetArea!.toLowerCase(),
                                      )),
                            ),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s5AreaId,
                              hint: 'Seleccionar área',
                              items: _areas
                                  .map(
                                    (a) => DropdownMenuItem(
                                      value: a.id?.toString(),
                                      child: Text(
                                        a.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      final area = _areas.firstWhere(
                                        (a) => a.id?.toString() == val,
                                      );
                                      setState(() {
                                        _s5AreaId = val;
                                        _s5AreaName = area.name;
                                        // Reset position if not matching new area
                                        final availablePositions = _positions
                                            .where(
                                              (p) => p.areaId.toString() == val,
                                            )
                                            .toList();
                                        if (!availablePositions.any(
                                          (p) =>
                                              p.id?.toString() == _s5PositionId,
                                        )) {
                                          _s5PositionId = null;
                                          _s5PositionName = null;
                                        }
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel(
                              'Cargo asignado *',
                              isPreloaded:
                                  _applicantTargetPosition != null &&
                                  _applicantTargetPosition!.isNotEmpty,
                              isEdited:
                                  _applicantTargetPosition != null &&
                                  _applicantTargetPosition!.isNotEmpty &&
                                  (_s5PositionName != null &&
                                      !_s5PositionName!.toLowerCase().contains(
                                        _applicantTargetPosition!.toLowerCase(),
                                      )),
                            ),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s5PositionId,
                              hint: _s5AreaId == null
                                  ? 'Primero selecciona un área'
                                  : 'Seleccionar cargo',
                              items: _positions
                                  .where(
                                    (p) =>
                                        _s5AreaId == null ||
                                        p.areaId.toString() == _s5AreaId,
                                  )
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p.id?.toString(),
                                      child: Text(
                                        '${p.name} (${p.workplaceType})',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (isReadOnly || _s5AreaId == null)
                                  ? null
                                  : (val) {
                                      final pos = _positions.firstWhere(
                                        (p) => p.id?.toString() == val,
                                      );
                                      setState(() {
                                        _s5PositionId = val;
                                        _s5PositionName = pos.name;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque B: Turno y horario ──
                  Text(
                    'BLOQUE B — TURNO Y HORARIO LABORAL',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Turno de trabajo *'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _s5ShiftId,
                              hint: 'Seleccionar turno',
                              items: _shifts
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s.id.toString(),
                                      child: Text(
                                        '${s.name} (${s.formattedTimeRange}) · ${s.shiftType}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      final shift = _shifts.firstWhere(
                                        (s) => s.id.toString() == val,
                                      );
                                      setState(() {
                                        _s5ShiftId = val;
                                        _s5ShiftName =
                                            '${shift.name} (${shift.formattedTimeRange})';
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Horario base (opcional)'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String?>(
                              value: _s5ScheduleId,
                              hint: '(Opcional) Usar turno como horario',
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(
                                    '(Opcional) Usar horario base del turno',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                ..._schedules.map(
                                  (sc) => DropdownMenuItem<String?>(
                                    value: sc.id.toString(),
                                    child: Text(
                                      '${sc.name} (${sc.totalWeeklyHours.toStringAsFixed(0)}h/sem)',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      setState(() {
                                        _s5ScheduleId = val;
                                        _s5ScheduleName = val != null
                                            ? _schedules
                                                  .firstWhere(
                                                    (sc) =>
                                                        sc.id.toString() == val,
                                                  )
                                                  .name
                                            : null;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Bloque C: Ubicación, supervisor y fecha de ingreso ──
                  Text(
                    'BLOQUE C — UBICACIÓN, SUPERVISOR Y FECHA DE INGRESO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildFormLabel('Sede / Ubicación base *'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _s5BaseLocationCtrl,
                    hint:
                        'Ej: Oficina Central Santa Cruz, Sede Norte, Cliente X',
                    enabled: !isReadOnly,
                  ),
                  const SizedBox(height: 6),
                  // Quick chips for base location
                  if (!isReadOnly)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          [
                            'Oficina Central Santa Cruz',
                            'Sede Norte',
                            'Sucursal Montero',
                            'Puesto Cliente - Campo',
                          ].map((loc) {
                            return InkWell(
                              onTap: () => setState(
                                () => _s5BaseLocationCtrl.text = loc,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                child: Text(
                                  loc,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Supervisor directo (opcional)'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String?>(
                              value: _s5SupervisorId,
                              hint: '(Sin supervisor directo)',
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(
                                    '(Sin supervisor directo)',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                ..._supervisors.map(
                                  (e) => DropdownMenuItem<String?>(
                                    value: e.id.toString(),
                                    child: Text(
                                      '${e.fullName} (${e.position})',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: isReadOnly
                                  ? null
                                  : (val) {
                                      setState(() {
                                        _s5SupervisorId = val;
                                        _s5SupervisorName = val != null
                                            ? _supervisors
                                                  .firstWhere(
                                                    (e) =>
                                                        e.id.toString() == val,
                                                  )
                                                  .fullName
                                            : null;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildDateField(
                          context: context,
                          label: 'Fecha de ingreso efectiva *',
                          value: _s5EffectiveStartDate,
                          enabled: !isReadOnly,
                          firstDate: _s4StartDate ?? DateTime(2020),
                          errorText:
                              (_s5EffectiveStartDate != null &&
                                  _s4StartDate != null &&
                                  DateTime(
                                    _s5EffectiveStartDate!.year,
                                    _s5EffectiveStartDate!.month,
                                    _s5EffectiveStartDate!.day,
                                  ).isBefore(
                                    DateTime(
                                      _s4StartDate!.year,
                                      _s4StartDate!.month,
                                      _s4StartDate!.day,
                                    ),
                                  ))
                              ? 'Debe ser posterior o igual a la fecha de contrato'
                              : null,
                          onDateSelected: (picked) {
                            setState(() => _s5EffectiveStartDate = picked);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Action buttons
                  if (!isReadOnly)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _saveSection5Draft,
                          icon: const Icon(Icons.save_outlined, size: 14),
                          label: Text(
                            'Guardar borrador',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF94A3B8),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: (_isSaving || !_isSection5Valid)
                              ? null
                              : _completeSection5,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 15,
                          ),
                          label: Text(
                            'Marcar sección como completa',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1E293B),
                            disabledForegroundColor: const Color(0xFF475569),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '✅ Sección 5 completada y asignación formalizada.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _dossier = _dossier!.copyWith(
                                section5Status: 'en_proceso',
                              );
                            });
                          },
                          icon: const Icon(Icons.edit_outlined, size: 13),
                          label: Text(
                            'Modificar sección',
                            style: GoogleFonts.inter(fontSize: 11.5),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF38BDF8),
                            side: const BorderSide(color: Color(0xFF1E293B)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // SHARED FORM BUILDERS
  // ==========================================================================

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onDateSelected,
    DateTime? firstDate,
    DateTime? lastDate,
    bool enabled = true,
    String? hint,
    String? errorText,
  }) {
    final formatted = value != null
        ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
        : (hint ?? 'Seleccionar fecha');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormLabel(label),
        const SizedBox(height: 6),
        InkWell(
          onTap: enabled
              ? () async {
                  final effectiveFirst = firstDate ?? DateTime(2020);
                  final effectiveLast = lastDate ?? DateTime(2035);
                  DateTime effectiveInitial = value ?? DateTime.now();
                  if (effectiveInitial.isBefore(effectiveFirst)) {
                    effectiveInitial = effectiveFirst;
                  } else if (effectiveInitial.isAfter(effectiveLast)) {
                    effectiveInitial = effectiveLast;
                  }

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: effectiveInitial,
                    firstDate: effectiveFirst,
                    lastDate: effectiveLast,
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF2563EB),
                            onPrimary: Colors.white,
                            surface: Color(0xFF0F172A),
                            onSurface: Color(0xFFF8FAFC),
                          ),
                          dialogTheme: const DialogThemeData(
                            backgroundColor: Color(0xFF0F172A),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) onDateSelected(picked);
                }
              : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: enabled
                  ? const Color(0xFF111827)
                  : const Color(0xFF0A0F1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF1E293B),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: value != null
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
                Text(
                  formatted,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: value != null
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFF475569),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.expand_more,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: const Color(0xFFFCA5A5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFormLabel(
    String text, {
    bool isPreloaded = false,
    bool isEdited = false,
    String? subtitleSuggestion,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        if (isPreloaded && !isEdited)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌱', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 4),
                Text(
                  'Pre-cargado del postulante',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ],
            ),
          )
        else if (isEdited)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD97706).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✏️', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 4),
                Text(
                  'Editado',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
              ],
            ),
          ),
        if (subtitleSuggestion != null && subtitleSuggestion.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              subtitleSuggestion,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF34D399),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFFF8FAFC)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF475569),
        ),
        filled: true,
        fillColor: const Color(0xFF111827),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
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
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) {
    final seen = <T?>{};
    final uniqueItems = <DropdownMenuItem<T>>[];
    for (final item in items) {
      if (seen.add(item.value)) {
        uniqueItems.add(item);
      }
    }

    T? effectiveValue = value;
    if (effectiveValue != null &&
        !uniqueItems.any((item) => item.value == effectiveValue)) {
      final matchByText = uniqueItems.where((item) {
        final child = item.child;
        if (child is Text) {
          final text = child.data;
          return text != null &&
              text.trim().toLowerCase() ==
                  effectiveValue.toString().trim().toLowerCase();
        }
        return false;
      });

      if (matchByText.length == 1) {
        effectiveValue = matchByText.first.value;
      } else {
        effectiveValue = null;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: effectiveValue,
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF475569),
            ),
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF0F172A),
          icon: const Icon(Icons.expand_more, color: Color(0xFF64748B)),
          items: uniqueItems,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildClosedDossierBanner(RrhhHiringDossier d, bool isDark) {
    final closedDateStr = d.closedAt != null
        ? '${d.closedAt!.day.toString().padLeft(2, '0')}/${d.closedAt!.month.toString().padLeft(2, '0')}/${d.closedAt!.year} ${d.closedAt!.hour.toString().padLeft(2, '0')}:${d.closedAt!.minute.toString().padLeft(2, '0')}'
        : 'Reciente';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Color(0xFF10B981),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'EXPEDIENTE CERRADO — MODO LECTURA',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        d.convertedEmployeeCode ?? 'EMP-???',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Este expediente fue cerrado el $closedDateStr. Empleado formalmente creado con código ${d.convertedEmployeeCode ?? "asociado"}. No admite modificaciones.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          if (widget.onEmployeeCreated != null &&
              d.convertedEmployeeCode != null) ...[
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () =>
                  widget.onEmployeeCreated!(d.convertedEmployeeCode!),
              icon: const Icon(Icons.badge_outlined, size: 16),
              label: const Text('Ver en Directorio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: const Color(0xFF0F172A),
                textStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection6Accordion(RrhhHiringDossier d, bool isDark) {
    final isExpanded = _expandedSections.contains(6);
    final isClosed = d.status == 'cerrado';
    final all5Complete = d.isReadyForEmployeeCreation;
    final canConvert =
        all5Complete && _s6IsConfirmed && !isClosed && !_isSaving;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isClosed
              ? const Color(0xFF10B981).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          width: isClosed ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(6),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isClosed
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : (all5Complete
                                ? const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.15)
                                : const Color(
                                    0xFF334155,
                                  ).withValues(alpha: 0.3)),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '6',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isClosed || all5Complete
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '6. Revisión y Cierre del Expediente',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          isClosed
                              ? 'Expediente formalizado y cerrado'
                              : (all5Complete
                                    ? 'Todas las secciones listas para conversión'
                                    : 'Resumen de requisitos y validación para formalizar'),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isClosed || all5Complete
                                ? const Color(0xFF10B981)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSectionStatusChip(
                    isClosed
                        ? 'completa'
                        : (d.section6Status.isNotEmpty
                              ? d.section6Status
                              : (all5Complete ? 'en_proceso' : 'pendiente')),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BLOQUE A: Resumen visual de las 5 secciones
                  Text(
                    'RESUMEN GENERAL DE SECCIONES',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      children: [
                        _buildSectionSummaryRow(
                          secNum: 1,
                          title: '1. Recepción de Documentos',
                          status: d.section1Status,
                          detail:
                              '${d.validatedRequiredDocsCount}/${d.totalRequiredDocsCount} validados',
                          originBadge:
                              d.documents.values.any(
                                (doc) => doc.validatedInRecruitment,
                              )
                              ? '🌱 del postulante'
                              : null,
                        ),
                        const Divider(height: 1, color: Color(0xFF1E293B)),
                        _buildSectionSummaryRow(
                          secNum: 2,
                          title: '2. Seguridad Social',
                          status: d.section2Status,
                          detail: d.afpName != null && d.afpName!.isNotEmpty
                              ? '${d.afpName} - ${d.healthInsuranceName ?? "Sin caja"}'
                              : 'No completado',
                          originBadge: d.section2Status == 'completa'
                              ? '🆕 nuevo'
                              : null,
                        ),
                        const Divider(height: 1, color: Color(0xFF1E293B)),
                        _buildSectionSummaryRow(
                          secNum: 3,
                          title: '3. Datos Personales',
                          status: d.section3Status,
                          detail:
                              d.fullAddress != null && d.fullAddress!.isNotEmpty
                              ? '${d.maritalStatus ?? "Estado civil"}, ${d.childrenCount ?? 0} hijos'
                              : 'No completado',
                          originBadge:
                              (_applicantEmergName != null &&
                                  _applicantEmergName!.isNotEmpty)
                              ? ((_s3EmergNameCtrl.text.trim() !=
                                            _applicantEmergName!.trim() ||
                                        (_applicantAddress != null &&
                                            _s3AddressCtrl.text.trim() !=
                                                _applicantAddress!.trim()))
                                    ? '✏️ modificado'
                                    : '🌱 del postulante')
                              : null,
                        ),
                        const Divider(height: 1, color: Color(0xFF1E293B)),
                        _buildSectionSummaryRow(
                          secNum: 4,
                          title: '4. Condiciones Contractuales',
                          status: d.section4Status,
                          detail:
                              d.contractTypeName != null &&
                                  d.contractTypeName!.isNotEmpty
                              ? '${d.contractTypeName} (${d.currency} ${d.baseSalary?.toStringAsFixed(2) ?? "0.00"})'
                              : 'No completado',
                          originBadge: d.section4Status == 'completa'
                              ? '🆕 nuevo'
                              : null,
                        ),
                        const Divider(height: 1, color: Color(0xFF1E293B)),
                        _buildSectionSummaryRow(
                          secNum: 5,
                          title: '5. Asignación Organizacional',
                          status: d.section5Status,
                          detail:
                              d.positionName != null &&
                                  d.positionName!.isNotEmpty
                              ? '${d.positionName} - ${d.areaName ?? "Sin área"}'
                              : 'No completado',
                          originBadge:
                              (_applicantTargetArea != null &&
                                  _applicantTargetArea!.isNotEmpty)
                              ? ((_s5AreaName != null &&
                                        !_s5AreaName!.toLowerCase().contains(
                                          _applicantTargetArea!.toLowerCase(),
                                        ))
                                    ? '✏️ modificado'
                                    : '🌱 del postulante')
                              : null,
                        ),
                      ],
                    ),
                  ),

                  // BLOQUE B: Pendientes si hay secciones incompletas
                  if (!all5Complete && !isClosed) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(
                            0xFFF59E0B,
                          ).withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hay secciones pendientes. Complétalas para poder convertir al empleado.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (d.section1Status != 'completa' &&
                              d.section1Status != 'completo')
                            _buildPendingItem(
                              'Sección 1 (Documentos): Faltan documentos obligatorios por validar (${d.validatedRequiredDocsCount}/${d.totalRequiredDocsCount} validados).',
                            ),
                          if (d.section2Status != 'completa' &&
                              d.section2Status != 'completo')
                            _buildPendingItem(
                              'Sección 2 (Seguridad Social): AFP y Caja de Salud requeridos.',
                            ),
                          if (d.section3Status != 'completa' &&
                              d.section3Status != 'completo')
                            _buildPendingItem(
                              'Sección 3 (Datos Personales): Domicilio o contactos de emergencia incompletos.',
                            ),
                          if (d.section4Status != 'completa' &&
                              d.section4Status != 'completo')
                            _buildPendingItem(
                              'Sección 4 (Contractual): Modalidad contractual o salario base incompletos.',
                            ),
                          if (d.section5Status != 'completa' &&
                              d.section5Status != 'completo')
                            _buildPendingItem(
                              'Sección 5 (Asignación): Cargo, área o centro de costos sin asignar.',
                            ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // BLOQUE C: Confirmación final y Acción
                  if (isClosed) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Expediente Convertido y Cerrado Exitosamente',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'El postulante ${d.applicantFullName} es ahora empleado activo con código ${d.convertedEmployeeCode ?? "asignado"}.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          if (d.closingNotes != null &&
                              d.closingNotes!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Notas de cierre: "${d.closingNotes}"',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _s6IsConfirmed = !_s6IsConfirmed;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _s6IsConfirmed,
                                activeColor: const Color(0xFF10B981),
                                checkColor: const Color(0xFF0F172A),
                                side: const BorderSide(
                                  color: Color(0xFF64748B),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _s6IsConfirmed = val ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Confirmo que la información del expediente es correcta y está lista para crear al empleado.',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE2E8F0),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormLabel('Notas finales u observaciones (opcional)'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _s6NotesCtrl,
                      hint:
                          'Añade comentarios o consideraciones sobre la incorporación...',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Botón Convertir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: !all5Complete
                              ? 'Completa las 5 secciones primero'
                              : (!_s6IsConfirmed
                                    ? 'Confirma la información primero'
                                    : 'Crear empleado formal'),
                          child: FilledButton.icon(
                            onPressed: canConvert
                                ? () => _showConfirmConversionDialog(context, d)
                                : null,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person_add_alt_1_rounded,
                                    size: 16,
                                  ),
                            label: Text(
                              _isSaving
                                  ? 'Convirtiendo...'
                                  : 'CONVERTIR A EMPLEADO',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: const Color(0xFF0F172A),
                              disabledBackgroundColor: const Color(0xFF1E293B),
                              disabledForegroundColor: const Color(0xFF475569),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSectionSummaryRow({
    required int secNum,
    required String title,
    required String status,
    required String detail,
    String? originBadge,
  }) {
    final isComplete = status == 'completa';
    final isInProgress = status == 'en_proceso';

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    if (isComplete) {
      statusColor = const Color(0xFF10B981);
      statusIcon = Icons.check_circle_rounded;
      statusLabel = 'Completa';
    } else if (isInProgress) {
      statusColor = const Color(0xFFF59E0B);
      statusIcon = Icons.warning_amber_rounded;
      statusLabel = 'En proceso';
    } else {
      statusColor = const Color(0xFFEF4444);
      statusIcon = Icons.cancel_outlined;
      statusLabel = 'Pendiente';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              detail,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: const Color(0xFF94A3B8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          if (originBadge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: originBadge.contains('del postulante')
                    ? const Color(0xFF0284C7).withValues(alpha: 0.15)
                    : (originBadge.contains('modificado')
                          ? const Color(0xFFD97706).withValues(alpha: 0.15)
                          : const Color(0xFF334155).withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: originBadge.contains('del postulante')
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                      : (originBadge.contains('modificado')
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                            : const Color(0xFF64748B).withValues(alpha: 0.3)),
                ),
              ),
              child: Text(
                originBadge,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: originBadge.contains('del postulante')
                      ? const Color(0xFF38BDF8)
                      : (originBadge.contains('modificado')
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFF94A3B8)),
                ),
              ),
            ),
          ],
          const SizedBox(width: 14),
          InkWell(
            onTap: () => _navigateToSection(secNum),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver sección',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: Color(0xFF38BDF8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 2),
      child: Text(
        '• $text',
        style: GoogleFonts.inter(
          fontSize: 11.5,
          color: const Color(0xFFFCD34D),
          height: 1.35,
        ),
      ),
    );
  }

  Future<void> _showConfirmConversionDialog(
    BuildContext context,
    RrhhHiringDossier d,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.how_to_reg_rounded,
                color: Color(0xFF10B981),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Confirmar conversión a empleado',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro? Esta acción creará al empleado con sus datos formales y cerrará el expediente de contratación:',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Color(0xFF38BDF8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          d.applicantFullName,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cargo asignado: ${d.positionName ?? "Pendiente"} — ${d.areaName ?? "Área"}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Código generado automáticamente: EMP-XXX (siguiente secuencia correlativa)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'El expediente quedará cerrado y no podrá editarse. El postulante pasará a estado CONTRATADO y se retirará del pipeline activo de reclutamiento.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: const Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Confirmar conversión'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF0F172A),
              textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _executeConversion(d);
    }
  }

  Future<void> _executeConversion(RrhhHiringDossier d) async {
    setState(() => _isSaving = true);
    try {
      final employee = await RrhhRepository.current.convertDossierToEmployee(
        d.id ?? widget.dossierId,
        notes: _s6NotesCtrl.text.trim().isEmpty
            ? null
            : _s6NotesCtrl.text.trim(),
      );

      await _loadDossier();
      if (!mounted) return;
      setState(() => _isSaving = false);

      widget.onEmployeeCreated?.call(employee.code);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      RrhhSnackBar.showError(context, 'Error al convertir empleado: $e');
    }
  }
}
