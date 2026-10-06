import 'package:flutter/material.dart';
import '../widgets/rrhh_audit_log_view.dart';

/// Vista de Reportes y Auditoría (Entrada 06 del menú RRHH).
///
/// Al contener una única sección activa, renderiza directamente la Bitácora
/// de Movimientos (Pantalla 14 — Trazabilidad inmutable) con su header compacto,
/// eliminando encabezados duplicados y barras de pestañas innecesarias.
class RrhhReportesTabsView extends StatelessWidget {
  final String? initialTab;
  final void Function(int index)? onNavigateToTab;

  const RrhhReportesTabsView({
    super.key,
    this.initialTab,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return const RrhhAuditLogView();
  }
}
