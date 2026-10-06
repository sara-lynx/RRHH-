import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../extensions/rrhh_model_extensions.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Tab 3 del Submódulo Personal: "Contrataciones en Curso".
/// Muestra los postulantes en estado SELECCIONADO con expedientes de contratación abiertos.
class RrhhHiringDossiersTab extends StatefulWidget {
  final void Function(int dossierId)? onOpenDossier;

  const RrhhHiringDossiersTab({
    super.key,
    this.onOpenDossier,
  });

  @override
  State<RrhhHiringDossiersTab> createState() => _RrhhHiringDossiersTabState();
}

class _RrhhHiringDossiersTabState extends State<RrhhHiringDossiersTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhHiringDossier> _dossiers = [];

  String? _searchQuery;
  String? _selectedStatusFilter; // null = 'TODOS'

  @override
  void initState() {
    super.initState();
    _loadDossiers();
  }

  Future<void> _loadDossiers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await RrhhRepository.current.listActiveDossiers();
      if (mounted) {
        setState(() {
          _dossiers = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar contrataciones en curso: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _togglePauseStatus(RrhhHiringDossier dossier) async {
    final dossierId = dossier.id;
    if (dossierId == null) return;
    final newStatus = dossier.status == 'pausado' ? 'abierto' : 'pausado';
    try {
      await RrhhRepository.current.updateDossierStatus(dossierId, newStatus);
      await _loadDossiers();
      if (mounted) {
        RrhhSnackBar.showInfo(
          context,
          newStatus == 'pausado'
              ? 'Expediente ${dossier.applicantCode} pausado'
              : 'Expediente ${dossier.applicantCode} reanudado',
        );
      }
    } catch (e) {
      if (mounted) {
        RrhhSnackBar.showError(
          context,
          'Error al cambiar estado del expediente: $e',
        );
      }
    }
  }

  List<RrhhHiringDossier> get _filteredDossiers {
    return _dossiers.where((d) {
      if (_searchQuery != null && _searchQuery!.trim().isNotEmpty) {
        final q = _searchQuery!.trim().toLowerCase();
        final matchesCode = d.applicantCode.toLowerCase().contains(q);
        final matchesName = d.applicantName.toLowerCase().contains(q);
        final matchesArea = (d.targetArea ?? '').toLowerCase().contains(q);
        final matchesPos = (d.targetPosition ?? '').toLowerCase().contains(q);
        if (!matchesCode && !matchesName && !matchesArea && !matchesPos) {
          return false;
        }
      }

      if (_selectedStatusFilter != null && _selectedStatusFilter!.isNotEmpty) {
        if (d.dossierStatusLabel.toLowerCase() !=
            _selectedStatusFilter!.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return RrhhErrorState(
        errorMessage: _errorMessage,
        onRetry: _loadDossiers,
      );
    }

    final filtered = _filteredDossiers;

    return RefreshIndicator(
      onRefresh: _loadDossiers,
      color: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFF0F172A),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - 48.0;
          final tableWidth = availableWidth > 1140.0 ? availableWidth : 1140.0;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader(),
                const SizedBox(height: 14),
                _buildFiltersBar(),
                const SizedBox(height: 14),
                _buildTableContainer(filtered, tableWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contrataciones en Curso',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF8FAFC),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Postulantes seleccionados en proceso de documentación y formalización',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: _loadDossiers,
          icon: const Icon(Icons.refresh, size: 14),
          label: Text(
            'Actualizar',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF94A3B8),
            side: const BorderSide(color: Color(0xFF1E293B)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    final filters = [
      'TODOS',
      'Documentos pendientes',
      'En proceso',
      'Listo para convertir',
      'Pausado',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Campo de búsqueda
          SizedBox(
            width: 280,
            height: 36,
            child: TextField(
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Buscar postulante, código o cargo...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,
                fillColor: const Color(0xFF111827),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1E293B)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1E293B)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                ),
              ),
            ),
          ),

          // Chips de filtro por estado
          ...filters.map((filter) {
            final isSelected = filter == 'TODOS'
                ? (_selectedStatusFilter == null ||
                      _selectedStatusFilter!.isEmpty)
                : (_selectedStatusFilter?.toLowerCase() ==
                      filter.toLowerCase());

            return FilterChip(
              selected: isSelected,
              label: Text(filter),
              labelStyle: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFF8FAFC)
                    : const Color(0xFF94A3B8),
              ),
              backgroundColor: const Color(0xFF111827),
              selectedColor: const Color(0xFF2563EB).withValues(alpha: 0.25),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF1E293B),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              onSelected: (_) {
                setState(() {
                  _selectedStatusFilter = filter == 'TODOS' ? null : filter;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableContainer(
    List<RrhhHiringDossier> items,
    double tableWidth,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: tableWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(),
              if (_isLoading)
                _buildLoadingSkeleton()
              else if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: RrhhEmptyState(
                      title: 'No hay contrataciones en curso',
                      description:
                          'Los postulantes seleccionados aparecerán aquí automáticamente para gestionar su expediente.',
                      icon: Icons.assignment_outlined,
                    ),
                  ),
                )
              else
                ...items.map((dossier) => _buildTableRow(dossier)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          _headerCell('CÓDIGO', width: 95),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _headerCell('POSTULANTE'),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _headerCell('ÁREA / CARGO ASPIRADO'),
          ),
          const SizedBox(width: 8),
          _headerCell('FECHA SELECCIÓN', width: 125),
          const SizedBox(width: 8),
          _headerCell('ESTADO EXPEDIENTE', width: 165),
          const SizedBox(width: 8),
          _headerCell('PROGRESO', width: 140),
          const SizedBox(width: 8),
          _headerCell('ACCIONES', width: 140, alignment: Alignment.centerRight),
        ],
      ),
    );
  }

  Widget _headerCell(
    String label, {
    double? width,
    Alignment alignment = Alignment.centerLeft,
  }) {
    final text = Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.4,
      ),
    );

    if (width != null) {
      return Container(
        width: width,
        alignment: alignment,
        child: text,
      );
    }
    return Container(
      alignment: alignment,
      child: text,
    );
  }

  Widget _buildTableRow(RrhhHiringDossier dossier) {
    return _DossierTableRow(
      dossier: dossier,
      onOpen: () {
        if (widget.onOpenDossier != null && dossier.id != null) {
          widget.onOpenDossier!(dossier.id!);
        }
      },
      onTogglePause: () => _togglePauseStatus(dossier),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cargando contrataciones...',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DossierTableRow extends StatefulWidget {
  final RrhhHiringDossier dossier;
  final VoidCallback onOpen;
  final VoidCallback onTogglePause;

  const _DossierTableRow({
    required this.dossier,
    required this.onOpen,
    required this.onTogglePause,
  });

  @override
  State<_DossierTableRow> createState() => _DossierTableRowState();
}

class _DossierTableRowState extends State<_DossierTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.dossier;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF131C2E)
                : const Color(0xFF0D111C),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
            ),
          ),
          child: Row(
            children: [
              // Código
              SizedBox(
                width: 95,
                child: Text(
                  d.applicantCode,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Postulante
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.15),
                      child: Text(
                        d.applicantName.isNotEmpty
                            ? d.applicantName[0].toUpperCase()
                            : 'P',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.applicantName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF8FAFC),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (d.applicantCi.isNotEmpty)
                            Text(
                              'CI: ${d.applicantCi}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Área / Cargo aspirado
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.targetPosition ?? '---',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCBD5E1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${d.targetArea ?? '---'} · ${d.workplaceType ?? '---'}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Fecha Selección
              SizedBox(
                width: 125,
                child: Text(
                  _formatDate(d.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Estado Expediente (chip con punto)
              SizedBox(
                width: 165,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildStatusChip(d.dossierStatusLabel),
                ),
              ),
              const SizedBox(width: 8),

              // Progreso (X/6 secciones + bar)
              SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      d.progressLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: d.progressFraction,
                        minHeight: 5,
                        backgroundColor: const Color(0xFF1E293B),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          d.completedSectionsCount >= 5
                              ? const Color(0xFF10B981)
                              : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Acciones
              SizedBox(
                width: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: widget.onOpen,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Abrir',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                      color: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF1E293B)),
                      ),
                      onSelected: (val) {
                        if (val == 'toggle_pause') {
                          widget.onTogglePause();
                        } else if (val == 'open') {
                          widget.onOpen();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.folder_open_outlined,
                                size: 14,
                                color: Color(0xFF38BDF8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Abrir Expediente',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFFF8FAFC),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle_pause',
                          child: Row(
                            children: [
                              Icon(
                                d.status == 'pausado'
                                    ? Icons.play_arrow_outlined
                                    : Icons.pause_circle_outline,
                                size: 14,
                                color: const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                d.status == 'pausado'
                                    ? 'Reanudar proceso'
                                    : 'Pausar proceso',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFFF8FAFC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    Color dotColor;
    Color textColor;
    Color bgColor;
    Color borderColor;

    switch (label.toLowerCase()) {
      case 'documentos pendientes':
        dotColor = const Color(0xFFF59E0B);
        textColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFF59E0B).withValues(alpha: 0.12);
        borderColor = const Color(0xFFF59E0B).withValues(alpha: 0.3);
        break;
      case 'en proceso':
        dotColor = const Color(0xFF38BDF8);
        textColor = const Color(0xFF38BDF8);
        bgColor = const Color(0xFF2563EB).withValues(alpha: 0.12);
        borderColor = const Color(0xFF2563EB).withValues(alpha: 0.3);
        break;
      case 'listo para convertir':
        dotColor = const Color(0xFF10B981);
        textColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withValues(alpha: 0.12);
        borderColor = const Color(0xFF10B981).withValues(alpha: 0.3);
        break;
      case 'pausado':
      default:
        dotColor = const Color(0xFF94A3B8);
        textColor = const Color(0xFF94A3B8);
        bgColor = const Color(0xFF64748B).withValues(alpha: 0.12);
        borderColor = const Color(0xFF64748B).withValues(alpha: 0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }
}
