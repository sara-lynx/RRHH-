import 'package:flutter/foundation.dart';
import 'rrhh_audit_service.dart';

/// Modelo de Empresa o Sede de Servicio Cliente asignada al personal de Elite Multiservicios
class WorkplaceCompanyItem {
  final String id;
  final String name; // Nombre de la empresa o sede cliente
  final String
  serviceCategory; // 'Limpieza', 'Jardinería', 'Sistemas', 'Mantenimiento', 'Seguridad', 'Multiservicios'
  final String address; // Ubicación / Dirección física de la sede
  final String contactPerson; // Nombre del supervisor o enlace
  final String contactPhone; // Teléfono
  final String notes; // Notas operativas / turnos
  final DateTime registeredAt;

  const WorkplaceCompanyItem({
    required this.id,
    required this.name,
    required this.serviceCategory,
    required this.address,
    required this.contactPerson,
    required this.contactPhone,
    required this.notes,
    required this.registeredAt,
  });
}

/// Servicio en memoria para administrar las Empresas y Sedes de Servicios de Elite Multiservicios
class RrhhCompanyService extends ChangeNotifier {
  static final RrhhCompanyService instance = RrhhCompanyService._internal();

  factory RrhhCompanyService() => instance;

  RrhhCompanyService._internal() {
    _seedInitialCompanies();
  }

  final List<WorkplaceCompanyItem> _companies = [];

  List<WorkplaceCompanyItem> get allCompanies => List.unmodifiable(_companies);

  List<String> get companyNames =>
      _companies.map((c) => c.name).toSet().toList();

  void _seedInitialCompanies() {
    final now = DateTime.now();
    _companies.addAll([
      WorkplaceCompanyItem(
        id: 'comp-1',
        name: 'Kolping - Central',
        serviceCategory: 'Multiservicios',
        address: 'Calle Bernabé Sosa #250, Barrio Central',
        contactPerson: 'Ing. Marcelo Vargas',
        contactPhone: '+591 71023450',
        notes:
            'Sede con cuadrilla mixta de mantenimiento preventivo y limpieza.',
        registeredAt: now.subtract(const Duration(days: 180)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-2',
        name: 'Ventura Mall',
        serviceCategory: 'Limpieza',
        address: '4to Anillo y Av. San Martín, Equipetrol Norte',
        contactPerson: 'Lic. Claudia Peña',
        contactPhone: '+591 76011223',
        notes: 'Cobertura de limpieza operativa en turnos diurno y nocturno.',
        registeredAt: now.subtract(const Duration(days: 150)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-3',
        name: 'Kinesis',
        serviceCategory: 'Limpieza',
        address: 'Av. Cristobal de Mendoza (2do Anillo)',
        contactPerson: 'Dr. Alejandro Antelo',
        contactPhone: '+591 78044556',
        notes: 'Desinfección de consultorios y áreas de rehabilitación física.',
        registeredAt: now.subtract(const Duration(days: 120)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-4',
        name: 'Segomeit',
        serviceCategory: 'Mantenimiento',
        address: 'Parque Industrial PI-24',
        contactPerson: 'Ing. Roberto Paz',
        contactPhone: '+591 71399887',
        notes: 'Mantenimiento técnico industrial y jardinería perimetral.',
        registeredAt: now.subtract(const Duration(days: 90)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-5',
        name: 'Acegal',
        serviceCategory: 'Limpieza',
        address: 'Av. Banzer Km 6.5',
        contactPerson: 'Ing. Gabriel Soliz',
        contactPhone: '+591 75012398',
        notes: 'Limpieza y aseo profundo de galpones y áreas de carga.',
        registeredAt: now.subtract(const Duration(days: 75)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-6',
        name: 'Alianza Bravsa',
        serviceCategory: 'Limpieza',
        address: 'Doble Vía a La Guardia Km 4',
        contactPerson: 'Lic. Valeria Morales',
        contactPhone: '+591 72155443',
        notes: 'Servicios de aseo y mantenimiento de oficinas administrativas.',
        registeredAt: now.subtract(const Duration(days: 60)),
      ),
      WorkplaceCompanyItem(
        id: 'comp-7',
        name: 'Oficina Central Elite',
        serviceCategory: 'Sistemas',
        address: 'Av. San Martín #150, Edif. Torre Duo',
        contactPerson: 'Dirección de Operaciones',
        contactPhone: '+591 71092834',
        notes: 'Base central operativa, gerencia, soporte de sistemas y RRHH.',
        registeredAt: now.subtract(const Duration(days: 300)),
      ),
    ]);
  }

  /// Actualizar datos de una empresa cliente existente
  void updateCompany({
    required String id,
    required String name,
    required String serviceCategory,
    required String address,
    required String contactPerson,
    required String contactPhone,
    required String notes,
  }) {
    final idx = _companies.indexWhere((c) => c.id == id);
    if (idx != -1) {
      final old = _companies[idx];
      _companies[idx] = WorkplaceCompanyItem(
        id: id,
        name: name.trim(),
        serviceCategory: serviceCategory,
        address: address.trim(),
        contactPerson: contactPerson.trim(),
        contactPhone: contactPhone.trim(),
        notes: notes.trim(),
        registeredAt: old.registeredAt,
      );
      notifyListeners();

      // Registro auditable en la Bitácora de RRHH
      RrhhAuditService.instance.logMovement(
        category: 'EXPEDIENTE',
        action: 'Actualización de Datos de Empresa Cliente',
        employeeCode: 'SEDE-CLIENTE',
        employeeName: name.trim(),
        details:
            'Se actualizaron los datos de la sede "${old.name}" (actualizada a "${name.trim()}"). Rubro: $serviceCategory, Dirección: ${address.trim()}, Contacto: ${contactPerson.trim()} (${contactPhone.trim()}).',
        severity: 'INFO',
      );
    }
  }

  /// Buscar empresa por nombre
  WorkplaceCompanyItem? findByName(String name) {
    try {
      return _companies.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
