import 'package:flutter/material.dart';
import '../domain/models/elite_rrhh_models.dart';

/// Almacén en memoria inicial con la semilla operativa de Elite Multiservicios S.R.L.
class EliteRrhhLocalStore {
  EliteRrhhLocalStore._();
  static final EliteRrhhLocalStore instance = EliteRrhhLocalStore._();

  /// 12 colaboradores representativos (4 Oficina, 8 Campo)
  final List<EliteEmployee> _employees = [
    // -------------------------------------------------------------------------
    // PERSONAL DE OFICINA (4)
    // -------------------------------------------------------------------------
    EliteEmployee(
      id: 'EMP-001',
      ci: '4892831 LP',
      fullName: 'Carlos Andrés Mamani Quispe',
      phone: '71234567',
      email: 'carlos.mamani@elitemultiservicios.com',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.adm,
      position: 'Contador General',
      assignedSite: 'Sede Central',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2022, 3, 1),
      baseSalary: 5500.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-002',
      ci: '5932189 CB',
      fullName: 'Paola Andrea Torrico Vaca',
      phone: '72345678',
      email: 'paola.torrico@elitemultiservicios.com',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.rrhh,
      position: 'Encargada de Recursos Humanos',
      assignedSite: 'Sede Central',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2022, 8, 15),
      baseSalary: 4800.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-003',
      ci: '6201948 SC',
      fullName: 'Alejandro Siles Morales',
      phone: '73456789',
      email: 'alejandro.siles@elitemultiservicios.com',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.com,
      position: 'Ejecutivo Comercial B2B',
      assignedSite: 'Sede Central',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 2, 10),
      baseSalary: 4200.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-004',
      ci: '7192843 LP',
      fullName: 'Valeria Sofía Rocha Peñaranda',
      phone: '74567890',
      email: 'valeria.rocha@elitemultiservicios.com',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.com,
      position: 'Especialista en Marketing',
      assignedSite: 'Sede Central',
      contractType: ContractType.plazoFijo,
      hireDate: DateTime(2024, 8, 1),
      contractEndDate: DateTime.now().add(const Duration(days: 22)), // Alerta < 30 días
      baseSalary: 3800.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.periodoPrueba,
    ),

    // -------------------------------------------------------------------------
    // PERSONAL DE CAMPO (8)
    // -------------------------------------------------------------------------
    EliteEmployee(
      id: 'EMP-005',
      ci: '4928172 LP',
      fullName: 'Jorge Marcelo Vargas Silva',
      phone: '75678901',
      email: 'jorge.vargas@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      position: 'Guardia de Seguridad',
      assignedSite: 'Condominio Las Palmas',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 1, 15),
      baseSalary: 2900.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-006',
      ci: '5382019 SC',
      fullName: 'Ramiro Callisaya Flores',
      phone: '76789012',
      email: 'ramiro.callisaya@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      position: 'Guardia de Seguridad',
      assignedSite: 'Ventura Mall',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 6, 20),
      baseSalary: 2900.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-007',
      ci: '6784920 CB',
      fullName: 'Franz Gonzalo Condori Choque',
      phone: '77890123',
      email: 'franz.condori@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      position: 'Guardia de Seguridad Nocturno',
      assignedSite: 'Parque Industrial Mz 4',
      contractType: ContractType.plazoFijo,
      hireDate: DateTime(2024, 7, 10),
      contractEndDate: DateTime.now().add(const Duration(days: 15)), // Alerta < 30 días
      baseSalary: 3100.0,
      hasPendingLegalDocs: true, // Alerta documentos
      status: EmployeeStatus.periodoPrueba,
    ),
    EliteEmployee(
      id: 'EMP-008',
      ci: '8392019 OR',
      fullName: 'María Elena Flores Torrez',
      phone: '78901234',
      email: 'elena.flores@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      position: 'Operario de Limpieza',
      assignedSite: 'Centro Médico Los Pinos',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 4, 10),
      baseSalary: 2600.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-009',
      ci: '7483921 SC',
      fullName: 'Juana Quispe de Alarcón',
      phone: '79012345',
      email: 'juana.quispe@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      position: 'Operario de Limpieza',
      assignedSite: 'Edificio Multicentro',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 9, 1),
      baseSalary: 2550.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-010',
      ci: '8923014 LP',
      fullName: 'Martha Beatriz Guzmán Rojas',
      phone: '70123456',
      email: 'martha.guzman@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      position: 'Operario de Limpieza',
      assignedSite: 'Planta Industrial Quillacollo',
      contractType: ContractType.plazoFijo,
      hireDate: DateTime(2024, 3, 15),
      contractEndDate: DateTime.now().add(const Duration(days: 85)),
      baseSalary: 2600.0,
      hasPendingLegalDocs: true, // Alerta antecedentes FELCC pendientes
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-011',
      ci: '6192830 CB',
      fullName: 'Roberto Luis Céspedes Poma',
      phone: '71987654',
      email: 'roberto.cespedes@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.jar,
      position: 'Jardinero y Paisajista',
      assignedSite: 'Boulevard Gastronómico',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 5, 18),
      baseSalary: 2700.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
    EliteEmployee(
      id: 'EMP-012',
      ci: '7019284 SC',
      fullName: 'José Miguel Arancibia Vera',
      phone: '72876543',
      email: 'jose.arancibia@operaciones.elite.bo',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.man,
      position: 'Técnico de Mantenimiento',
      assignedSite: 'Clínica Los Olivos',
      contractType: ContractType.indefinido,
      hireDate: DateTime(2023, 11, 5),
      baseSalary: 3400.0,
      hasPendingLegalDocs: false,
      status: EmployeeStatus.activo,
    ),
  ];

  /// Escalas salariales vigentes para Elite Multiservicios S.R.L.
  final List<PositionSalaryScale> _salaryScales = const [
    PositionSalaryScale(
      position: 'Contador General',
      serviceLineCode: EliteCostCenter.adm,
      workplaceType: EmployeeWorkplaceType.oficina,
      minSalary: 5000.0,
      maxSalary: 7000.0,
      headcount: 1,
    ),
    PositionSalaryScale(
      position: 'Encargada de Recursos Humanos',
      serviceLineCode: EliteCostCenter.rrhh,
      workplaceType: EmployeeWorkplaceType.oficina,
      minSalary: 4500.0,
      maxSalary: 6000.0,
      headcount: 1,
    ),
    PositionSalaryScale(
      position: 'Ejecutivo Comercial B2B',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      minSalary: 3800.0,
      maxSalary: 5500.0,
      headcount: 2,
    ),
    PositionSalaryScale(
      position: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      minSalary: 2700.0,
      maxSalary: 3300.0,
      headcount: 3,
    ),
    PositionSalaryScale(
      position: 'Operario de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      minSalary: 2500.0,
      maxSalary: 2900.0,
      headcount: 3,
    ),
    PositionSalaryScale(
      position: 'Técnico de Mantenimiento',
      serviceLineCode: EliteCostCenter.man,
      workplaceType: EmployeeWorkplaceType.campo,
      minSalary: 3000.0,
      maxSalary: 4200.0,
      headcount: 1,
    ),
  ];

  List<EliteEmployee> getEmployees() => List.unmodifiable(_employees);
  List<PositionSalaryScale> getSalaryScales() => List.unmodifiable(_salaryScales);

  /// 4 Turnos configurados para Elite Multiservicios
  final List<EliteShift> _shifts = const [
    EliteShift(
      id: 'SFT-001',
      code: 'TUR-ADM-01',
      name: 'Administrativo Central 8h',
      workplaceType: ShiftWorkplaceType.oficina,
      startTime: TimeOfDay(hour: 8, minute: 30),
      endTime: TimeOfDay(hour: 17, minute: 30),
      gracePeriodMinutes: 10,
      crossesMidnight: false,
      activeDays: 'Lunes a Viernes',
    ),
    EliteShift(
      id: 'SFT-002',
      code: 'TUR-SEG-12D',
      name: 'Seguridad 12h Diurno',
      workplaceType: ShiftWorkplaceType.campo,
      startTime: TimeOfDay(hour: 7, minute: 0),
      endTime: TimeOfDay(hour: 19, minute: 0),
      gracePeriodMinutes: 5,
      crossesMidnight: false,
      activeDays: 'Rotativo 4x2 Continuo',
    ),
    EliteShift(
      id: 'SFT-003',
      code: 'TUR-SEG-12N',
      name: 'Seguridad 12h Nocturno',
      workplaceType: ShiftWorkplaceType.campo,
      startTime: TimeOfDay(hour: 19, minute: 0),
      endTime: TimeOfDay(hour: 7, minute: 0),
      gracePeriodMinutes: 5,
      crossesMidnight: true,
      activeDays: 'Rotativo 4x2 Continuo',
    ),
    EliteShift(
      id: 'SFT-004',
      code: 'TUR-LIM-01',
      name: 'Limpieza e Higiene Mañana',
      workplaceType: ShiftWorkplaceType.campo,
      startTime: TimeOfDay(hour: 6, minute: 0),
      endTime: TimeOfDay(hour: 14, minute: 0),
      gracePeriodMinutes: 10,
      crossesMidnight: false,
      activeDays: 'Lunes a Sábado',
    ),
  ];

  /// 5 Sedes de clientes con geocercas reales de Santa Cruz
  final List<EliteClientSite> _clientSites = const [
    EliteClientSite(
      id: 'SITE-001',
      code: 'SITE-CENTRAL',
      name: 'Sede Central Elite',
      serviceLineCode: EliteCostCenter.adm,
      latitude: -17.7832,
      longitude: -63.1821,
      geofenceRadiusMeters: 50.0,
      requiredPersonnel: 4,
      currentAssigned: 4,
    ),
    EliteClientSite(
      id: 'SITE-002',
      code: 'SITE-PALMAS',
      name: 'Condominio Las Palmas',
      serviceLineCode: EliteCostCenter.seg,
      latitude: -17.7950,
      longitude: -63.1980,
      geofenceRadiusMeters: 80.0,
      requiredPersonnel: 2,
      currentAssigned: 2,
    ),
    EliteClientSite(
      id: 'SITE-003',
      code: 'SITE-VENTURA',
      name: 'Ventura Mall',
      serviceLineCode: EliteCostCenter.seg,
      latitude: -17.7562,
      longitude: -63.1874,
      geofenceRadiusMeters: 100.0,
      requiredPersonnel: 2,
      currentAssigned: 2,
    ),
    EliteClientSite(
      id: 'SITE-004',
      code: 'SITE-PINOS',
      name: 'Centro Médico Los Pinos',
      serviceLineCode: EliteCostCenter.lim,
      latitude: -17.7712,
      longitude: -63.1654,
      geofenceRadiusMeters: 60.0,
      requiredPersonnel: 2,
      currentAssigned: 2,
    ),
    EliteClientSite(
      id: 'SITE-005',
      code: 'SITE-QUILLACO',
      name: 'Planta Industrial Quillacollo',
      serviceLineCode: EliteCostCenter.lim,
      latitude: -17.7640,
      longitude: -63.1415,
      geofenceRadiusMeters: 120.0,
      requiredPersonnel: 2,
      currentAssigned: 2,
    ),
  ];

  /// Asignaciones de cuadrantes enlazando los 12 colaboradores
  final List<EliteRosterAssignment> _rosterAssignments = [
    EliteRosterAssignment(
      id: 'ROST-001',
      employeeId: 'EMP-001',
      employeeName: 'Carlos Andrés Mamani Quispe',
      serviceLineCode: EliteCostCenter.adm,
      siteId: 'SITE-001',
      siteName: 'Sede Central Elite',
      shiftId: 'SFT-001',
      shiftName: 'Administrativo Central 8h',
      scheduleSummary: '08:30 - 17:30 (L-V)',
      startDate: DateTime(2023, 1, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-002',
      employeeId: 'EMP-002',
      employeeName: 'Paola Andrea Torrico Vaca',
      serviceLineCode: EliteCostCenter.rrhh,
      siteId: 'SITE-001',
      siteName: 'Sede Central Elite',
      shiftId: 'SFT-001',
      shiftName: 'Administrativo Central 8h',
      scheduleSummary: '08:30 - 17:30 (L-V)',
      startDate: DateTime(2023, 1, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      serviceLineCode: EliteCostCenter.com,
      siteId: 'SITE-001',
      siteName: 'Sede Central Elite',
      shiftId: 'SFT-001',
      shiftName: 'Administrativo Central 8h',
      scheduleSummary: '08:30 - 17:30 (L-V)',
      startDate: DateTime(2023, 2, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-004',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      serviceLineCode: EliteCostCenter.com,
      siteId: 'SITE-001',
      siteName: 'Sede Central Elite',
      shiftId: 'SFT-001',
      shiftName: 'Administrativo Central 8h',
      scheduleSummary: '08:30 - 17:30 (L-V)',
      startDate: DateTime(2024, 8, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-005',
      employeeId: 'EMP-005',
      employeeName: 'Jorge Marcelo Vargas Silva',
      serviceLineCode: EliteCostCenter.seg,
      siteId: 'SITE-002',
      siteName: 'Condominio Las Palmas',
      shiftId: 'SFT-002',
      shiftName: 'Seguridad 12h Diurno',
      scheduleSummary: '07:00 - 19:00 (Rotativo 4x2)',
      startDate: DateTime(2023, 3, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-006',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Callisaya Flores',
      serviceLineCode: EliteCostCenter.seg,
      siteId: 'SITE-003',
      siteName: 'Ventura Mall',
      shiftId: 'SFT-002',
      shiftName: 'Seguridad 12h Diurno',
      scheduleSummary: '07:00 - 19:00 (Rotativo 4x2)',
      startDate: DateTime(2023, 6, 20),
    ),
    EliteRosterAssignment(
      id: 'ROST-007',
      employeeId: 'EMP-007',
      employeeName: 'Franz Gonzalo Condori Choque',
      serviceLineCode: EliteCostCenter.seg,
      siteId: 'SITE-002',
      siteName: 'Condominio Las Palmas',
      shiftId: 'SFT-003',
      shiftName: 'Seguridad 12h Nocturno',
      scheduleSummary: '19:00 - 07:00 (+1d) (Rotativo 4x2)',
      startDate: DateTime(2024, 7, 10),
    ),
    EliteRosterAssignment(
      id: 'ROST-008',
      employeeId: 'EMP-008',
      employeeName: 'María Elena Flores Torrez',
      serviceLineCode: EliteCostCenter.lim,
      siteId: 'SITE-004',
      siteName: 'Centro Médico Los Pinos',
      shiftId: 'SFT-004',
      shiftName: 'Limpieza e Higiene Mañana',
      scheduleSummary: '06:00 - 14:00 (L-S)',
      startDate: DateTime(2023, 4, 10),
    ),
    EliteRosterAssignment(
      id: 'ROST-009',
      employeeId: 'EMP-009',
      employeeName: 'Juana Quispe de Alarcón',
      serviceLineCode: EliteCostCenter.lim,
      siteId: 'SITE-001',
      siteName: 'Sede Central Elite',
      shiftId: 'SFT-004',
      shiftName: 'Limpieza e Higiene Mañana',
      scheduleSummary: '06:00 - 14:00 (L-S)',
      startDate: DateTime(2023, 9, 1),
    ),
    EliteRosterAssignment(
      id: 'ROST-010',
      employeeId: 'EMP-010',
      employeeName: 'Martha Beatriz Guzmán Rojas',
      serviceLineCode: EliteCostCenter.lim,
      siteId: 'SITE-005',
      siteName: 'Planta Industrial Quillacollo',
      shiftId: 'SFT-004',
      shiftName: 'Limpieza e Higiene Mañana',
      scheduleSummary: '06:00 - 14:00 (L-S)',
      startDate: DateTime(2024, 3, 15),
    ),
    EliteRosterAssignment(
      id: 'ROST-011',
      employeeId: 'EMP-011',
      employeeName: 'Roberto Luis Céspedes Poma',
      serviceLineCode: EliteCostCenter.jar,
      siteId: 'SITE-003',
      siteName: 'Ventura Mall',
      shiftId: 'SFT-004',
      shiftName: 'Limpieza e Higiene Mañana',
      scheduleSummary: '06:00 - 14:00 (L-S)',
      startDate: DateTime(2023, 5, 18),
    ),
    EliteRosterAssignment(
      id: 'ROST-012',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      serviceLineCode: EliteCostCenter.man,
      siteId: 'SITE-004',
      siteName: 'Centro Médico Los Pinos',
      shiftId: 'SFT-001',
      shiftName: 'Administrativo Central 8h',
      scheduleSummary: '08:00 - 16:00 (L-V)',
      startDate: DateTime(2023, 11, 5),
    ),
  ];

  List<EliteShift> getShifts() => List.unmodifiable(_shifts);
  List<EliteClientSite> getClientSites() => List.unmodifiable(_clientSites);
  List<EliteRosterAssignment> getRosterAssignments() =>
      List.unmodifiable(_rosterAssignments);

  void addShift(EliteShift shift) {
    _shifts.add(shift);
  }

  void addClientSite(EliteClientSite site) {
    _clientSites.add(site);
  }

  void addRosterAssignment(EliteRosterAssignment assignment) {
    _rosterAssignments.insert(0, assignment);
  }

  void rotateRosterAssignment(String id, String newSiteId, String newSiteName) {
    final idx = _rosterAssignments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _rosterAssignments[idx] = _rosterAssignments[idx].copyWith(
        siteId: newSiteId,
        siteName: newSiteName,
        status: 'rotado',
      );
    }
  }

  void reassignShift(String id, String newShiftId, String newShiftName, String newSchedule) {
    final idx = _rosterAssignments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _rosterAssignments[idx] = _rosterAssignments[idx].copyWith(
        shiftId: newShiftId,
        shiftName: newShiftName,
        scheduleSummary: newSchedule,
      );
    }
  }

  void addEmployee(EliteEmployee emp) {
    _employees.insert(0, emp);
  }

  void updateEmployee(EliteEmployee emp) {
    final idx = _employees.indexWhere((e) => e.id == emp.id);
    if (idx != -1) {
      _employees[idx] = emp;
    }
  }

  void terminateEmployee(String id) {
    final idx = _employees.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _employees[idx] = _employees[idx].copyWith(status: EmployeeStatus.deBaja);
    }
  }

  // ===========================================================================
  // SUBMÓDULO 3: REGISTROS DE ASISTENCIA DUAL (OFICINA Y APK CAMPO)
  // ===========================================================================
  final List<EliteAttendanceRecord> _attendanceRecords = [
    // -------------------------------------------------------------------------
    // 4 REGISTROS DE OFICINA (SEDE CENTRAL)
    // -------------------------------------------------------------------------
    EliteAttendanceRecord(
      id: 'ATT-2026-001',
      employeeId: 'EMP-001',
      employeeName: 'Carlos Andrés Mamani Quispe',
      employeeJobTitle: 'Contador General',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.adm,
      assignedSite: 'Sede Central Equipetrol',
      shiftName: 'Administrativo Central 8h',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 8, 28),
      source: AttendanceSource.webOficina,
      evaluation: AttendanceEvaluation.puntual,
      lateMinutes: 0,
      ipAddress: '192.168.1.45',
      deviceBrowser: 'Chrome 129 • Win64 (Estación RRHH-Central-01)',
      geofenceStatus: GeofenceStatus.noAplica,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-002',
      employeeId: 'EMP-002',
      employeeName: 'Paola Andrea Torrico Vaca',
      employeeJobTitle: 'Encargada de Recursos Humanos',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.rrhh,
      assignedSite: 'Sede Central Equipetrol',
      shiftName: 'Administrativo Central 8h',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 8, 35),
      source: AttendanceSource.webOficina,
      evaluation: AttendanceEvaluation.enJornada,
      lateMinutes: 0,
      ipAddress: '192.168.1.52',
      deviceBrowser: 'Edge 128 • Win64 (Estación RRHH-Central-02)',
      geofenceStatus: GeofenceStatus.noAplica,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      employeeJobTitle: 'Ejecutivo Comercial B2B',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.com,
      assignedSite: 'Sede Central Equipetrol',
      shiftName: 'Administrativo Central 8h',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 8, 48),
      source: AttendanceSource.webOficina,
      evaluation: AttendanceEvaluation.retraso,
      lateMinutes: 8,
      ipAddress: '192.168.1.61',
      deviceBrowser: 'Chrome 129 • Win64 (Estación COM-01)',
      geofenceStatus: GeofenceStatus.noAplica,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-004',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      employeeJobTitle: 'Especialista en Marketing',
      workplaceType: EmployeeWorkplaceType.oficina,
      serviceLineCode: EliteCostCenter.com,
      assignedSite: 'Sede Central Equipetrol',
      shiftName: 'Administrativo Central 8h',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 8, 0),
      source: AttendanceSource.webOficina,
      evaluation: AttendanceEvaluation.faltaInjustificada,
      lateMinutes: 0,
      ipAddress: null,
      deviceBrowser: null,
      geofenceStatus: GeofenceStatus.noAplica,
    ),

    // -------------------------------------------------------------------------
    // 8 REGISTROS DE CAMPO (APK MÓVIL)
    // -------------------------------------------------------------------------
    EliteAttendanceRecord(
      id: 'ATT-2026-005',
      employeeId: 'EMP-005',
      employeeName: 'Jorge Marcelo Vargas Silva',
      employeeJobTitle: 'Guardia de Seguridad',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      assignedSite: 'Condominio Las Palmas',
      shiftName: 'Seguridad 12h Diurno',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 6, 55),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.puntual,
      lateMinutes: 0,
      latitude: -17.7942,
      longitude: -63.1953,
      distanceToSiteMeters: 12.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-006',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Gonzalo Callisaya Choque',
      employeeJobTitle: 'Guardia de Seguridad',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      assignedSite: 'Ventura Mall',
      shiftName: 'Seguridad 12h Diurno',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 7, 8),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.retraso,
      lateMinutes: 3,
      latitude: -17.7558,
      longitude: -63.1782,
      distanceToSiteMeters: 25.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-007',
      employeeId: 'EMP-007',
      employeeName: 'Franz David Condori Mamani',
      employeeJobTitle: 'Guardia de Seguridad Nocturno',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.seg,
      assignedSite: 'Condominio Las Palmas',
      shiftName: 'Seguridad 12h Nocturno',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 19, 0),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.enJornada,
      lateMinutes: 0,
      latitude: -17.7940,
      longitude: -63.1950,
      distanceToSiteMeters: 15.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-008',
      employeeId: 'EMP-008',
      employeeName: 'María Elena Flores Benítez',
      employeeJobTitle: 'Operaria de Limpieza',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      assignedSite: 'Centro Médico Los Pinos',
      shiftName: 'Limpieza e Higiene Mañana',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 5, 58),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.puntual,
      lateMinutes: 0,
      latitude: -17.7712,
      longitude: -63.1610,
      distanceToSiteMeters: 8.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-009',
      employeeId: 'EMP-009',
      employeeName: 'Juana Inés Quispe Huanca',
      employeeJobTitle: 'Operaria de Limpieza',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      assignedSite: 'Sede Central Equipetrol',
      shiftName: 'Limpieza e Higiene Mañana',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 6, 18),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.retraso,
      lateMinutes: 13,
      latitude: -17.7761,
      longitude: -63.1951,
      distanceToSiteMeters: 18.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-010',
      employeeId: 'EMP-010',
      employeeName: 'Martha Roxana Guzmán Claros',
      employeeJobTitle: 'Supervisora de Limpieza',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.lim,
      assignedSite: 'Parque Industrial Quillacollo',
      shiftName: 'Limpieza e Higiene Mañana',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 6, 5),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.puntual,
      lateMinutes: 0,
      latitude: -17.7420,
      longitude: -63.1480,
      distanceToSiteMeters: 145.0,
      geofenceStatus: GeofenceStatus.fueraDePerimetro,
      isOfflineSync: false,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-011',
      employeeId: 'EMP-011',
      employeeName: 'Roberto Luis Céspedes Poma',
      employeeJobTitle: 'Jardinero Especialista',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.jar,
      assignedSite: 'Ventura Mall',
      shiftName: 'Limpieza e Higiene Mañana',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 7, 0),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.puntual,
      lateMinutes: 0,
      latitude: -17.7560,
      longitude: -63.1780,
      distanceToSiteMeters: 22.0,
      geofenceStatus: GeofenceStatus.dentroDeRadio,
      isOfflineSync: true,
    ),
    EliteAttendanceRecord(
      id: 'ATT-2026-012',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      employeeJobTitle: 'Técnico de Mantenimiento',
      workplaceType: EmployeeWorkplaceType.campo,
      serviceLineCode: EliteCostCenter.man,
      assignedSite: 'Centro Médico Los Pinos',
      shiftName: 'Administrativo Central 8h',
      punchType: AttendancePunchType.entrada,
      timestamp: DateTime(2026, 10, 6, 8, 0),
      source: AttendanceSource.apkCampoGps,
      evaluation: AttendanceEvaluation.faltaInjustificada,
      lateMinutes: 0,
      geofenceStatus: GeofenceStatus.noAplica,
      isOfflineSync: false,
    ),
  ];

  List<EliteAttendanceRecord> getAttendanceRecords() =>
      List.unmodifiable(_attendanceRecords);

  void addAttendanceRecord(EliteAttendanceRecord record) {
    _attendanceRecords.insert(0, record);
  }

  void updateAttendanceRecord(EliteAttendanceRecord record) {
    final idx = _attendanceRecords.indexWhere((r) => r.id == record.id);
    if (idx != -1) {
      _attendanceRecords[idx] = record;
    }
  }

  void consolidateFieldSync() {
    for (int i = 0; i < _attendanceRecords.length; i++) {
      if (_attendanceRecords[i].isOfflineSync) {
        _attendanceRecords[i] = _attendanceRecords[i].copyWith(
          isOfflineSync: false,
        );
      }
    }
  }

  EliteAttendanceRecord recordOfficePunch({
    required String employeeId,
    required bool isClockOut,
    required DateTime timestamp,
    required String ipAddress,
    required String workstation,
  }) {
    final emp = _employees.firstWhere(
      (e) => e.id == employeeId,
      orElse: () => _employees.first,
    );

    final existingIdx = _attendanceRecords.indexWhere(
      (r) => r.employeeId == employeeId &&
             r.timestamp.year == timestamp.year &&
             r.timestamp.month == timestamp.month &&
             r.timestamp.day == timestamp.day,
    );

    if (existingIdx != -1) {
      final existing = _attendanceRecords[existingIdx];
      if (isClockOut) {
        final updated = existing.copyWith(
          checkOutTimestamp: timestamp,
          punchType: AttendancePunchType.salida,
          evaluation: AttendanceEvaluation.jornadaCompletada,
        );
        _attendanceRecords[existingIdx] = updated;
        return updated;
      } else {
        final updated = existing.copyWith(
          timestamp: timestamp,
          punchType: AttendancePunchType.entrada,
          ipAddress: ipAddress,
          deviceBrowser: 'Edge 128 • Win64 ($workstation)',
          evaluation: AttendanceEvaluation.enJornada,
        );
        _attendanceRecords[existingIdx] = updated;
        return updated;
      }
    } else {
      final newRecord = EliteAttendanceRecord(
        id: 'ATT-2026-${(_attendanceRecords.length + 1).toString().padLeft(3, '0')}',
        employeeId: emp.id,
        employeeName: emp.fullName,
        employeeJobTitle: emp.position,
        workplaceType: emp.workplaceType,
        serviceLineCode: emp.serviceLineCode,
        assignedSite: emp.assignedSite,
        shiftName: 'Administrativo Central 8h',
        punchType: isClockOut
            ? AttendancePunchType.salida
            : AttendancePunchType.entrada,
        timestamp: timestamp,
        checkOutTimestamp: isClockOut ? timestamp : null,
        source: AttendanceSource.webOficina,
        evaluation: isClockOut
            ? AttendanceEvaluation.jornadaCompletada
            : AttendanceEvaluation.enJornada,
        lateMinutes: 0,
        ipAddress: ipAddress,
        deviceBrowser: 'Edge 128 • Win64 ($workstation)',
        geofenceStatus: GeofenceStatus.noAplica,
      );
      _attendanceRecords.insert(0, newRecord);
      return newRecord;
    }
  }

  // ===========================================================================
  // SUBMÓDULO 4: NOVEDADES E INCIDENCIAS (PERMISOS, SANCIONES Y VACACIONES)
  // ===========================================================================
  final List<EliteLeaveRequest> _leaveRequests = [
    EliteLeaveRequest(
      id: 'LIC-2026-001',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      serviceLineCode: EliteCostCenter.man,
      workplaceType: EmployeeWorkplaceType.campo,
      leaveType: LeaveType.bajaMedica,
      startDate: DateTime(2026, 10, 6),
      endDate: DateTime(2026, 10, 8),
      totalDays: 3,
      reason: 'Baja médica SUS por lumbociática aguda comprobada en puesto.',
      paymentStatus: LeavePaymentStatus.conGoce,
      status: LeaveRequestStatus.pendiente,
      source: 'APK Móvil Campo',
    ),
    EliteLeaveRequest(
      id: 'LIC-2026-002',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      leaveType: LeaveType.tramiteParticular,
      startDate: DateTime(2026, 10, 7),
      endDate: DateTime(2026, 10, 7),
      totalDays: 1,
      reason: 'Trámite notarial y bancario de documentación contractual.',
      paymentStatus: LeavePaymentStatus.sinGoce,
      status: LeaveRequestStatus.aprobado,
      source: 'Portal Oficina',
    ),
    EliteLeaveRequest(
      id: 'LIC-2026-003',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Gonzalo Callisaya Choque',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      leaveType: LeaveType.duelo,
      startDate: DateTime(2026, 10, 2),
      endDate: DateTime(2026, 10, 4),
      totalDays: 3,
      reason: 'Fallecimiento de familiar de primer grado (Certificado presentado).',
      paymentStatus: LeavePaymentStatus.conGoce,
      status: LeaveRequestStatus.aprobado,
      source: 'APK Móvil Campo',
    ),
    EliteLeaveRequest(
      id: 'LIC-2026-004',
      employeeId: 'EMP-007',
      employeeName: 'Franz David Condori Mamani',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      leaveType: LeaveType.tramiteParticular,
      startDate: DateTime(2026, 10, 8),
      endDate: DateTime(2026, 10, 8),
      totalDays: 1,
      reason: 'Asunto familiar particular en turno nocturno.',
      paymentStatus: LeavePaymentStatus.sinGoce,
      status: LeaveRequestStatus.rechazado,
      source: 'APK Móvil Campo',
    ),
  ];

  final List<EliteTardinessPenalty> _tardinessPenalties = [
    EliteTardinessPenalty(
      id: 'PEN-2026-001',
      employeeId: 'EMP-001',
      employeeName: 'Carlos Andrés Mamani Quispe',
      employeeJobTitle: 'Contador General',
      serviceLineCode: EliteCostCenter.adm,
      workplaceType: EmployeeWorkplaceType.oficina,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-002',
      employeeId: 'EMP-002',
      employeeName: 'Paola Andrea Torrico Vaca',
      employeeJobTitle: 'Encargada de Recursos Humanos',
      serviceLineCode: EliteCostCenter.rrhh,
      workplaceType: EmployeeWorkplaceType.oficina,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      employeeJobTitle: 'Ejecutivo Comercial B2B',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 24,
      unexcusedAbsences: 0,
      penaltyAmountBs: 35.00,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-004',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      employeeJobTitle: 'Especialista en Marketing',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 1,
      penaltyAmountBs: 126.67,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-005',
      employeeId: 'EMP-005',
      employeeName: 'Jorge Marcelo Vargas Silva',
      employeeJobTitle: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-006',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Gonzalo Callisaya Choque',
      employeeJobTitle: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 18,
      unexcusedAbsences: 0,
      penaltyAmountBs: 21.75,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-007',
      employeeId: 'EMP-007',
      employeeName: 'Franz David Condori Mamani',
      employeeJobTitle: 'Guardia de Seguridad Nocturno',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-008',
      employeeId: 'EMP-008',
      employeeName: 'María Elena Flores Benítez',
      employeeJobTitle: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-009',
      employeeId: 'EMP-009',
      employeeName: 'Juana Inés Quispe Huanca',
      employeeJobTitle: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 39,
      unexcusedAbsences: 0,
      penaltyAmountBs: 32.50,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-010',
      employeeId: 'EMP-010',
      employeeName: 'Martha Roxana Guzmán Claros',
      employeeJobTitle: 'Supervisora de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-011',
      employeeId: 'EMP-011',
      employeeName: 'Roberto Luis Céspedes Poma',
      employeeJobTitle: 'Jardinero Especialista',
      serviceLineCode: EliteCostCenter.jar,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 0,
      penaltyAmountBs: 0.0,
    ),
    EliteTardinessPenalty(
      id: 'PEN-2026-012',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      employeeJobTitle: 'Técnico de Mantenimiento',
      serviceLineCode: EliteCostCenter.man,
      workplaceType: EmployeeWorkplaceType.campo,
      monthPeriod: 'Octubre 2026',
      totalLateMinutes: 0,
      unexcusedAbsences: 2,
      penaltyAmountBs: 269.58,
    ),
  ];

  final List<EliteVacationRecord> _vacationRecords = [
    EliteVacationRecord(
      id: 'VAC-001',
      employeeId: 'EMP-001',
      employeeName: 'Carlos Andrés Mamani Quispe',
      employeeJobTitle: 'Contador General',
      serviceLineCode: EliteCostCenter.adm,
      hireDate: DateTime(2022, 3, 1),
      yearsOfService: 4,
      legalDaysTotal: 15,
      daysUsed: 5,
      daysRemaining: 10,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-002',
      employeeId: 'EMP-002',
      employeeName: 'Paola Andrea Torrico Vaca',
      employeeJobTitle: 'Encargada de Recursos Humanos',
      serviceLineCode: EliteCostCenter.rrhh,
      hireDate: DateTime(2022, 8, 15),
      yearsOfService: 4,
      legalDaysTotal: 15,
      daysUsed: 0,
      daysRemaining: 15,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      employeeJobTitle: 'Ejecutivo Comercial B2B',
      serviceLineCode: EliteCostCenter.com,
      hireDate: DateTime(2023, 2, 10),
      yearsOfService: 3,
      legalDaysTotal: 15,
      daysUsed: 3,
      daysRemaining: 12,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-004',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      employeeJobTitle: 'Especialista en Marketing',
      serviceLineCode: EliteCostCenter.com,
      hireDate: DateTime(2024, 8, 1),
      yearsOfService: 2,
      legalDaysTotal: 15,
      daysUsed: 0,
      daysRemaining: 15,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-005',
      employeeId: 'EMP-005',
      employeeName: 'Jorge Marcelo Vargas Silva',
      employeeJobTitle: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      hireDate: DateTime(2023, 1, 15),
      yearsOfService: 3,
      legalDaysTotal: 15,
      daysUsed: 10,
      daysRemaining: 5,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-006',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Gonzalo Callisaya Choque',
      employeeJobTitle: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      hireDate: DateTime(2022, 5, 20),
      yearsOfService: 4,
      legalDaysTotal: 15,
      daysUsed: 7,
      daysRemaining: 8,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-007',
      employeeId: 'EMP-007',
      employeeName: 'Franz David Condori Mamani',
      employeeJobTitle: 'Guardia de Seguridad Nocturno',
      serviceLineCode: EliteCostCenter.seg,
      hireDate: DateTime(2023, 7, 10),
      yearsOfService: 3,
      legalDaysTotal: 15,
      daysUsed: 0,
      daysRemaining: 15,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-008',
      employeeId: 'EMP-008',
      employeeName: 'María Elena Flores Benítez',
      employeeJobTitle: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      hireDate: DateTime(2021, 4, 12),
      yearsOfService: 5,
      legalDaysTotal: 20,
      daysUsed: 12,
      daysRemaining: 8,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-009',
      employeeId: 'EMP-009',
      employeeName: 'Juana Inés Quispe Huanca',
      employeeJobTitle: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      hireDate: DateTime(2022, 11, 1),
      yearsOfService: 3,
      legalDaysTotal: 15,
      daysUsed: 5,
      daysRemaining: 10,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-010',
      employeeId: 'EMP-010',
      employeeName: 'Martha Roxana Guzmán Claros',
      employeeJobTitle: 'Supervisora de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      hireDate: DateTime(2020, 2, 15),
      yearsOfService: 6,
      legalDaysTotal: 20,
      daysUsed: 8,
      daysRemaining: 12,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-011',
      employeeId: 'EMP-011',
      employeeName: 'Roberto Luis Céspedes Poma',
      employeeJobTitle: 'Jardinero Especialista',
      serviceLineCode: EliteCostCenter.jar,
      hireDate: DateTime(2023, 5, 18),
      yearsOfService: 3,
      legalDaysTotal: 15,
      daysUsed: 0,
      daysRemaining: 15,
      currentRequest: null,
    ),
    EliteVacationRecord(
      id: 'VAC-012',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      employeeJobTitle: 'Técnico de Mantenimiento',
      serviceLineCode: EliteCostCenter.man,
      hireDate: DateTime(2023, 11, 5),
      yearsOfService: 2,
      legalDaysTotal: 15,
      daysUsed: 0,
      daysRemaining: 15,
      currentRequest: null,
    ),
  ];

  List<EliteLeaveRequest> getLeaveRequests() =>
      List.unmodifiable(_leaveRequests);

  List<EliteTardinessPenalty> getTardinessPenalties() =>
      List.unmodifiable(_tardinessPenalties);

  List<EliteVacationRecord> getVacationRecords() =>
      List.unmodifiable(_vacationRecords);

  void addLeaveRequest(EliteLeaveRequest request) {
    _leaveRequests.insert(0, request);
  }

  void updateLeaveRequestStatus(
    String id,
    LeaveRequestStatus status,
    LeavePaymentStatus paymentStatus,
  ) {
    final idx = _leaveRequests.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _leaveRequests[idx] = _leaveRequests[idx].copyWith(
        status: status,
        paymentStatus: paymentStatus,
      );
    }
  }

  void scheduleVacation(
    String employeeId,
    DateTime start,
    DateTime end,
    int days,
  ) {
    final idx = _vacationRecords.indexWhere((v) => v.employeeId == employeeId);
    if (idx != -1) {
      final current = _vacationRecords[idx];
      final newRemaining = (current.daysRemaining - days).clamp(0, current.legalDaysTotal);
      final newUsed = current.daysUsed + days;
      final startStr = '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
      final endStr = '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
      _vacationRecords[idx] = current.copyWith(
        daysUsed: newUsed,
        daysRemaining: newRemaining,
        currentRequest: 'Programada: $startStr al $endStr ($days días)',
      );
    }
  }

  // ===========================================================================
  // SUBMÓDULO 5: NÓMINA, PRE-PLANILLA Y ASIENTO CONTABLE
  // ===========================================================================
  final List<ElitePayrollItem> _payrollItems = [
    ElitePayrollItem(
      id: 'PAY-2026-10-001',
      employeeId: 'EMP-001',
      employeeName: 'Carlos Andrés Mamani Quispe',
      ci: '4892831 LP',
      position: 'Contador General',
      serviceLineCode: EliteCostCenter.adm,
      workplaceType: EmployeeWorkplaceType.oficina,
      baseSalary: 5500.0,
      seniorityBonus: 375.0,
      totalEarned: 5875.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 746.71,
      totalDeductions: 746.71,
      netPayable: 5128.29,
      bankAccount: 'BNB Cta. 2000-4892831',
      hireDate: DateTime(2022, 3, 1),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-002',
      employeeId: 'EMP-002',
      employeeName: 'Paola Andrea Torrico Vaca',
      ci: '5932189 CB',
      position: 'Encargada de Recursos Humanos',
      serviceLineCode: EliteCostCenter.rrhh,
      workplaceType: EmployeeWorkplaceType.oficina,
      baseSalary: 4800.0,
      seniorityBonus: 375.0,
      totalEarned: 5175.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 657.74,
      totalDeductions: 657.74,
      netPayable: 4517.26,
      bankAccount: 'BCP Cta. 350-5932189',
      hireDate: DateTime(2022, 8, 15),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      ci: '6201948 SC',
      position: 'Ejecutivo Comercial B2B',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      baseSalary: 4200.0,
      seniorityBonus: 375.0,
      totalEarned: 4575.0,
      penaltyDeductions: 35.0,
      gestoraDeduction: 581.48,
      totalDeductions: 616.48,
      netPayable: 3958.52,
      bankAccount: 'Mercantil Cta. 401-6201948',
      hireDate: DateTime(2023, 2, 10),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-004',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      ci: '7192843 LP',
      position: 'Especialista en Marketing',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      baseSalary: 3800.0,
      seniorityBonus: 375.0,
      totalEarned: 4175.0,
      penaltyDeductions: 126.67,
      gestoraDeduction: 530.64,
      totalDeductions: 657.31,
      netPayable: 3517.69,
      bankAccount: 'Ganadero Cta. 105-7192843',
      hireDate: DateTime(2024, 8, 1),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-005',
      employeeId: 'EMP-005',
      employeeName: 'Jorge Marcelo Vargas Silva',
      ci: '4928172 LP',
      position: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 2900.0,
      seniorityBonus: 375.0,
      totalEarned: 3275.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 416.25,
      totalDeductions: 416.25,
      netPayable: 2858.75,
      bankAccount: 'BNB Cta. 2000-4928172',
      hireDate: DateTime(2023, 1, 15),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-006',
      employeeId: 'EMP-006',
      employeeName: 'Ramiro Gonzalo Callisaya Choque',
      ci: '5819201 LP',
      position: 'Guardia de Seguridad',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 2900.0,
      seniorityBonus: 375.0,
      totalEarned: 3275.0,
      penaltyDeductions: 21.75,
      gestoraDeduction: 416.25,
      totalDeductions: 438.0,
      netPayable: 2837.0,
      bankAccount: 'Unión Cta. 100-5819201',
      hireDate: DateTime(2022, 5, 20),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-007',
      employeeId: 'EMP-007',
      employeeName: 'Franz David Condori Mamani',
      ci: '6102938 SC',
      position: 'Guardia de Seguridad Nocturno',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 3100.0,
      seniorityBonus: 375.0,
      totalEarned: 3475.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 441.67,
      totalDeductions: 441.67,
      netPayable: 3033.33,
      bankAccount: 'BCP Cta. 350-6102938',
      hireDate: DateTime(2023, 7, 10),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-008',
      employeeId: 'EMP-008',
      employeeName: 'María Elena Flores Benítez',
      ci: '3948201 CB',
      position: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 2600.0,
      seniorityBonus: 825.0,
      totalEarned: 3425.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 435.32,
      totalDeductions: 435.32,
      netPayable: 2989.68,
      bankAccount: 'Mercantil Cta. 401-3948201',
      hireDate: DateTime(2021, 4, 12),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-009',
      employeeId: 'EMP-009',
      employeeName: 'Juana Inés Quispe Huanca',
      ci: '4819204 LP',
      position: 'Operaria de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 2600.0,
      seniorityBonus: 375.0,
      totalEarned: 2975.0,
      penaltyDeductions: 32.50,
      gestoraDeduction: 378.12,
      totalDeductions: 410.62,
      netPayable: 2564.38,
      bankAccount: 'Unión Cta. 100-4819204',
      hireDate: DateTime(2022, 11, 1),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-010',
      employeeId: 'EMP-010',
      employeeName: 'Martha Roxana Guzmán Claros',
      ci: '3829104 SC',
      position: 'Supervisora de Limpieza',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 3200.0,
      seniorityBonus: 825.0,
      totalEarned: 4025.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 511.58,
      totalDeductions: 511.58,
      netPayable: 3513.42,
      bankAccount: 'BNB Cta. 2000-3829104',
      hireDate: DateTime(2020, 2, 15),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-011',
      employeeId: 'EMP-011',
      employeeName: 'Roberto Luis Céspedes Poma',
      ci: '5920194 CB',
      position: 'Jardinero Especialista',
      serviceLineCode: EliteCostCenter.jar,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 2700.0,
      seniorityBonus: 375.0,
      totalEarned: 3075.0,
      penaltyDeductions: 0.0,
      gestoraDeduction: 390.83,
      totalDeductions: 390.83,
      netPayable: 2684.17,
      bankAccount: 'Ganadero Cta. 105-5920194',
      hireDate: DateTime(2023, 5, 18),
    ),
    ElitePayrollItem(
      id: 'PAY-2026-10-012',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      ci: '6192840 SC',
      position: 'Técnico de Mantenimiento',
      serviceLineCode: EliteCostCenter.man,
      workplaceType: EmployeeWorkplaceType.campo,
      baseSalary: 3000.0,
      seniorityBonus: 375.0,
      totalEarned: 3375.0,
      penaltyDeductions: 269.58,
      gestoraDeduction: 428.96,
      totalDeductions: 698.54,
      netPayable: 2676.46,
      bankAccount: 'BCP Cta. 350-6192840',
      hireDate: DateTime(2023, 11, 5),
    ),
  ];

  ElitePayrollPeriodSummary _payrollSummary = const ElitePayrollPeriodSummary(
    period: 'Octubre 2026',
    totalBaseSalary: 41300.0,
    totalSeniorityBonus: 5400.0,
    grossPayroll: 46700.0,
    totalPenaltiesDeducted: 485.50,
    totalGestoraContributions: 5935.57,
    netPayrollPayable: 40278.93,
    status: 'Borrador Pre-Planilla',
  );

  List<ElitePayrollItem> getPayrollItems() =>
      List.unmodifiable(_payrollItems);

  ElitePayrollPeriodSummary getPayrollSummary() => _payrollSummary;

  List<EliteAccountingEntryItem> getAccountingEntries() {
    return const [
      // CUENTAS DE GASTO (DEBE) POR CENTRO DE COSTO
      EliteAccountingEntryItem(
        accountCode: '5-1-01-01',
        accountName: 'Sueldos y Salarios Operativos Seguridad',
        costCenter: EliteCostCenter.seg,
        debit: 10025.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-1-01-02',
        accountName: 'Sueldos y Salarios Operativos Limpieza',
        costCenter: EliteCostCenter.lim,
        debit: 10425.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-1-01-03',
        accountName: 'Sueldos y Salarios Operativos Jardinería',
        costCenter: EliteCostCenter.jar,
        debit: 3075.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-1-01-04',
        accountName: 'Sueldos y Salarios Operativos Mantenimiento',
        costCenter: EliteCostCenter.man,
        debit: 3375.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-2-01-01',
        accountName: 'Sueldos y Salarios Administrativos',
        costCenter: EliteCostCenter.adm,
        debit: 5875.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-2-01-02',
        accountName: 'Sueldos y Salarios Comerciales / Ventas',
        costCenter: EliteCostCenter.com,
        debit: 8750.00,
        credit: 0.0,
      ),
      EliteAccountingEntryItem(
        accountCode: '5-2-01-03',
        accountName: 'Sueldos y Salarios Recursos Humanos',
        costCenter: EliteCostCenter.rrhh,
        debit: 5175.00,
        credit: 0.0,
      ),

      // CUENTAS DE PASIVO Y DEDUCCIONES (HABER)
      EliteAccountingEntryItem(
        accountCode: '2-1-02-01',
        accountName: 'Retenciones Laborales Gestora Pública (12.71%)',
        costCenter: 'CONSOLIDADO',
        debit: 0.0,
        credit: 5935.57,
      ),
      EliteAccountingEntryItem(
        accountCode: '2-1-02-02',
        accountName: 'Multas y Sanciones por Asistencia (Recupero)',
        costCenter: 'CONSOLIDADO',
        debit: 0.0,
        credit: 485.50,
      ),
      EliteAccountingEntryItem(
        accountCode: '2-1-02-03',
        accountName: 'Sueldos y Salarios por Pagar (Líquido Bancos)',
        costCenter: 'CONSOLIDADO',
        debit: 0.0,
        credit: 40278.93,
      ),
    ];
  }

  void closePayrollPeriodAndGenerateVoucher() {
    _payrollSummary = _payrollSummary.copyWith(
      status: 'Planilla Cerrada y Asentada',
      accountingVoucherNumber: 'CT-2026-0003',
    );
  }

  void updatePayrollItem(ElitePayrollItem item) {
    final idx = _payrollItems.indexWhere((p) => p.id == item.id);
    if (idx != -1) {
      _payrollItems[idx] = item;
    }
  }

  // ===========================================================================
  // SUBMÓDULO 6: RÉGIMEN DISCIPLINARIO, FINIQUITOS Y AUDITORÍA INMUTABLE
  // ===========================================================================
  final List<EliteDisciplinaryRecord> _disciplinaryRecords = [
    EliteDisciplinaryRecord(
      id: 'DISC-2026-001',
      employeeId: 'EMP-007',
      employeeName: 'Franz Gonzalo Condori Choque',
      serviceLineCode: EliteCostCenter.seg,
      workplaceType: EmployeeWorkplaceType.campo,
      date: DateTime(2026, 9, 28),
      severity: DisciplinarySeverity.grave,
      infractionType: 'Abandono de puesto sin relevo',
      description:
          'El colaborador abandonó la garita de vigilancia perimetral en Condominio Las Palmas 25 minutos antes del arribo del relevo nocturno formal.',
      memorandumCode: 'MEMO-2026-014',
      sanction: 'Suspensión de 1 día y amonestación severa a legajo',
    ),
    EliteDisciplinaryRecord(
      id: 'DISC-2026-002',
      employeeId: 'EMP-010',
      employeeName: 'Martha Beatriz Guzmán Rojas',
      serviceLineCode: EliteCostCenter.lim,
      workplaceType: EmployeeWorkplaceType.campo,
      date: DateTime(2026, 10, 1),
      severity: DisciplinarySeverity.grave,
      infractionType: 'Marcación fuera de perímetro GPS',
      description:
          'Marcación registrada en la APK a 145 metros de distancia del perímetro pactado en Planta Industrial Quillacollo sin autorización del supervisor.',
      memorandumCode: 'MEMO-2026-015',
      sanction: 'Llamada de atención severa con apercibimiento formal',
    ),
    EliteDisciplinaryRecord(
      id: 'DISC-2026-003',
      employeeId: 'EMP-003',
      employeeName: 'Alejandro Siles Morales',
      serviceLineCode: EliteCostCenter.com,
      workplaceType: EmployeeWorkplaceType.oficina,
      date: DateTime(2026, 10, 3),
      severity: DisciplinarySeverity.leve,
      infractionType: 'Atrasos reiterados en jornada',
      description:
          'Acumulación no justificada de 3 atrasos consecutivos superando los 45 minutos durante la semana laboral en Oficina Central.',
      memorandumCode: 'MEMO-2026-016',
      sanction: 'Amonestación escrita y deducción reglamentaria',
    ),
    EliteDisciplinaryRecord(
      id: 'DISC-2026-004',
      employeeId: 'EMP-012',
      employeeName: 'José Miguel Arancibia Vera',
      serviceLineCode: EliteCostCenter.man,
      workplaceType: EmployeeWorkplaceType.campo,
      date: DateTime(2026, 10, 4),
      severity: DisciplinarySeverity.muyGrave,
      infractionType: 'Incumplimiento de normas de seguridad (EPP)',
      description:
          'Intervención en cuadro de fuerza eléctrica en Centro Médico Los Pinos sin guantes dieléctricos ni lentes de protección reglamentarios.',
      memorandumCode: 'MEMO-2026-017',
      sanction: 'Suspensión de 3 días con informe a Ministerio de Trabajo',
    ),
  ];

  final List<EliteTerminationSettlement> _settlements = [
    EliteTerminationSettlement(
      id: 'FIN-2026-001',
      employeeId: 'EMP-004',
      employeeName: 'Valeria Sofía Rocha Peñaranda',
      ci: '7192843 LP',
      serviceLineCode: EliteCostCenter.com,
      position: 'Especialista en Marketing',
      hireDate: DateTime(2024, 8, 1),
      terminationDate: DateTime(2026, 9, 30),
      reason: TerminationReason.finDeContrato,
      yearsWorked: 2,
      monthsWorked: 2,
      daysWorked: 0,
      averageSalary: 3800.0,
      severancePay: 0.0,
      indemnityPay: 8233.33,
      proportionalBonus: 2850.00,
      vacationPay: 3166.67,
      totalSettlement: 14250.00,
      status: 'Aprobado',
    ),
    EliteTerminationSettlement(
      id: 'FIN-2026-002',
      employeeId: 'EMP-009',
      employeeName: 'Juana Quispe de Alarcón',
      ci: '7483921 SC',
      serviceLineCode: EliteCostCenter.lim,
      position: 'Operario de Limpieza',
      hireDate: DateTime(2023, 9, 1),
      terminationDate: DateTime(2026, 10, 5),
      reason: TerminationReason.renunciaVoluntaria,
      yearsWorked: 3,
      monthsWorked: 1,
      daysWorked: 5,
      averageSalary: 2550.0,
      severancePay: 0.0,
      indemnityPay: 7862.50,
      proportionalBonus: 1912.50,
      vacationPay: 1275.00,
      totalSettlement: 11050.00,
      status: 'Borrador',
    ),
  ];

  final List<EliteRrhhAuditLog> _auditLogs = [
    EliteRrhhAuditLog(
      id: 'LOG-2026-001',
      timestamp: DateTime(2026, 10, 6, 8, 30, 15),
      userName: 'Paola Torrico',
      action: 'APERTURA_SISTEMA',
      reference: 'SYS-SEC',
      detail:
          'Inicio de sesión administrativo verificado con doble factor en Sede Central.',
      sha256Hash:
          'a4f9b8c2d1e0f394857b6a1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-002',
      timestamp: DateTime(2026, 10, 6, 8, 45, 22),
      userName: 'Paola Torrico',
      action: 'SINCRONIZACION_ASISTENCIA',
      reference: 'ATT-FIELD',
      detail:
          'Sincronización de 8 marcaciones satelitales de cuadrillas de campo desde APK móvil.',
      sha256Hash:
          '7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-003',
      timestamp: DateTime(2026, 10, 6, 9, 15, 04),
      userName: 'Paola Torrico',
      action: 'EMISION_MEMORANDUM',
      reference: 'MEMO-2026-017',
      detail:
          'Emisión de memorándum muy grave por omisión de EPP en José Miguel Arancibia.',
      sha256Hash:
          '9e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-004',
      timestamp: DateTime(2026, 10, 6, 10, 20, 50),
      userName: 'Paola Torrico',
      action: 'APROBACION_PERMISO',
      reference: 'SOL-2026-004',
      detail:
          'Aprobación de baja médica SUS/CNS por 5 días para colaboradora Martha Guzmán.',
      sha256Hash:
          '3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-005',
      timestamp: DateTime(2026, 10, 6, 11, 02, 18),
      userName: 'Paola Torrico',
      action: 'CALCULO_FINIQUITO',
      reference: 'FIN-2026-001',
      detail:
          'Liquidación oficial por conclusión de contrato a plazo fijo por Bs. 14,250.00.',
      sha256Hash:
          '8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-006',
      timestamp: DateTime(2026, 10, 6, 12, 30, 44),
      userName: 'Paola Torrico',
      action: 'CIERRE_PREPLANILLA',
      reference: 'PRE-2026-10',
      detail:
          'Cierre y consolidación de pre-planilla de Octubre 2026 para 12 colaboradores.',
      sha256Hash:
          '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-007',
      timestamp: DateTime(2026, 10, 6, 14, 10, 31),
      userName: 'Paola Torrico',
      action: 'GENERACION_ASIENTO',
      reference: 'CT-2026-0003',
      detail:
          'Generación de comprobante contable de devengamiento de sueldos para ERP Finanzas.',
      sha256Hash:
          '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f',
    ),
    EliteRrhhAuditLog(
      id: 'LOG-2026-008',
      timestamp: DateTime(2026, 10, 6, 15, 45, 12),
      userName: 'Paola Torrico',
      action: 'MODIFICACION_TURNO',
      reference: 'SFT-002',
      detail:
          'Ajuste en margen de tolerancia de turno diurno de seguridad a 10 minutos.',
      sha256Hash:
          '6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e',
    ),
  ];

  List<EliteDisciplinaryRecord> getDisciplinaryRecords() =>
      List.unmodifiable(_disciplinaryRecords);

  void addDisciplinaryRecord(EliteDisciplinaryRecord record) {
    _disciplinaryRecords.insert(0, record);
    addAuditLog(
      EliteRrhhAuditLog(
        id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        userName: 'Paola Torrico',
        action: 'EMISION_MEMORANDUM',
        reference: record.memorandumCode,
        detail: 'Emisión de sanción ${record.severity.label} para ${record.employeeName}',
        sha256Hash:
            '${record.memorandumCode.hashCode.abs().toRadixString(16).padLeft(16, '0')}${'DISC'.hashCode.abs().toRadixString(16).padLeft(16, '0')}${DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(32, 'a')}',
      ),
    );
  }

  List<EliteTerminationSettlement> getSettlements() =>
      List.unmodifiable(_settlements);

  void addSettlement(EliteTerminationSettlement settlement) {
    _settlements.insert(0, settlement);
    addAuditLog(
      EliteRrhhAuditLog(
        id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        userName: 'Paola Torrico',
        action: 'CREACION_FINIQUITO',
        reference: settlement.id,
        detail:
            'Cálculo de finiquito por ${settlement.reason.label} para ${settlement.employeeName} (Bs. ${settlement.totalSettlement.toStringAsFixed(2)})',
        sha256Hash:
            '${settlement.id.hashCode.abs().toRadixString(16).padLeft(16, '0')}${'SETTLE'.hashCode.abs().toRadixString(16).padLeft(16, '0')}${DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(32, 'f')}',
      ),
    );
  }

  void updateSettlementStatus(String id, String newStatus) {
    final idx = _settlements.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _settlements[idx] = _settlements[idx].copyWith(status: newStatus);
      addAuditLog(
        EliteRrhhAuditLog(
          id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          userName: 'Paola Torrico',
          action: 'ESTADO_FINIQUITO',
          reference: id,
          detail: 'Actualización de estado de finiquito $id a $newStatus',
          sha256Hash:
              '${id.hashCode.abs().toRadixString(16).padLeft(16, '0')}${'STATUS'.hashCode.abs().toRadixString(16).padLeft(16, '0')}${DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(32, 'c')}',
        ),
      );
    }
  }

  List<EliteRrhhAuditLog> getAuditLogs() => List.unmodifiable(_auditLogs);

  void addAuditLog(EliteRrhhAuditLog log) {
    _auditLogs.insert(0, log);
  }
}



