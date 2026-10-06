import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_contract_modification_dialog.dart';
import 'rrhh_edit_employee_dialog.dart';
import 'rrhh_employee_detail_header.dart';
import 'rrhh_employee_detail_tab_assignment.dart';
import 'rrhh_employee_detail_tab_contract.dart';
import 'rrhh_employee_detail_tab_documents.dart';
import 'rrhh_employee_detail_tab_history.dart';
import 'rrhh_employee_detail_tab_personal.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Modal Raíz del Expediente del Colaborador (Pantalla 03 - Detalle 360°).
/// Orquesta la carga de datos del repositorio y el TabBar con las 5 pestañas de ley.
class RrhhEmployeeDetailDialog extends StatefulWidget {
  final int employeeId;
  final bool hasPermission;
  final bool hasCompensationPermission;
  final bool canEdit;
  final bool canModifyContract;

  const RrhhEmployeeDetailDialog({
    super.key,
    required this.employeeId,
    this.hasPermission = true,
    this.hasCompensationPermission = true,
    this.canEdit = true,
    this.canModifyContract = true,
  });

  static Future<void> show(
    BuildContext context,
    int employeeId, {
    bool hasPermission = true,
    bool hasCompensationPermission = true,
    bool canEdit = true,
    bool canModifyContract = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => RrhhEmployeeDetailDialog(
        employeeId: employeeId,
        hasPermission: hasPermission,
        hasCompensationPermission: hasCompensationPermission,
        canEdit: canEdit,
        canModifyContract: canModifyContract,
      ),
    );
  }

  @override
  State<RrhhEmployeeDetailDialog> createState() =>
      _RrhhEmployeeDetailDialogState();
}

class _RrhhEmployeeDetailDialogState extends State<RrhhEmployeeDetailDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;

  RrhhEmployee? _employee;
  List<RrhhEmployeeDocument> _documents = [];
  RrhhAssignment? _assignment;
  List<RrhhTimelineEvent> _timelineEvents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    if (widget.hasPermission) {
      _loadEmployeeData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployeeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final results = await Future.wait([
        repo.getEmployeeById(widget.employeeId),
        repo.listDocuments(widget.employeeId),
        repo.getCurrentAssignment(widget.employeeId),
        repo.listTimelineEvents(employeeId: widget.employeeId),
      ]);

      if (mounted) {
        setState(() {
          _employee = results[0] as RrhhEmployee?;
          _documents = (results[1] as List<RrhhEmployeeDocument>?) ?? [];
          _assignment = results[2] as RrhhAssignment?;
          _timelineEvents = (results[3] as List<RrhhTimelineEvent>?) ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudo cargar el expediente del colaborador: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasPermission) {
      return Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: RrhhForbiddenState(requiredPermission: 'rrhh.personal.view'),
        ),
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
      },
      child: Focus(
        autofocus: true,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 860,
              maxHeight: 740,
            ),
            child: _buildDialogContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    if (_isLoading) {
      return _buildSkeletonState();
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: RrhhErrorState(
          errorMessage: _errorMessage,
          onRetry: _loadEmployeeData,
        ),
      );
    }

    if (_employee == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: RrhhEmptyState(
          title: 'Colaborador no encontrado',
          description:
              'No se encontró el registro del empleado en la base de datos.',
          icon: Icons.person_off_outlined,
        ),
      );
    }

    return Column(
      children: [
        // 1. Header con avatar, nombre, badges y botón de cierre
        RrhhEmployeeDetailHeader(
          employee: _employee!,
          canEdit: widget.canEdit,
          canModifyContract: widget.canModifyContract,
          onClose: () => Navigator.of(context).pop(),
          onEdit: () async {
            final updated = await RrhhEditEmployeeDialog.show(
              context,
              _employee!,
            );
            if (updated == true) {
              await _loadEmployeeData();
              if (mounted) {
                RrhhSnackBar.showSuccess(
                  context,
                  'Ficha actualizada correctamente',
                );
              }
            }
          },
          onModifyContract: () async {
            final result = await RrhhContractModificationDialog.show(
              context,
              _employee!,
            );
            if (result != null && result.success) {
              await _loadEmployeeData();
              if (mounted) {
                RrhhSnackBar.showSuccess(
                  context,
                  'Datos contractuales modificados correctamente. El cambio quedó registrado en el historial.',
                );
                if (result.isSensitive) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      RrhhSnackBar.showWarning(
                        context,
                        'Este cambio será notificado a Contabilidad para su procesamiento.',
                      );
                    }
                  });
                }
              }
            }
          },
        ),

        // 2. TabBar interno con 5 pestañas
        Container(
          color: const Color(0xFF0F172A),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 2,
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: const Color(0xFF94A3B8),
            labelStyle: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(height: 38, text: '1. Datos Personales'),
              Tab(height: 38, text: '2. Contrato & Salario'),
              Tab(height: 38, text: '3. Documentos Físicos'),
              Tab(height: 38, text: '4. Asignación Vigente'),
              Tab(height: 38, text: '5. Historial'),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFF1E293B)),

        // 3. TabBarView con el contenido de cada pestaña
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              RrhhEmployeeDetailTabPersonal(employee: _employee!),
              RrhhEmployeeDetailTabContract(
                employee: _employee!,
                hasCompensationPermission: widget.hasCompensationPermission,
              ),
              RrhhEmployeeDetailTabDocuments(
                employee: _employee!,
                documents: _documents,
              ),
              RrhhEmployeeDetailTabAssignment(assignment: _assignment),
              RrhhEmployeeDetailTabHistory(events: _timelineEvents),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 220,
                      height: 16,
                      color: const Color(0xFF1E293B),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 320,
                      height: 12,
                      color: const Color(0xFF1E293B),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 38,
            color: const Color(0xFF111827),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
