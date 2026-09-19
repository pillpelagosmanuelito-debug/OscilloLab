import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/units.dart';
import '../../../shared/state/progress_provider.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';
import '../model/calibration_case.dart';
import '../viewmodel/calibracion_viewmodel.dart';

class CalibracionScreen extends ConsumerWidget {
  const CalibracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalibracionState estado = ref.watch(calibracionProvider);
    final CalibracionNotifier notifier = ref.read(calibracionProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Modulo 4 · Calibracion')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<CasoCalibracion>(
            value: estado.caso,
            decoration:
                const InputDecoration(labelText: 'Instrumento a calibrar'),
            items: casosCalibracion
                .map((c) => DropdownMenuItem(
                    value: c,
                    child:
                        Text(c.descripcion, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (c) {
              if (c != null) notifier.elegirCaso(c);
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Patron bajo: ${estado.caso.patronBajo} ${estado.caso.rango.magnitud.simbolo}'),
                  Text(
                      'Patron alto: ${estado.caso.patronAlto} ${estado.caso.rango.magnitud.simbolo}'),
                  const SizedBox(height: 8),
                  const Text(
                    'Toma varias lecturas en cada patron y promedia, para '
                    'reducir el ruido antes de estimar ganancia y offset '
                    '(calibracion de dos puntos).',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.tune),
            label:
                const Text('Medir ambos patrones (25 lecturas c/u) y calibrar'),
            onPressed: notifier.medirYCalibrar,
          ),
          if (estado.medido) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Promedio en patron bajo: ${estado.promedioBajo!.toStringAsFixed(4)}'),
                    Text(
                        'Promedio en patron alto: ${estado.promedioAlto!.toStringAsFixed(4)}'),
                    const Divider(),
                    Text(
                        'Ganancia estimada: ${estado.estimada!.ganancia.toStringAsFixed(4)} (ideal 1.0000)'),
                    Text(
                        'Offset estimado: ${estado.estimada!.offset.toStringAsFixed(4)} (ideal 0.0000)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TarjetaAsistenteWidget(mensaje: estado.mensajeAsistente!),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref
                  .read(progresoProvider.notifier)
                  .registrarEjercicioCompletado('m4'),
              child: const Text('Marcar calibracion como completada'),
            ),
          ],
        ],
      ),
    );
  }
}
