import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_memorandums_tab.dart';
import 'elite_new_memorandum_dialog.dart';
import 'elite_rrhh_audit_tab.dart';
import 'elite_settlements_tab.dart';

/// Pantalla contenedora de alta densidad para el Submódulo 6:
/// "Régimen Disciplinario y Bajas" (Memorándums, Finiquitos LGT y Auditoría Inmutable).
class EliteLegalShellScreen extends ConsumerStatefulWidget {
  const EliteLegalShellScreen({super.key});

  @override
  ConsumerState<EliteLegalShellScreen> createState() =>
      _EliteLegalShellScreenState();
}

class _EliteLegalShellScreenState extends ConsumerState<EliteLegalShellScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _currentTab) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(rrhhLegalMetricsProvider);
    final disciplinaryList = ref.watch(rrhhDisciplinaryProvider);
    final settlementsList = ref.watch(rrhhSettlementsProvider);
    final auditLogsList = ref.watch(rrhhAuditLogsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // -------------------------------------------------------------------
          // CABECERA SUPERIOR COMPACTA (FILA 1 + FILA 2)
          // -------------------------------------------------------------------
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              children: [
                // =============================================================
                // FILA 1 (~38px): Título + Botones de Acción
                // =============================================================
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Régimen Disciplinario y Bajas',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          'Elite Multiservicios S.R.L.',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Botón Outline: Exportar Reporte Legal
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: const Color(0xFF0F172A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              content: Text(
                                'Generando Informe Legal y Cuadro de Legajos de Elite Multiservicios S.R.L. en PDF oficial...',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 15,
                          color: Color(0xFF475569),
                        ),
                        label: Text(
                          'Exportar Reporte Legal',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botón Primario: + Nuevo Memorándum (Verde #0D9488)
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const EliteNewMemorandumDialog(),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Nuevo Memorándum',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 0,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                ),

                // =============================================================
                // FILA 2 (~36px en fila única protegida): Pill Tabs + Métricas
                // =============================================================
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Izquierda: Pill Tabs compactas
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildPillTab(
                                      index: 0,
                                      icon: Icons.gavel_outlined,
                                      label: 'Memorándums y Sanciones',
                                      badgeText: '(${disciplinaryList.length})',
                                    ),
                                    _buildPillTab(
                                      index: 1,
                                      icon: Icons.receipt_outlined,
                                      label: 'Finiquitos y Liquidaciones',
                                      badgeText: '(${settlementsList.length})',
                                    ),
                                    _buildPillTab(
                                      index: 2,
                                      icon: Icons.history_outlined,
                                      label: 'Bitácora de Auditoría',
                                      badgeText: '(${auditLogsList.length})',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Derecha: Chips Métricos Inline protegidos
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildMetricChip(
                                    icon: Icons.warning_amber_outlined,
                                    iconColor: const Color(0xFFD97706),
                                    label:
                                        'Sanciones: ${metrics.activeSanctionsCount}',
                                    bgColor: const Color(0xFFFFFBEB),
                                    borderColor: const Color(0xFFFDE68A),
                                    textColor: const Color(0xFFB45309),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildMetricChip(
                                    icon: Icons.payments_outlined,
                                    iconColor: const Color(0xFF2563EB),
                                    label:
                                        'Finiquitos: Bs. ${metrics.settlementsInProgressTotalBs.toStringAsFixed(2)}',
                                    bgColor: const Color(0xFFEFF6FF),
                                    borderColor: const Color(0xFFDBEAFE),
                                    textColor: const Color(0xFF1E40AF),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildMetricChip(
                                    icon: Icons.verified_user_outlined,
                                    iconColor: const Color(0xFF0D9488),
                                    label: 'Auditoría: 100% Inmutable',
                                    bgColor: const Color(0xFFF0FDFA),
                                    borderColor: const Color(0xFFCCFBF1),
                                    textColor: const Color(0xFF0F766E),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // ÁREA PRINCIPAL EN EXPANDED (80% DEL ESPACIO VISUAL ÚTIL)
          // -------------------------------------------------------------------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                EliteMemorandumsTab(),
                EliteSettlementsTab(),
                EliteRrhhAuditTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constructor de pestaña tipo Pill Tab compacta
  Widget _buildPillTab({
    required int index,
    required IconData icon,
    required String label,
    required String badgeText,
  }) {
    final isSelected = _currentTab == index;

    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
        setState(() => _currentTab = index);
      },
      borderRadius: BorderRadius.circular(4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.5,
              color: isSelected
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
            if (badgeText.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                badgeText,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Chip métrico compacto con ícono y texto
  Widget _buildMetricChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
