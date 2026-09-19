import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/state/progress_provider.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';
import '../viewmodel/errores_viewmodel.dart';
import 'propagacion_screen.dart';

class ErroresScreen extends ConsumerWidget {
  const ErroresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ErroresState estado = ref.watch(erroresProvider);
    final ErroresNotifier notifier = ref.read(erroresProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo 3 · Errores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.functions),
            tooltip: 'Ejercicio de propagación',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PropagacionScreen()),
            ),
          ),
        ],
      ),
      body: estado.terminado
          ? _ResultadoFinal(estado: estado, notifier: notifier, ref: ref)
          : _Ejercicio(estado: estado, notifier: notifier),
    );
  }
}

class _Ejercicio extends StatelessWidget {
  const _Ejercicio({required this.estado, required this.notifier});
  final ErroresState estado;
  final ErroresNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final caso = estado.casoActual!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(caso.descripcion,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          const SizedBox(height: 16),
          if (!estado.medido)
            ElevatedButton.icon(
              icon: const Icon(Icons.science),
              label: const Text('Tomar 1 lectura y promedio de 30 lecturas'),
              onPressed: notifier.medir,
            )
          else ...[
            Text('Lectura única: ${estado.lecturaUnica!.toStringAsFixed(3)}'),
            Text(
                'Promedio de 30 lecturas: ${estado.promedioLecturas!.toStringAsFixed(3)}'),
            const SizedBox(height: 16),
            const Text(
                '¿El error dominante de este instrumento es sistemático o aleatorio?'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: estado.respondido
                        ? null
                        : () => notifier.responder('sistemático'),
                    child: const Text('Sistemático'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: estado.respondido
                        ? null
                        : () => notifier.responder('aleatorio'),
                    child: const Text('Aleatorio'),
                  ),
                ),
              ],
            ),
          ],
          if (estado.mensajeAsistente != null) ...[
            const SizedBox(height: 16),
            TarjetaAsistenteWidget(mensaje: estado.mensajeAsistente!),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: notifier.siguiente,
                child: const Text('Siguiente caso')),
          ],
        ],
      ),
    );
  }
}

class _ResultadoFinal extends StatelessWidget {
  const _ResultadoFinal(
      {required this.estado, required this.notifier, required this.ref});
  final ErroresState estado;
  final ErroresNotifier notifier;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_outlined, size: 64),
            const SizedBox(height: 16),
            Text('${estado.correctas} casos correctos',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (estado.correctas >= 2) {
                  ref
                      .read(progresoProvider.notifier)
                      .registrarEjercicioCompletado('m3');
                }
                notifier.reiniciar();
              },
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}
