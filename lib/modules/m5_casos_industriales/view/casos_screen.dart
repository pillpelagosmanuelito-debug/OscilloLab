import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/units.dart';
import '../../../shared/state/progress_provider.dart';
import '../model/industrial_case.dart';
import '../viewmodel/casos_viewmodel.dart';

class CasosScreen extends ConsumerWidget {
  const CasosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CasoIndustrialState estado = ref.watch(casosIndustrialesProvider);
    final CasosIndustrialesNotifier notifier =
        ref.read(casosIndustrialesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 5 · Casos industriales')),
      body: estado.terminado
          ? _Final(estado: estado, notifier: notifier, ref: ref)
          : _PasoActual(estado: estado, notifier: notifier),
    );
  }
}

class _PasoActual extends StatelessWidget {
  const _PasoActual({required this.estado, required this.notifier});
  final CasoIndustrialState estado;
  final CasosIndustrialesNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final CasoIndustrial caso = estado.casoActual!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(caso.contexto,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          const SizedBox(height: 20),
          if (estado.paso == PasoCaso.seleccionInstrumento)
            _pasoInstrumento(context, caso),
          if (estado.paso == PasoCaso.medicion) _pasoMedicion(context, caso),
          if (estado.paso == PasoCaso.decisionAccion)
            _pasoAccion(context, caso),
          if (estado.paso == PasoCaso.resultado) _pasoResultado(context, caso),
        ],
      ),
    );
  }

  Widget _pasoInstrumento(BuildContext context, CasoIndustrial caso) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 1: ¿qué instrumento usarías?'),
        const SizedBox(height: 12),
        ...caso.opcionesInstrumento.map(
          (op) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => notifier.elegirInstrumento(op.key),
              child:
                  Align(alignment: Alignment.centerLeft, child: Text(op.value)),
            ),
          ),
        ),
        if (estado.instrumentoCorrecto != null) ...[
          const SizedBox(height: 8),
          Text(
            estado.instrumentoCorrecto!
                ? 'Correcto. ${caso.justificacionInstrumento}'
                : 'No es la mejor opción. ${caso.justificacionInstrumento}',
          ),
        ],
      ],
    );
  }

  Widget _pasoMedicion(BuildContext context, CasoIndustrial caso) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 2: toma la medición con el instrumento correcto.'),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: notifier.medir, child: const Text('Medir')),
      ],
    );
  }

  Widget _pasoAccion(BuildContext context, CasoIndustrial caso) {
    final resultado = estado.resultadoMedicion!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lectura del instrumento: ${resultado.textoConIncertidumbre(2)} '
            '${caso.rango.magnitud.simbolo}'),
        const SizedBox(height: 16),
        const Text('Paso 3: según esa lectura, ¿qué acción tomarías?'),
        const SizedBox(height: 12),
        ...caso.opcionesAccion.map(
          (op) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => notifier.elegirAccion(op.key),
              child:
                  Align(alignment: Alignment.centerLeft, child: Text(op.value)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pasoResultado(BuildContext context, CasoIndustrial caso) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          estado.accionCorrecta!
              ? 'Decisión correcta.'
              : 'Esa no era la mejor decisión.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(caso.justificacionAccion),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: notifier.siguienteCaso,
          child: const Text('Siguiente caso'),
        ),
      ],
    );
  }
}

class _Final extends StatelessWidget {
  const _Final(
      {required this.estado, required this.notifier, required this.ref});
  final CasoIndustrialState estado;
  final CasosIndustrialesNotifier notifier;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.factory_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
                '${estado.puntaje} / ${casosIndustriales.length * 2} decisiones correctas',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (estado.puntaje >= casosIndustriales.length) {
                  ref
                      .read(progresoProvider.notifier)
                      .registrarEjercicioCompletado('m5');
                }
                notifier.reiniciar();
              },
              child: const Text('Reiniciar casos'),
            ),
          ],
        ),
      ),
    );
  }
}
