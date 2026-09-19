import 'package:flutter/material.dart';

import '../../../core/measurement/instrument_model.dart';
import '../../../theme/app_theme.dart';

class MultimetroDisplayWidget extends StatelessWidget {
  const MultimetroDisplayWidget({
    super.key,
    required this.resultado,
    required this.unidad,
    this.decimales = 2,
  });

  final ResultadoMedicion? resultado;
  final String unidad;
  final int decimales;

  /// toStringAsFixed exige un entero >= 0; algunos rangos (p. ej. escalas
  /// de resistencia en decenas/centenas) usan resolucionDecimales negativo
  /// internamente para el redondeo, así que aquí se recorta a 0 solo para
  /// la presentación visual.
  int get _decimalesVisibles => decimales < 0 ? 0 : decimales;

  @override
  Widget build(BuildContext context) {
    final String texto = resultado == null
        ? '— —'
        : (resultado!.enRango
            ? resultado!.valor.toStringAsFixed(_decimalesVisibles)
            : 'OL');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.grafito,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.verdeFosforo.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(texto, style: AppTheme.textoDisplay),
          const SizedBox(height: 4),
          Text(unidad,
              style: TextStyle(color: AppTheme.verdeFosforo.withOpacity(0.7))),
          if (resultado != null && resultado!.enRango) ...[
            const SizedBox(height: 6),
            Text(
              '± ${resultado!.incertidumbre.toStringAsFixed(_decimalesVisibles)} (k=2)',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.ambarMultimetro.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
