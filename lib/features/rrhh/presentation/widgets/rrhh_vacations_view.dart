import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_vacation_balance_tab.dart';
import 'rrhh_vacation_edit_dialog.dart';
import 'rrhh_vacation_records_tab.dart';

/// PANTALLA 09: Control de Vacaciones (Ley General del Trabajo - Bolivia).
/// Submódulo Novedades Laborales (Tab 2).
class RrhhVacationsView extends StatefulWidget {
  const RrhhVacationsView({super.key});

  @override
  State<RrhhVacationsView> createState() => _RrhhVacationsViewState();
}

class _RrhhVacationsViewState extends State<RrhhVacationsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhVacationBalance> _balances = [];
  List<RrhhVacationRecord> _records = [];

  String? _historyEmployeeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final balances = await repo.listVacationBalances();
      final records = await repo.listVacationRecords();

      if (!mounted) return;
      setState(() {
        _balances = balances;
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar los datos de vacaciones: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRegisterNew() async {
    final success = await RrhhVacationEditDialog.show(context);
    if (success == true) {
      await _loadData();
    }
  }

  void _switchToHistoryWithEmployee(String employeeName) {
    setState(() {
      _historyEmployeeFilter = employeeName;
    });
    _tabController.animateTo(1);
  }

  // Métricas calculadas para el Panel de Resumen (4 Cards)
  int get _employeesWithAvailableBalance {
    return _balances
        .where(
          (b) =>
              b.pendingDays > 0 &&
              b.balanceStatus != RrhhVacationBalanceStatus.sinDerecho,
        )
        .length;
  }

  int get _totalPendingDays {
    return _balances.fold<int>(0, (sum, b) => sum + b.pendingDays);
  }

  int get _upcomingExpiringEmployees {
    return _balances.where((b) {
      if (b.pendingDays <= 0) return false;
      if (b.daysUntilAnniversary == null) return false;
      return b.daysUntilAnniversary! <= 30 && b.daysUntilAnniversary! >= 0;
    }).length;
  }

  int get _expiredVacationEmployees {
    return _balances
        .where((b) => b.balanceStatus == RrhhVacationBalanceStatus.vencido)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Column(
        children: [
          // 1. Panel de Resumen (4 Cards) compacto
          _buildSummaryCards(),

          // 2. TabBar de navegación interna con botón [+ Registrar Vacaciones] a la derecha
          _buildTabBar(),

          // 3. TabBarView con Tab 1 y Tab 2
          Expanded(
            child: _errorMessage != null
                ? _buildErrorWidget()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      RrhhVacationBalanceTab(
                        balances: _balances,
                        isLoading: _isLoading,
                        onRefresh: _loadData,
                        onFilterEmployeeInHistory: _switchToHistoryWithEmployee,
                      ),
                      RrhhVacationRecordsTab(
                        records: _records,
                        isLoading: _isLoading,
                        onRefresh: _loadData,
                        initialFilterEmployee: _historyEmployeeFilter,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          // Card 1: Empleados con saldo disponible
          Expanded(
            child: _buildMetricCard(
              title: 'Empleados con saldo disponible',
              value: '$_employeesWithAvailableBalance',
              subtitle: 'de ${_balances.length} activos',
              icon: Icons.people_alt_outlined,
              accentColor: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 14),

          // Card 2: Días pendientes totales
          Expanded(
            child: _buildMetricCard(
              title: 'Días pendientes totales',
              value: '$_totalPendingDays',
              subtitle: 'acumulados en la empresa',
              icon: Icons.event_available_outlined,
              accentColor: const Color(0xFF38BDF8),
            ),
          ),
          const SizedBox(width: 14),

          // Card 3: Próximos vencimientos
          Expanded(
            child: _buildMetricCard(
              title: 'Próximos vencimientos',
              value: '$_upcomingExpiringEmployees',
              subtitle: 'vencen en los próximos 30 días',
              icon: Icons.warning_amber_rounded,
              accentColor: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 14),

          // Card 4: Vacaciones vencidas sin usar (Alerta roja)
          Expanded(
            child: _buildMetricCard(
              title: 'Vacaciones vencidas sin usar',
              value: '$_expiredVacationEmployees',
              subtitle: 'requieren reprogramación legal',
              icon: Icons.error_outline_rounded,
              accentColor: const Color(0xFFEF4444),
              isAlert: _expiredVacationEmployees > 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isAlert
            ? const Color(0xFFEF4444).withValues(alpha: 0.08)
            : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAlert
              ? const Color(0xFFEF4444).withValues(alpha: 0.4)
              : const Color(0xFF1E293B),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF94A3B8),
            labelStyle: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text('Saldo por empleado (${_balances.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.history_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text('Historial de goces (${_records.length})'),
                  ],
                ),
              ),
            ],
          ),
          RrhhPrimaryActionButton(
            label: 'Registrar Vacaciones',
            onPressed: _handleRegisterNew,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 44),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
