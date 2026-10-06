import 'package:flutter/material.dart';
import 'presentation/views/rrhh_catalogs_view.dart';
import 'presentation/views/rrhh_dashboard_view.dart';
import 'presentation/views/rrhh_novedades_tabs_view.dart';
import 'presentation/views/rrhh_organization_view.dart';
import 'presentation/views/rrhh_personal_view.dart';
import 'presentation/views/rrhh_placeholder_view.dart';
import 'presentation/views/rrhh_reportes_tabs_view.dart';
import 'presentation/views/rrhh_turnos_view.dart';
import 'presentation/views/rrhh_hiring_dossier_detail_view.dart';
import 'presentation/widgets/rrhh_attendance_view.dart';
import 'presentation/widgets/rrhh_disciplinary_view.dart';
import 'presentation/widgets/rrhh_employee_detail_dialog.dart';
import 'presentation/widgets/rrhh_leave_requests_view.dart';
import 'presentation/widgets/rrhh_vacations_view.dart';
import 'presentation/widgets/rrhh_terminations_view.dart';
import 'presentation/widgets/rrhh_payroll_view.dart';
import 'presentation/widgets/rrhh_audit_log_view.dart';

/// Rutas oficiales para el módulo RRHH.
/// Estructura organizada en 7 entradas de menú superior con tabs internos
/// preservando retrocompatibilidad total con las 14 pantallas individuales.
class RrhhRoutes {
  // ---------------------------------------------------------------------------
  // 7 Rutas de Nivel Superior (Menú Acordeón Reorganizado + Catálogos)
  // ---------------------------------------------------------------------------
  static const String dashboard = '/rrhh/dashboard';
  static const String personal = '/rrhh/personal';
  static const String organizacion = '/rrhh/organizacion';
  static const String novedades = '/rrhh/novedades';
  static const String asistencia = '/rrhh/asistencia';
  static const String reportes = '/rrhh/reportes';
  static const String catalogos = '/rrhh/catalogos';

  // ---------------------------------------------------------------------------
  // Rutas Específicas / Sub-pantallas (Retrocompatibilidad e Invocación Directa)
  // ---------------------------------------------------------------------------
  static const String directorio = '/rrhh/personal/directorio';
  static const String contrataciones = '/rrhh/personal/contrataciones';
  static const String contratacionesDetalle =
      '/rrhh/personal/contrataciones/:dossierId';
  static const String expediente = '/rrhh/expediente';
  static const String postulantes = '/rrhh/postulantes';
  static const String contratacion = '/rrhh/contratacion';
  static const String areas = '/rrhh/organizacion/areas';
  static const String turnos = '/rrhh/turnos';
  static const String permisos = '/rrhh/permisos';
  static const String novedadesPermisos = '/rrhh/novedades/permisos';
  static const String vacaciones = '/rrhh/vacaciones';
  static const String novedadesVacaciones = '/rrhh/novedades/vacaciones';
  static const String disciplina = '/rrhh/disciplina';
  static const String novedadesDisciplina = '/rrhh/novedades/disciplina';
  static const String bajas = '/rrhh/bajas';
  static const String novedadesDesvinculaciones =
      '/rrhh/novedades/desvinculaciones';
  static const String novedadesNomina = '/rrhh/novedades-nomina';
  static const String novedadesNominaAlt = '/rrhh/novedades/nomina';
  static const String asistenciaCampo = '/rrhh/asistencia-campo';
  static const String bitacora = '/rrhh/bitacora';
  static const String reportesBitacora = '/rrhh/reportes/bitacora';

  /// Rutas canónicas del acordeón lateral
  static const List<String> topLevelRoutes = [
    dashboard,
    personal,
    organizacion,
    novedades,
    asistencia,
    reportes,
    catalogos,
  ];

  /// Lista exhaustiva de las pantallas funcionales
  static const List<String> allRoutes = [
    dashboard,
    personal,
    contrataciones,
    contratacionesDetalle,
    expediente,
    postulantes,
    contratacion,
    organizacion,
    turnos,
    permisos,
    novedadesPermisos,
    vacaciones,
    novedadesVacaciones,
    disciplina,
    novedadesDisciplina,
    bajas,
    novedadesNomina,
    novedadesNominaAlt,
    asistenciaCampo,
    bitacora,
    reportesBitacora,
    catalogos,
  ];

  /// Generador de vistas de nivel superior (Contenedores con pestañas)
  static Widget buildTopLevelView(
    String route, {
    String? tab,
    void Function(int index)? onNavigateToTab,
  }) {
    switch (route) {
      case dashboard:
        return buildView(dashboard, onNavigateToTab: onNavigateToTab);
      case personal:
        return RrhhPersonalView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case contrataciones:
        return const RrhhPersonalView(
          initialTab: 'contrataciones',
        );
      case organizacion:
        return RrhhOrganizationView(
          initialTab: tab,
        );
      case novedades:
        return RrhhNovedadesTabsView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case novedadesPermisos:
      case permisos:
        return const RrhhLeaveRequestsView();
      case novedadesVacaciones:
      case vacaciones:
        return const RrhhVacationsView();
      case asistencia:
      case asistenciaCampo:
        return buildView(asistenciaCampo, onNavigateToTab: onNavigateToTab);
      case reportes:
        return RrhhReportesTabsView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case catalogos:
        return const RrhhCatalogsView();
      default:
        return buildView(route, onNavigateToTab: onNavigateToTab);
    }
  }

  /// Generador de vistas individuales (pantallas hijas o modales)
  static Widget buildView(
    String route, {
    void Function(int index)? onNavigateToTab,
  }) {
    switch (route) {
      case dashboard:
        return const RrhhDashboardView();
      case personal:
      case directorio:
        return const RrhhPersonalView();
      case contrataciones:
        return const RrhhPersonalView(initialTab: 'contrataciones');
      case expediente:
        return const Center(
          child: RrhhEmployeeDetailDialog(
            employeeId: 1,
          ),
        );
      case postulantes:
        return const RrhhPlaceholderView(
          title: '04. Reclutamiento & Pipeline de Postulantes',
          blockName: 'Bloque 2',
          description:
              'Gestión del embudo de candidatos, evaluación curricular, entrevistas y filtro previo a contratación.',
          icon: Icons.person_search_outlined,
        );
      case contratacion:
        return const RrhhPlaceholderView(
          title: '05. Contratación Formal (Wizard / Stepper)',
          blockName: 'Módulo en desarrollo',
          description:
              'Promoción guiada de postulante seleccionado a empleado o alta directa, validando checklist legal y bloqueo de antecedentes FELCC.',
          icon: Icons.how_to_reg_outlined,
        );
      case organizacion:
      case areas:
        return const RrhhOrganizationView();

      case turnos:
        return const RrhhTurnosView();
      case permisos:
      case novedadesPermisos:
        return const RrhhLeaveRequestsView();
      case vacaciones:
      case novedadesVacaciones:
        return const RrhhVacationsView();
      case disciplina:
      case novedadesDisciplina:
        return const RrhhDisciplinaryView();
      case bajas:
      case novedadesDesvinculaciones:
        return const RrhhTerminationsView();
      case novedadesNomina:
      case novedadesNominaAlt:
        return const RrhhPayrollView();
      case asistenciaCampo:
        return const RrhhAttendanceView();
      case bitacora:
      case reportesBitacora:
        return const RrhhAuditLogView();
      case catalogos:
        return const RrhhCatalogsView();
      default:
        if (route.startsWith('/rrhh/personal/contrataciones/')) {
          final idStr = route.replaceFirst(
            '/rrhh/personal/contrataciones/',
            '',
          );
          final dossierId = int.tryParse(idStr) ?? 1;
          return RrhhHiringDossierDetailView(dossierId: dossierId);
        }
        return const Center(child: Text('Ruta de RRHH no encontrada'));
    }
  }
}
