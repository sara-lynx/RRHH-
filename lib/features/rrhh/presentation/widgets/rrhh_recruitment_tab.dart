import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_summary_dto.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_applicant_edit_dialog.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_recruitment_applicant_drawer.dart';
import 'rrhh_recruitment_kanban.dart';
import 'rrhh_rejection_dialog.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Tab 2: Reclutamiento & Pipeline de Postulantes en formato Tablero Kanban.
class RrhhRecruitmentTab extends StatefulWidget {
  const RrhhRecruitmentTab({super.key});

  @override
  State<RrhhRecruitmentTab> createState() => _RrhhRecruitmentTabState();
}

class _RrhhRecruitmentTabState extends State<RrhhRecruitmentTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhApplicantSummaryDto> _allApplicants = [];

  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    loadApplicants();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> loadApplicants() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final list = await RrhhRepository.current.listApplicants();
      if (!mounted) return;
      setState(() {
        _allApplicants = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar postulantes: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _searchQuery = val.trim().toLowerCase());
    });
  }

  Future<void> _openCreateDialog() async {
    final created = await RrhhApplicantEditDialog.show(context);
    if (created == true && mounted) await loadApplicants();
  }

  Future<void> _openDrawer(int applicantId) async {
    await RrhhRecruitmentApplicantDrawer.show(
      context,
      applicantId,
      onStatusChanged: () {
        if (mounted) loadApplicants();
      },
    );
    if (mounted) await loadApplicants();
  }

  Future<void> _onApplicantDropped(
    RrhhApplicantSummaryDto applicant,
    String targetStage,
  ) async {
    if (applicant.status.toUpperCase() == targetStage) return;

    if (targetStage == 'RECHAZADO') {
      final rejection = await RrhhRejectionDialog.show(
        context,
        applicantCode: applicant.code,
        applicantName: applicant.fullName,
      );

      if (rejection == null) return;

      try {
        await RrhhRepository.current.updateApplicantStatus(
          applicant.id,
          targetStage,
          discardReason: rejection.fullReasonText,
          isEligibleForRehire: rejection.isEligibleForRehire,
        );
        final list = await RrhhRepository.current.listApplicants();
        if (mounted) {
          setState(() => _allApplicants = list);
          RrhhSnackBar.showWarning(
            context,
            'Candidatura de ${applicant.fullName} descartada',
          );
        }
      } catch (e) {
        if (mounted) RrhhSnackBar.showError(context, 'Error: $e');
      }
      return;
    }

    // 1. Actualización atómica en memoria (optimista)
    final previousList = List<RrhhApplicantSummaryDto>.from(_allApplicants);
    final targetIndex = _allApplicants.indexWhere((a) => a.id == applicant.id);
    if (targetIndex != -1) {
      final updatedApplicant = applicant.copyWith(status: targetStage);
      setState(() {
        _allApplicants[targetIndex] = updatedApplicant;
      });
    }

    // 2. Persistencia en segundo plano
    try {
      await RrhhRepository.current.updateApplicantStatus(
        applicant.id,
        targetStage,
      );
      final freshList = await RrhhRepository.current.listApplicants();
      if (mounted) {
        setState(() => _allApplicants = freshList);
        RrhhSnackBar.showInfo(
          context,
          '${applicant.fullName} movido a $targetStage',
        );
      }
    } catch (e) {
      // Revertir ante error
      if (mounted) {
        setState(() => _allApplicants = previousList);
        RrhhSnackBar.showError(
          context,
          'Error al mover postulante: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return RrhhErrorState(
        errorMessage: _errorMessage,
        onRetry: loadApplicants,
      );
    }

    final filtered = _allApplicants.where((a) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery;
      return a.fullName.toLowerCase().contains(q) ||
          a.code.toLowerCase().contains(q) ||
          a.targetPosition.toLowerCase().contains(q) ||
          a.specialty.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 14),
          _buildSearchBar(),
          const SizedBox(height: 14),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RrhhRecruitmentKanban(
                    applicants: filtered,
                    onCardTap: (app) => _openDrawer(app.id),
                    onApplicantDropped: _onApplicantDropped,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reclutamiento & Selección de Personal',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFFF8FAFC)
                    : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tablero Kanban de candidatos, evaluación de aptitudes y preselección de colaboradores',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        RrhhPrimaryActionButton(
          label: 'Registrar Postulante',
          onPressed: _openCreateDialog,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 38,
        constraints: const BoxConstraints(maxWidth: 380),
        child: TextField(
          controller: _searchCtrl,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white, fontSize: 12.5),
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, código o cargo aspirado...',
            hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            prefixIcon: const Icon(
              Icons.search,
              size: 16,
              color: Color(0xFF64748B),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            filled: true,
            fillColor: const Color(0xFF0D111C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1E293B)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1E293B)),
            ),
          ),
        ),
      ),
    );
  }
}
