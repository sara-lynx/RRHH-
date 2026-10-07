import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/elite_rrhh_providers.dart';

/// Botón de marcación web rápida para el personal de Oficina en el ERP.
class EliteOfficePunchButton extends ConsumerWidget {
  const EliteOfficePunchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final punchState = ref.watch(officePunchProvider);
    final notifier = ref.read(officePunchProvider.notifier);

    final isClockedIn = punchState.isClockedIn;
    final isCompleted = punchState.isCompleted;

    final inStr = punchState.clockInTime != null
        ? DateFormat('HH:mm').format(punchState.clockInTime!)
        : '';
    final outStr = punchState.clockOutTime != null
        ? DateFormat('HH:mm').format(punchState.clockOutTime!)
        : '';

    final String tooltipMessage;
    if (isCompleted) {
      tooltipMessage =
          'Jornada completada para Paola Torrico ($inStr - $outStr) • IP: ${punchState.ipAddress}';
    } else if (isClockedIn) {
      tooltipMessage =
          'Conectado como Paola Torrico (EMP-002) • IP: ${punchState.ipAddress}. Clic para marcar salida.';
    } else {
      tooltipMessage =
          'Registrar ingreso de jornada administrativa desde el navegador (Paola Torrico).';
    }

    return Tooltip(
      message: tooltipMessage,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xFF0F766E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  content: Text(
                    'Jornada de hoy completada para Paola Torrico ($inStr - $outStr). Registro asentado en el ERP.',
                    style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
                  ),
                ),
              );
              return;
            }

            final wasIn = punchState.isClockedIn;
            notifier.togglePunch();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                backgroundColor:
                    wasIn ? const Color(0xFF059669) : const Color(0xFF0D9488),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                content: Row(
                  children: [
                    Icon(
                      wasIn ? Icons.check_circle_outline : Icons.login_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        wasIn
                            ? 'Salida registrada a las ${DateFormat('HH:mm:ss').format(DateTime.now())} para Paola Torrico (EMP-002). Jornada completada con éxito.'
                            : 'Entrada registrada a las ${DateFormat('HH:mm:ss').format(DateTime.now())} • IP: ${punchState.ipAddress}',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFF0FDF4)
                  : isClockedIn
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFF0D9488),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFFBBF7D0)
                    : isClockedIn
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF0F766E),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle_outline
                      : isClockedIn
                          ? Icons.timer_outlined
                          : Icons.fingerprint,
                  size: 16,
                  color: isCompleted
                      ? const Color(0xFF16A34A)
                      : isClockedIn
                          ? const Color(0xFFB45309)
                          : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  isCompleted
                      ? 'Jornada Completa ($inStr - $outStr)'
                      : isClockedIn
                          ? 'En Jornada ($inStr) • Marcar Salida'
                          : 'Marcar Entrada',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? const Color(0xFF166534)
                        : isClockedIn
                            ? const Color(0xFF92400E)
                            : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
