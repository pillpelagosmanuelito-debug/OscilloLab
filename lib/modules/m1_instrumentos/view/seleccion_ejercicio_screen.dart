import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/state/progress_provider.dart';
import '../model/instrument_catalog.dart';
import '../model/seleccion_escenario.dart';
import '../viewmodel/instrumentos_viewmodel.dart';

class SeleccionEjercicioScreen extends ConsumerWidget {
  const SeleccionEjercicioScreen({super.key});

  String _nombreInstrumento(String id) {
    return catalogoInstrumentos
        .firstWhere((f) => f.id == id, orElse: () => catalogoInstrumentos.first)
        .nombre;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SeleccionState estado = ref.watch(seleccionProvider);
    final SeleccionNotifier notifier = ref.read(seleccionProvider.notifier);

    if (estado.terminado) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  '${estado.correctas} / ${escenariosSeleccion.length} correctas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (estado.correctas >= (escenariosSeleccion.length * 0.6)) {
                      ref.read(progresoProvider.notifier).registrarEjercicioCompletado('m1');
                    }
                    notifier.reiniciar();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Volver a Instrumentos'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final EscenarioSeleccion escenario = estado.escenarioActual!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${estado.indice + 1}/${escenariosSeleccion.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(escenario.descripcion,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            const SizedBox(height: 20),
            const Text('¿Que instrumento usarias?'),
            const SizedBox(height: 12),
            ...escenario.opciones.map((idOpcion) {
              final bool respondido = estado.respondido;
              final bool esEstaLaElegida = estado.opcionElegida == idOpcion;
              Color? color;
              if (respondido) {
                if (idOpcion == escenario.idCorrectoId) {
                  color = Colors.green.withOpacity(0.25);
                } else if (esEstaLaElegida) {
                  color = Colors.red.withOpacity(0.25);
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade700),
                    ),
                    title: Text(_nombreInstrumento(idOpcion)),
                    onTap: respondido ? null : () => notifier.responder(idOpcion),
                  ),
                ),
              );
            }),
            if (estado.respondido) ...[
              const SizedBox(height: 8),
              Text(
                escenario.explicacion,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: notifier.siguiente,
                  child: const Text('Siguiente'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
