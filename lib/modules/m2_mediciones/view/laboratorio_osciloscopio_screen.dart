import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/instrument_model.dart';
import '../../../shared/state/progress_provider.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';
import '../model/scenario_catalog.dart';
import '../viewmodel/osciloscopio_viewmodel.dart';
import '../widgets/osciloscopio_pantalla_widget.dart';

class LaboratorioOsciloscopioScreen extends ConsumerWidget {
  const LaboratorioOsciloscopioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OsciloscopioState estado = ref.watch(osciloscopioProvider);
    final OsciloscopioNotifier notifier = ref.read(osciloscopioProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio · Osciloscopio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<EscenarioOsciloscopio>(
            value: estado.escenario,
            decoration: const InputDecoration(labelText: 'Escenario de medicion'),
            items: escenariosOsciloscopio
                .map((e) => DropdownMenuItem(value: e, child: Text(e.descripcion, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (e) {
              if (e != null) notifier.elegirEscenario(e);
            },
          ),
          const SizedBox(height: 16),
          OsciloscopioPantallaWidget(muestras: estado.muestras),
          const SizedBox(height: 8),
          Text(
            'Escala vertical: ${estado.escenario.rangoVoltaje.etiqueta} · '
            'Forma: ${estado.escenario.formaOnda}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ResultadoCard(
                  titulo: 'Amplitud (Vpp)',
                  resultado: estado.resultadoVpp,
                  unidad: 'Vpp',
                  onMedir: notifier.medirVpp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ResultadoCard(
                  titulo: 'Frecuencia',
                  resultado: estado.resultadoFrecuencia,
                  unidad: 'Hz',
                  onMedir: notifier.medirFrecuencia,
                ),
              ),
            ],
          ),
          if (estado.mensajeAsistente != null) ...[
            const SizedBox(height: 16),
            TarjetaAsistenteWidget(mensaje: estado.mensajeAsistente!),
          ],
          if (estado.resultadoVpp != null && estado.resultadoVpp!.enRango) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref.read(progresoProvider.notifier).registrarEjercicioCompletado('m2'),
              child: const Text('Marcar medicion como completada'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultadoCard extends StatelessWidget {
  const _ResultadoCard({
    required this.titulo,
    required this.resultado,
    required this.unidad,
    required this.onMedir,
  });

  final String titulo;
  final ResultadoMedicion? resultado;
  final String unidad;
  final VoidCallback onMedir;

  @override
  Widget build(BuildContext context) {
    final ResultadoMedicion? r = resultado;
    final bool ok = r != null && r.enRango;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(titulo, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              r == null ? '—' : (ok ? '${r.valor.toStringAsFixed(2)} $unidad' : 'OL'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (ok)
              Text(
                '± ${r.incertidumbre.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: onMedir, child: const Text('Medir')),
          ],
        ),
      ),
    );
  }
}
