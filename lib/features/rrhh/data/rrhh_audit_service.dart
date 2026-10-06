import 'package:flutter/foundation.dart';

/// Modelo de Evento de Auditoría exclusivo para el Módulo de Recursos Humanos
class RrhhAuditEvent {
  final String id;
  final DateTime timestamp;
  final String
  category; // 'ALTA_PERSONAL', 'CONTRATO_SALARIO', 'PERMISO_VACACION', 'TRASLADO_SEDE', 'BAJA_RETIRO', 'DOCUMENTOS', 'EXPEDIENTE'
  final String action; // Descripción corta de la acción
  final String employeeCode; // Ej: EMP-001
  final String employeeName; // Nombre del colaborador
  final String details; // Explicación completa del movimiento
  final String
  performedBy; // Usuario responsable (ej. encargada de RRHH / Admin)
  final String severity; // 'INFO', 'ADVERTENCIA', 'CRITICO'

  const RrhhAuditEvent({
    required this.id,
    required this.timestamp,
    required this.category,
    required this.action,
    required this.employeeCode,
    required this.employeeName,
    required this.details,
    required this.performedBy,
    required this.severity,
  });
}

/// Servicio en memoria / Singleton para la Bitácora Exclusiva de RRHH
/// Garantiza un aislamiento total: NO almacena ni recibe eventos de seguridad,
/// sesiones de TI, contraseñas ni CRM.
class RrhhAuditService extends ChangeNotifier {
  static final RrhhAuditService instance = RrhhAuditService._internal();

  factory RrhhAuditService() => instance;

  RrhhAuditService._internal() {
    _seedInitialEvents();
  }

  final List<RrhhAuditEvent> _events = [];

  List<RrhhAuditEvent> get allEvents => List.unmodifiable(_events);

  void _seedInitialEvents() {
    final now = DateTime.now();
    _events.addAll([
      RrhhAuditEvent(
        id: 'rrhh-log-101',
        timestamp: now.subtract(const Duration(minutes: 25)),
        category: 'ALTA_PERSONAL',
        action: 'Registro de Nuevo Colaborador',
        employeeCode: 'EMP-004',
        employeeName: 'Andrea Soliz Arteaga',
        details:
            'Alta en sistema con ficha digital completa. Sueldo pactado: Bs. 4,000.00. 6/6 documentos físicos verificados (CI, Croquis, Aviso Luz, FELCC, Foto 3x4, SUS).',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'INFO',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-102',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 15)),
        category: 'PERMISO_VACACION',
        action: 'Aprobación de Vacación Anual',
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Rios',
        details:
            'Aprobada vacación reglamentaria de 10 días hábiles (05/10/2024 al 15/10/2024). Notificado al módulo de Asistencia para no generar falta en reloj biométrico.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'INFO',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-103',
        timestamp: now.subtract(const Duration(hours: 5, minutes: 40)),
        category: 'TRASLADO_SEDE',
        action: 'Reasignación de Sede Operativa',
        employeeCode: 'EMP-002',
        employeeName: 'Valeria Justiniano Paz',
        details:
            'Reasignación de puesto y sede: De Kolping Central a Ventura Mall para cobertura del turno nocturno de supervisión.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'ADVERTENCIA',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-104',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        category: 'CONTRATO_SALARIO',
        action: 'Alerta Preventiva de Vencimiento de Contrato',
        employeeCode: 'EMP-003',
        employeeName: 'Jorge Luis Aguilera',
        details:
            'Contrato a Plazo Fijo próximo a vencer (fecha límite: 09/01/2025). Marcado para decisión: prórroga legal o conversión a contrato por tiempo indefinido.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'CRITICO',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-105',
        timestamp: now.subtract(const Duration(days: 2, hours: 1)),
        category: 'DOCUMENTOS',
        action: 'Recepción de Documento Faltante',
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Rios',
        details:
            'Recepción y archivo físico de certificado de Antecedentes FELCC actualizado. Checklist de expediente ahora al 100%.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'INFO',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-106',
        timestamp: now.subtract(const Duration(days: 4)),
        category: 'BAJA_RETIRO',
        action: 'Registro de Desvinculación y Finiquito',
        employeeCode: 'EMP-012',
        employeeName: 'Martín Paredes Choque',
        details:
            'Desvinculación formal por Fin de Contrato a Plazo Fijo. Devolución de implementos y EPP completada. Expediente archivado sin eliminación de base de datos.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'CRITICO',
      ),
      RrhhAuditEvent(
        id: 'rrhh-log-107',
        timestamp: now.subtract(const Duration(days: 6)),
        category: 'CONTRATO_SALARIO',
        action: 'Ajuste Salarial por Ascenso',
        employeeCode: 'EMP-002',
        employeeName: 'Valeria Justiniano Paz',
        details:
            'Ascenso de Técnico Operativo a Supervisora de Servicios. Sueldo pactado actualizado a Bs. 3,800.00 con firma de adenda de contrato.',
        performedBy: 'rogeliovladimir2016@gmail.com',
        severity: 'INFO',
      ),
    ]);
  }

  /// Registrar un nuevo evento de RRHH
  void logMovement({
    required String category,
    required String action,
    required String employeeCode,
    required String employeeName,
    required String details,
    required String severity,
    String performedBy = 'rogeliovladimir2016@gmail.com',
  }) {
    final event = RrhhAuditEvent(
      id: 'rrhh-log-${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      category: category,
      action: action,
      employeeCode: employeeCode,
      employeeName: employeeName,
      details: details,
      performedBy: performedBy,
      severity: severity,
    );
    _events.insert(0, event);
    notifyListeners();
  }

  /// Contadores rápidos para tarjetas de resumen
  int get totalCount => _events.length;
  int get altasCount =>
      _events.where((e) => e.category == 'ALTA_PERSONAL').length;
  int get permisosCount =>
      _events.where((e) => e.category == 'PERMISO_VACACION').length;
  int get criticalCount => _events.where((e) => e.severity == 'CRITICO').length;
}
