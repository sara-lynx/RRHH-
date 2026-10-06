import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_leave_request.dart';
import '../models/rrhh_shift.dart';
import '../models/rrhh_disciplinary_record.dart';
import '../models/rrhh_termination_record.dart';
import '../models/rrhh_payroll_period.dart';
import '../models/rrhh_attendance_record.dart';

/// Almacenamiento local en memoria y dataset autÃ³nomo para RRHH.
/// Permite que el frontend funcione 100% independiente sin depender de backend.
class RrhhLocalStore {
  static final RrhhLocalStore instance = RrhhLocalStore._internal();
  factory RrhhLocalStore() => instance;

  RrhhLocalStore._internal() {
    _initData();
  }

  late List<RrhhArea> _areas;
  late List<RrhhPosition> _positions;
  late List<RrhhSpecialty> _specialties;
  late List<RrhhSchedule> _schedules;
  late List<RrhhShift> _shifts;
  late List<RrhhEmployeeSummaryDto> _employeeSummaries;
  late Map<int, RrhhEmployee> _employees;
  late List<RrhhApplicantSummaryDto> _applicantSummaries;
  late List<RrhhRecentMovementDto> _recentMovements;
  late List<RrhhLeaveRequest> _leaves;
  late List<RrhhVacation> _vacations;
  late List<RrhhDisciplinaryRecord> _disciplinary;
  late List<RrhhTerminationRecord> _terminations;
  late List<RrhhPayrollPeriod> _payrollPeriods;
  late List<RrhhAttendanceRecord> _attendance;
  late List<RrhhCatalogItem> _catalogs;
  late List<RrhhHiringDossier> _dossiers;

  void _initData() {
    final now = DateTime(2026, 1, 1);

    _areas = [
      RrhhArea(id: 1, name: 'Operaciones y Servicios', code: 'OPS', description: 'Personal de campo y logÃ­stica', createdAt: now, updatedAt: now),
      RrhhArea(id: 2, name: 'Limpieza e Higiene', code: 'LIMP', description: 'Servicios de limpieza industrial', createdAt: now, updatedAt: now),
      RrhhArea(id: 3, name: 'Mantenimiento TÃ©cnico', code: 'MTTO', description: 'Electricidad, plomerÃ­a y mantenimiento', createdAt: now, updatedAt: now),
      RrhhArea(id: 4, name: 'Seguridad y Vigilancia', code: 'SEG', description: 'Guardias de seguridad fÃ­sica y control', createdAt: now, updatedAt: now),
      RrhhArea(id: 5, name: 'AdministraciÃ³n y Finanzas', code: 'ADM', description: 'Contabilidad y gestiÃ³n operativa', createdAt: now, updatedAt: now),
      RrhhArea(id: 6, name: 'Recursos Humanos', code: 'RRHH', description: 'GestiÃ³n de talento humano', createdAt: now, updatedAt: now),
    ];

    _positions = [
      RrhhPosition(id: 1, name: 'Supervisor de Operaciones', areaId: 1, code: 'SUP-OPS', workplaceType: 'CAMPO', createdAt: now, updatedAt: now),
      RrhhPosition(id: 2, name: 'Operario de Limpieza', areaId: 2, code: 'OP-LIMP', workplaceType: 'CAMPO', createdAt: now, updatedAt: now),
      RrhhPosition(id: 3, name: 'TÃ©cnico Especialista', areaId: 3, code: 'TEC-MTTO', workplaceType: 'CAMPO', createdAt: now, updatedAt: now),
      RrhhPosition(id: 4, name: 'Guardia de Seguridad', areaId: 4, code: 'GUA-SEG', workplaceType: 'CAMPO', createdAt: now, updatedAt: now),
      RrhhPosition(id: 5, name: 'Analista Administrativo', areaId: 5, code: 'ANA-ADM', workplaceType: 'OFICINA', createdAt: now, updatedAt: now),
      RrhhPosition(id: 6, name: 'Coordinador de RRHH', areaId: 6, code: 'CRD-RRHH', workplaceType: 'OFICINA', createdAt: now, updatedAt: now),
    ];

    _specialties = [
      RrhhSpecialty(id: 1, name: 'Limpieza Hospitalaria', code: 'ESP-001', createdAt: now, updatedAt: now),
      RrhhSpecialty(id: 2, name: 'JardinerÃ­a Industrial', code: 'ESP-002', createdAt: now, updatedAt: now),
      RrhhSpecialty(id: 3, name: 'Electricidad y Redes', code: 'ESP-003', createdAt: now, updatedAt: now),
      RrhhSpecialty(id: 4, name: 'Vigilancia Nocturna', code: 'ESP-004', createdAt: now, updatedAt: now),
    ];

    _schedules = [
      RrhhSchedule(id: 1, name: 'Turno Mañana (07:00 - 15:00)', code: 'SCH-01', startTime: '07:00', endTime: '15:00', workDays: [1, 2, 3, 4, 5], createdAt: now, updatedAt: now),
      RrhhSchedule(id: 2, name: 'Turno Tarde (15:00 - 23:00)', code: 'SCH-02', startTime: '15:00', endTime: '23:00', workDays: [1, 2, 3, 4, 5], createdAt: now, updatedAt: now),
      RrhhSchedule(id: 3, name: 'Turno Noche (23:00 - 07:00)', code: 'SCH-03', startTime: '23:00', endTime: '07:00', workDays: [1, 2, 3, 4, 5], createdAt: now, updatedAt: now),
      RrhhSchedule(id: 4, name: 'Administrativo (08:30 - 17:30)', code: 'SCH-04', startTime: '08:30', endTime: '17:30', workDays: [1, 2, 3, 4, 5], createdAt: now, updatedAt: now),
    ];

    _shifts = [
      RrhhShift(
        id: 1,
        code: 'TUR-001',
        name: 'Cuadrante Diurno Hospital',
        startTime: '07:00',
        endTime: '15:00',
        workDays: [1, 2, 3, 4, 5],
        shiftType: 'Completa',
        description: 'Jornada matutina hospitalaria',
        createdAt: now,
        updatedAt: now,
      ),
      RrhhShift(
        id: 2,
        code: 'TUR-002',
        name: 'Cuadrante Tarde Comercial',
        startTime: '15:00',
        endTime: '23:00',
        workDays: [1, 2, 3, 4, 5],
        shiftType: 'Completa',
        description: 'Jornada vespertina comercial',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    _employeeSummaries = [
      RrhhEmployeeSummaryDto(
        id: 1,
        code: 'EMP-001',
        fullName: 'Carlos AndrÃ©s Mamani Quispe',
        identityCard: '4892831 LP',
        phone: '71234567',
        employeeType: 'OPERATIVO',
        area: 'Operaciones y Servicios',
        position: 'Supervisor de Operaciones',
        workplace: 'Banco Central - Sede Central',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        hireDate: DateTime(2023, 3, 15),
      ),
      RrhhEmployeeSummaryDto(
        id: 2,
        code: 'EMP-002',
        fullName: 'MarÃ­a Elena Flores Torrez',
        identityCard: '5932189 CB',
        phone: '72345678',
        employeeType: 'OPERATIVO',
        area: 'Limpieza e Higiene',
        position: 'Operario de Limpieza',
        workplace: 'Centro MÃ©dico Los Pinos',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        hireDate: DateTime(2023, 7, 1),
      ),
      RrhhEmployeeSummaryDto(
        id: 3,
        code: 'EMP-003',
        fullName: 'Roberto Luis Condori Poma',
        identityCard: '6201948 LP',
        phone: '73456789',
        employeeType: 'OPERATIVO',
        area: 'Mantenimiento TÃ©cnico',
        position: 'TÃ©cnico Especialista',
        workplace: 'Edificio Multicentro',
        status: 'ACTIVO',
        availabilityStatus: 'DISPONIBLE',
        hireDate: DateTime(2024, 1, 10),
      ),
      RrhhEmployeeSummaryDto(
        id: 4,
        code: 'EMP-004',
        fullName: 'Laura Beatriz GutiÃ©rrez Ramos',
        identityCard: '7192843 SC',
        phone: '74567890',
        employeeType: 'ADMINISTRATIVO',
        area: 'Recursos Humanos',
        position: 'Coordinador de RRHH',
        workplace: 'Oficina Central',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        hireDate: DateTime(2022, 11, 20),
      ),
      RrhhEmployeeSummaryDto(
        id: 5,
        code: 'EMP-005',
        fullName: 'Jorge Marcelo Vargas Silva',
        identityCard: '4928172 LP',
        phone: '75678901',
        employeeType: 'OPERATIVO',
        area: 'Seguridad y Vigilancia',
        position: 'Guardia de Seguridad',
        workplace: 'Planta Industrial Quillacollo',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        hireDate: DateTime(2024, 2, 1),
      ),
      RrhhEmployeeSummaryDto(
        id: 6,
        code: 'EMP-006',
        fullName: 'Ana Paola Choque Miranda',
        identityCard: '8392019 OR',
        phone: '76789012',
        employeeType: 'OPERATIVO',
        area: 'Limpieza e Higiene',
        position: 'Operario de Limpieza',
        workplace: 'Universidad Mayor',
        status: 'VACACIONES',
        availabilityStatus: 'DESCANSO',
        hireDate: DateTime(2023, 9, 15),
      ),
    ];

    _employees = {};
    for (final s in _employeeSummaries) {
      _employees[s.id] = RrhhEmployee(
        id: s.id,
        code: s.code,
        fullName: s.fullName,
        identityCard: s.identityCard,
        phone: s.phone,
        birthPlace: 'La Paz',
        address: 'Av. 20 de Octubre #1234',
        occupation: s.position ?? 'Operativo',
        personalReference: 'Juan PÃ©rez',
        referencePhone: '71112233',
        employeeType: s.employeeType,
        area: s.area ?? 'Operaciones',
        position: s.position ?? 'Operario',
        specialty: 'General',
        workplace: s.workplace ?? 'Sede Central',
        supervisor: 'Ing. Rodrigo Mendoza',
        realStartDate: s.hireDate,
        fiscalStartDate: s.hireDate,
        contractType: 'INDEFINIDO',
        status: s.status,
        availabilityStatus: s.availabilityStatus,
        agreedSalary: 3500.0,
        createdAt: now,
        updatedAt: now,
      );
    }

    _applicantSummaries = [];

    _recentMovements = [];
    _leaves = [];
    _vacations = [];
    _disciplinary = [];
    _terminations = [];
    _payrollPeriods = [];
    _attendance = [];
    _catalogs = [];

    _dossiers = [
      RrhhHiringDossier(
        id: 1,
        code: 'EXP-CONTRAT-2026-001',
        applicantId: 1,
        applicantCode: 'POST-001',
        applicantName: 'Carlos Mendoza Ramos',
        status: 'abierto',
        createdAt: now,
        updatedAt: now,
      ),
      RrhhHiringDossier(
        id: 2,
        code: 'EXP-CONTRAT-2026-002',
        applicantId: 2,
        applicantCode: 'POST-002',
        applicantName: 'María Eugenia Vargas',
        status: 'abierto',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  List<RrhhHiringDossier> listActiveDossiers() => List.unmodifiable(_dossiers);

  RrhhHiringDossier? getDossierById(int id) {
    try {
      return _dossiers.firstWhere((d) => d.id == id);
    } catch (_) {
      return _dossiers.isNotEmpty ? _dossiers.first : null;
    }
  }

  RrhhDashboardMetricsResponse getDashboardMetrics() {
    return RrhhDashboardMetricsResponse(
      activeEmployeesCount: _employeeSummaries.where((e) => e.status == 'ACTIVO').length,
      totalEmployeesCount: _employeeSummaries.length,
      fieldEmployeesCount: _employeeSummaries.where((e) => e.employeeType == 'OPERATIVO').length,
      officeEmployeesCount: _employeeSummaries.where((e) => e.employeeType == 'ADMINISTRATIVO').length,
      pendingApplicantsCount: _applicantSummaries.length,
      selectedApplicantsCount: 1,
      completeFilesCount: _employeeSummaries.length - 1,
      pendingFilesCount: 1,
      expedientesPercentage: 92.5,
      expiringContractsCount: 2,
      activeLeavesCount: _leaves.length,
      todayAttendanceRate: 98.2,
      todayIncidentsCount: _disciplinary.length,
    );
  }

  List<RrhhRecentMovementDto> getRecentMovements() => List.unmodifiable(_recentMovements);

  List<RrhhEmployeeSummaryDto> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
  }) {
    var result = _employeeSummaries;
    if (status != null && status.isNotEmpty) {
      result = result.where((e) => e.status.toUpperCase() == status.toUpperCase()).toList();
    }
    if (employeeType != null && employeeType.isNotEmpty) {
      result = result.where((e) => e.employeeType.toUpperCase() == employeeType.toUpperCase()).toList();
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      result = result.where((e) =>
        e.fullName.toLowerCase().contains(q) ||
        e.code.toLowerCase().contains(q) ||
        e.identityCard.toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  RrhhEmployee getEmployeeById(int id) {
    if (_employees.containsKey(id)) {
      return _employees[id]!;
    }
    return _employees.values.first;
  }

  RrhhEmployee updateEmployee(RrhhEmployee emp) {
    if (emp.id != null) {
      _employees[emp.id!] = emp;
      final idx = _employeeSummaries.indexWhere((e) => e.id == emp.id);
      if (idx != -1) {
        _employeeSummaries[idx] = RrhhEmployeeSummaryDto(
          id: emp.id!,
          code: emp.code,
          fullName: emp.fullName,
          identityCard: emp.identityCard,
          phone: emp.phone,
          employeeType: emp.employeeType,
          area: emp.area,
          position: emp.position,
          workplace: emp.workplace,
          status: emp.status,
          availabilityStatus: emp.availabilityStatus,
          hireDate: emp.realStartDate,
        );
      }
    }
    return emp;
  }

  RrhhEmployee createEmployee(RrhhEmployee emp) {
    final nextId = _employeeSummaries.isEmpty ? 1 : (_employeeSummaries.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
    final nextCode = 'EMP-${nextId.toString().padLeft(3, '0')}';
    final now = DateTime.now();
    final newEmp = RrhhEmployee(
      id: nextId,
      code: nextCode,
      fullName: emp.fullName,
      identityCard: emp.identityCard,
      phone: emp.phone,
      birthPlace: emp.birthPlace,
      address: emp.address,
      occupation: emp.occupation,
      personalReference: emp.personalReference,
      referencePhone: emp.referencePhone,
      employeeType: emp.employeeType,
      area: emp.area,
      position: emp.position,
      specialty: emp.specialty,
      workplace: emp.workplace,
      supervisor: emp.supervisor,
      realStartDate: emp.realStartDate,
      fiscalStartDate: emp.fiscalStartDate,
      contractType: emp.contractType,
      status: emp.status,
      availabilityStatus: emp.availabilityStatus,
      agreedSalary: emp.agreedSalary ?? 3500.0,
      createdAt: now,
      updatedAt: now,
    );
    _employees[nextId] = newEmp;
    _employeeSummaries.add(RrhhEmployeeSummaryDto(
      id: nextId,
      code: nextCode,
      fullName: newEmp.fullName,
      identityCard: newEmp.identityCard,
      phone: newEmp.phone,
      employeeType: newEmp.employeeType,
      area: newEmp.area,
      position: newEmp.position,
      workplace: newEmp.workplace,
      status: newEmp.status,
      availabilityStatus: newEmp.availabilityStatus,
      hireDate: newEmp.realStartDate,
    ));
    return newEmp;
  }

  List<RrhhArea> listAreas() => List.unmodifiable(_areas);
  RrhhArea createArea(RrhhArea area) {
    final now = DateTime.now();
    final newArea = RrhhArea(
      id: _areas.length + 1,
      name: area.name,
      code: area.code,
      description: area.description,
      createdAt: now,
      updatedAt: now,
    );
    _areas.add(newArea);
    return newArea;
  }

  List<RrhhPosition> listPositions() => List.unmodifiable(_positions);
  RrhhPosition createPosition(RrhhPosition pos) {
    final now = DateTime.now();
    final newPos = RrhhPosition(
      id: _positions.length + 1,
      name: pos.name,
      areaId: pos.areaId,
      code: pos.code,
      workplaceType: pos.workplaceType,
      createdAt: now,
      updatedAt: now,
    );
    _positions.add(newPos);
    return newPos;
  }

  List<RrhhSpecialty> listSpecialties() => List.unmodifiable(_specialties);
  List<RrhhSchedule> listSchedules() => List.unmodifiable(_schedules);
  List<RrhhShift> listShifts() => List.unmodifiable(_shifts);
  List<RrhhApplicantSummaryDto> listApplicants() => List.unmodifiable(_applicantSummaries);
  List<RrhhLeaveRequest> listLeaves() => List.unmodifiable(_leaves);
  List<RrhhVacation> listVacations() => List.unmodifiable(_vacations);
  List<RrhhDisciplinaryRecord> listDisciplinary() => List.unmodifiable(_disciplinary);
  List<RrhhTerminationRecord> listTerminations() => List.unmodifiable(_terminations);
  List<RrhhPayrollPeriod> listPayrollPeriods() => List.unmodifiable(_payrollPeriods);
  List<RrhhAttendanceRecord> listAttendance() => List.unmodifiable(_attendance);
  List<RrhhCatalogItem> listCatalogItems() => List.unmodifiable(_catalogs);
}


