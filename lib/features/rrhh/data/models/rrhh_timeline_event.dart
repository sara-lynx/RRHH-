import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
export 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    show RrhhTimelineEvent;

/// Categorías canónicas del módulo de Línea de Tiempo y Auditoría
class RrhhTimelineCategory {
  static const String contratacion = 'CONTRATACION';
  static const String asignacion = 'ASIGNACION';
  static const String contractual = 'CONTRATUAL';
  static const String horario = 'HORARIO';
  static const String permiso = 'PERMISO';
  static const String vacaciones = 'VACACIONES';
  static const String incidencia = 'INCIDENCIA';
  static const String desvinculacion = 'DESVINCULACION';
  static const String salarios = 'SALARIOS';
  static const String sistema = 'SISTEMA';

  static const String catalogos = 'CATALOGOS';

  static const List<String> all = [
    'Todas',
    contratacion,
    asignacion,
    contractual,
    horario,
    permiso,
    vacaciones,
    incidencia,
    desvinculacion,
    salarios,
    sistema,
    catalogos,
  ];

  static String getLabel(String category) {
    switch (category.toUpperCase()) {
      case contratacion:
        return 'Contratación / Altas';
      case asignacion:
        return 'Asignación Operativa';
      case contractual:
        return 'Cambio Contractual';
      case horario:
        return 'Horarios y Turnos';
      case permiso:
        return 'Permisos y Licencias';
      case vacaciones:
        return 'Vacaciones';
      case incidencia:
        return 'Régimen Disciplinario';
      case desvinculacion:
        return 'Desvinculaciones';
      case salarios:
        return 'Salarios y Nómina';
      case sistema:
        return 'Sistema / Auditoría';
      case catalogos:
        return 'Catálogos y Organización';
      default:
        return category;
    }
  }
}

/// Representa el cambio en un campo específico para auditoría comparativa
class RrhhAuditFieldChange {
  final String fieldName;
  final String? oldValue;
  final String? newValue;

  const RrhhAuditFieldChange({
    required this.fieldName,
    this.oldValue,
    this.newValue,
  });
}

// Expandos para almacenar metadatos enriquecidos de auditoría en RrhhTimelineEvent
final _sourceTypeExpando = Expando<String>('sourceType');
final _sourceIdExpando = Expando<int>('sourceId');
final _sourceCodeExpando = Expando<String>('sourceCode');
final _employeeNameExpando = Expando<String>('employeeName');
final _employeeCodeExpando = Expando<String>('employeeCode');
final _userRoleExpando = Expando<String>('userRole');
final _ipAddressExpando = Expando<String>('ipAddress');
final _fieldChangesExpando = Expando<List<RrhhAuditFieldChange>>(
  'fieldChanges',
);
final _documentsExpando = Expando<List<String>>('documents');

/// Extensiones para formateo y compatibilidad visual de RrhhTimelineEvent
extension RrhhTimelineEventExtension on RrhhTimelineEvent {
  String get code => 'EVT-${(id ?? 0).toString().padLeft(6, '0')}';
  DateTime get timestamp => date;
  String get action => title;
  String get performedBy => registeredBy;

  String? get sourceType => _sourceTypeExpando[this];
  set sourceType(String? value) => _sourceTypeExpando[this] = value;

  int? get sourceId => _sourceIdExpando[this];
  set sourceId(int? value) => _sourceIdExpando[this] = value;

  String? get sourceCode => _sourceCodeExpando[this];
  set sourceCode(String? value) => _sourceCodeExpando[this] = value;

  String? get employeeName => _employeeNameExpando[this];
  set employeeName(String? value) => _employeeNameExpando[this] = value;

  String? get employeeCode => _employeeCodeExpando[this];
  set employeeCode(String? value) => _employeeCodeExpando[this] = value;

  String? get userRole => _userRoleExpando[this];
  set userRole(String? value) => _userRoleExpando[this] = value;

  String? get ipAddress => _ipAddressExpando[this];
  set ipAddress(String? value) => _ipAddressExpando[this] = value;

  List<RrhhAuditFieldChange>? get fieldChanges => _fieldChangesExpando[this];
  set fieldChanges(List<RrhhAuditFieldChange>? value) =>
      _fieldChangesExpando[this] = value;

  List<String>? get documents => _documentsExpando[this];
  set documents(List<String>? value) => _documentsExpando[this] = value;

  String get categoryLabel => RrhhTimelineCategory.getLabel(category);

  /// Helper encadenable para poblar datos de auditoría
  RrhhTimelineEvent withAuditMetadata({
    String? sourceType,
    int? sourceId,
    String? sourceCode,
    String? employeeName,
    String? employeeCode,
    String? userRole,
    String? ipAddress,
    List<RrhhAuditFieldChange>? fieldChanges,
    List<String>? documents,
  }) {
    if (sourceType != null) this.sourceType = sourceType;
    if (sourceId != null) this.sourceId = sourceId;
    if (sourceCode != null) this.sourceCode = sourceCode;
    if (employeeName != null) this.employeeName = employeeName;
    if (employeeCode != null) this.employeeCode = employeeCode;
    if (userRole != null) this.userRole = userRole;
    if (ipAddress != null) this.ipAddress = ipAddress;
    if (fieldChanges != null) this.fieldChanges = fieldChanges;
    if (documents != null) this.documents = documents;
    return this;
  }
}
