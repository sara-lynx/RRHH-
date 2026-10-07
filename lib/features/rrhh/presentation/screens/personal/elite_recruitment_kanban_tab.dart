import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_recruitment_models.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_recruitment_providers.dart';

/// Tab 2: Tablero Kanban interactivo para Reclutamiento & Selección de Personal.
class EliteRecruitmentKanbanTab extends ConsumerStatefulWidget {
  const EliteRecruitmentKanbanTab({super.key});

  @override
  ConsumerState<EliteRecruitmentKanbanTab> createState() =>
      _EliteRecruitmentKanbanTabState();
}

class _EliteRecruitmentKanbanTabState
    extends ConsumerState<EliteRecruitmentKanbanTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _showCreateApplicantDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final ciCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final salaryCtrl = TextEditingController(text: '3000');
    final siteCtrl = TextEditingController(text: 'Sede Central');
    EmployeeWorkplaceType workplaceType = EmployeeWorkplaceType.campo;
    String serviceLine = EliteCostCenter.seguridad;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          size: 20,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registrar Nuevo Postulante',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Ingreso directo a la etapa de Nuevos Postulantes',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 20),
                        color: const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Nombre Completo
                  _buildFormField(
                    label: 'Nombre Completo *',
                    controller: nameCtrl,
                    hint: 'Ej. Juan Pérez Quispe',
                  ),
                  const SizedBox(height: 12),

                  // CI y Teléfono
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Cédula de Identidad (CI) *',
                          controller: ciCtrl,
                          hint: 'Ej. 7891234 LP',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          label: 'Teléfono / WhatsApp *',
                          controller: phoneCtrl,
                          hint: 'Ej. 71234567',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Correo y Cargo Aspirado
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Correo Electrónico',
                          controller: emailCtrl,
                          hint: 'juan.perez@gmail.com',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          label: 'Cargo al que Postula *',
                          controller: positionCtrl,
                          hint: 'Ej. Guardia de Seguridad',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tipo de Personal y Pretensión Salarial
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ámbito Laboral *',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildWorkplaceOption(
                                  label: 'Campo',
                                  selected: workplaceType ==
                                      EmployeeWorkplaceType.campo,
                                  onTap: () => setDialogState(
                                    () => workplaceType =
                                        EmployeeWorkplaceType.campo,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildWorkplaceOption(
                                  label: 'Oficina',
                                  selected: workplaceType ==
                                      EmployeeWorkplaceType.oficina,
                                  onTap: () => setDialogState(
                                    () => workplaceType =
                                        EmployeeWorkplaceType.oficina,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          label: 'Pretensión Salarial (Bs) *',
                          controller: salaryCtrl,
                          hint: 'Ej. 3200',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty ||
                              ciCtrl.text.trim().isEmpty ||
                              phoneCtrl.text.trim().isEmpty ||
                              positionCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Por favor complete los campos obligatorios.'),
                                backgroundColor: Color(0xFFDC2626),
                              ),
                            );
                            return;
                          }

                          final salary =
                              double.tryParse(salaryCtrl.text.trim()) ?? 2500.0;

                          ref
                              .read(rrhhApplicantsProvider.notifier)
                              .registerApplicant(
                                fullName: nameCtrl.text.trim(),
                                ci: ciCtrl.text.trim(),
                                phone: phoneCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                                targetPosition: positionCtrl.text.trim(),
                                expectedSalary: salary,
                                workplaceType: workplaceType,
                                serviceLineCode: serviceLine,
                                assignedSite: siteCtrl.text.trim(),
                              );

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF0F766E),
                              content: Text(
                                'Postulante ${nameCtrl.text.trim()} registrado exitosamente en Nuevos Postulantes.',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(
                          'Guardar Postulante',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 36,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    const BorderSide(color: Color(0xFF0D9488), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkplaceOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF0F766E) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredApplicants = ref.watch(rrhhFilteredApplicantsProvider);
    final metrics = ref.watch(recruitmentMetricsProvider);

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // ===================================================================
          // 1. BARRA DE ACCIÓN SUPERIOR COMPACTA (~46px)
          // ===================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                // Buscador
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 32,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        ref
                            .read(recruitmentSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Buscar postulante por nombre, código o cargo...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(
                                          recruitmentSearchQueryProvider.notifier)
                                      .setQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D9488),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Botón Refrescar
                IconButton(
                  tooltip: 'Refrescar postulantes',
                  onPressed: () {
                    ref.invalidate(rrhhApplicantsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0F172A),
                        duration: const Duration(seconds: 1),
                        content: Text(
                          'Embudo de postulantes actualizado.',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),

                // Botón Primario: Registrar Postulante
                ElevatedButton.icon(
                  onPressed: () => _showCreateApplicantDialog(context),
                  icon: const Icon(Icons.person_add_outlined, size: 15),
                  label: Text(
                    'Registrar Postulante',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

          // ===================================================================
          // 2. CHIPS DE MÉTRICAS HORIZONTALES
          // ===================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMetricPill(
                    icon: Icons.people_outline,
                    label: 'Total Postulantes',
                    value: '${metrics.total}',
                    color: const Color(0xFF0284C7),
                    bgColor: const Color(0xFFF0F9FF),
                    borderColor: const Color(0xFFBAE6FD),
                  ),
                  const SizedBox(width: 10),
                  _buildMetricPill(
                    icon: Icons.hourglass_top_outlined,
                    label: 'En Proceso Activo',
                    value: '${metrics.active}',
                    color: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                    borderColor: const Color(0xFFFDE68A),
                  ),
                  const SizedBox(width: 10),
                  _buildMetricPill(
                    icon: Icons.check_circle_outline,
                    label: 'Seleccionados',
                    value: '${metrics.selected}',
                    color: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFFA7F3D0),
                  ),
                  const SizedBox(width: 10),
                  _buildMetricPill(
                    icon: Icons.cancel_outlined,
                    label: 'Descartados',
                    value: '${metrics.discarded}',
                    color: const Color(0xFFDC2626),
                    bgColor: const Color(0xFFFEF2F2),
                    borderColor: const Color(0xFFFECACA),
                  ),
                ],
              ),
            ),
          ),

          // ===================================================================
          // 3. TABLERO KANBAN DE 6 COLUMNAS (EXPANDED CON SCROLL HORIZONTAL)
          // ===================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: RecruitmentStage.values.map((stage) {
                        final stageApplicants = filteredApplicants
                            .where((a) => a.stage == stage)
                            .toList();

                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x040F172A),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: DragTarget<EliteApplicant>(
                            onWillAcceptWithDetails: (details) =>
                                details.data.stage != stage,
                            onAcceptWithDetails: (details) {
                              ref
                                  .read(rrhhApplicantsProvider.notifier)
                                  .moveStage(details.data.id, stage);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: const Color(0xFF0F172A),
                                  content: Text(
                                    '${details.data.fullName} movido a ${stage.label}.',
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ),
                              );
                            },
                            builder: (context, candidateData, rejectedData) {
                              final isHovering = candidateData.isNotEmpty;

                              return Container(
                                color: isHovering
                                    ? stage.bgColor.withValues(alpha: 0.5)
                                    : Colors.transparent,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Cabecera de la columna Kanban
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: stage.bgColor,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: stage.borderColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: stage.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              stage.label.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: stage.color,
                                                letterSpacing: 0.5,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: stage.borderColor,
                                              ),
                                            ),
                                            child: Text(
                                              '${stageApplicants.length}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: stage.color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Lista de Tarjetas de Postulantes
                                    Expanded(
                                      child: stageApplicants.isEmpty
                                          ? Center(
                                              child: Text(
                                                'Sin postulantes',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.5,
                                                  color:
                                                      const Color(0xFF94A3B8),
                                                ),
                                              ),
                                            )
                                          : ListView.separated(
                                              padding: const EdgeInsets.all(10),
                                              itemCount: stageApplicants.length,
                                              separatorBuilder: (context, index) =>
                                                  const SizedBox(height: 8),
                                              itemBuilder: (context, index) {
                                                final applicant =
                                                    stageApplicants[index];
                                                return _buildApplicantCard(
                                                  applicant,
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(EliteApplicant applicant) {
    final isField = applicant.workplaceType == EmployeeWorkplaceType.campo;
    final avatarBg =
        isField ? const Color(0xFFCCFBF1) : const Color(0xFFE0F2FE);
    final avatarColor =
        isField ? const Color(0xFF0F766E) : const Color(0xFF0369A1);

    final cardContent = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040F172A),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: Código y Menú rápido de traslado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  applicant.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<RecruitmentStage>(
                tooltip: 'Mover a otra etapa',
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_horiz, size: 16, color: Color(0xFF94A3B8)),
                onSelected: (targetStage) {
                  ref
                      .read(rrhhApplicantsProvider.notifier)
                      .moveStage(applicant.id, targetStage);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF0F172A),
                      duration: const Duration(seconds: 1),
                      content: Text(
                        '${applicant.fullName} movido a ${targetStage.label}',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                  );
                },
                itemBuilder: (context) => RecruitmentStage.values
                    .where((s) => s != applicant.stage)
                    .map(
                      (s) => PopupMenuItem(
                        value: s,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: s.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              s.label,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nombre con avatar
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: avatarBg,
                child: Text(
                  _getInitials(applicant.fullName),
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'CI: ${applicant.ci}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Cargo postulado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFCCFBF1)),
            ),
            child: Text(
              applicant.targetPosition,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F766E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),

          // Teléfono y Salario
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                applicant.phone,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: const Color(0xFF475569),
                ),
              ),
              const Spacer(),
              Text(
                'Bs. ${applicant.expectedSalary.toStringAsFixed(0)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return LongPressDraggable<EliteApplicant>(
      data: applicant,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 250,
          child: cardContent,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: cardContent,
      ),
      child: cardContent,
    );
  }
}
