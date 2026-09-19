import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/units.dart';
import '../../../shared/state/progress_provider.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';
import '../model/scenario_catalog.dart';
import '../viewmodel/multimetro_viewmodel.dart';
import '../widgets/multimetro_display_widget.dart';
import '../widgets/selector_rango_widget.dart';

class LaboratorioMultimetroScreen extends ConsumerWidget {
  const LaboratorioMultimetroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MultimetroState estado = ref.watch(multimetroProvider);
    final MultimetroNotifier notifier = ref.read(multimetroProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio · Multímetro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<EscenarioMultimetro>(
            value: estado.escenario,
            decoration:
                const InputDecoration(labelText: 'Escenario de medición'),
            items: escenariosMultimetro
                .map((e) => DropdownMenuItem(
                    value: e,
                    child:
                        Text(e.descripcion, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (e) {
              if (e != null) notifier.elegirEscenario(e);
            },
          ),
          const SizedBox(height: 16),
          Text('Rango / escala', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SelectorRangoWidget(
            rangos: estado.escenario.rangos,
            seleccionado: estado.rangoSeleccionado,
            onSeleccionar: notifier.elegirRango,
          ),
          const SizedBox(height: 20),
          MultimetroDisplayWidget(
            resultado: estado.resultado,
            unidad: estado.rangoSeleccionado.magnitud.simbolo,
            decimales: estado.rangoSeleccionado.resolucionDecimales,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.bolt),
            label: const Text('Medir'),
            onPressed: notifier.medir,
          ),
          if (estado.mensajeAsistente != null) ...[
            const SizedBox(height: 16),
            TarjetaAsistenteWidget(mensaje: estado.mensajeAsistente!),
          ],
          if (estado.resultado != null && estado.resultado!.enRango) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref
                  .read(progresoProvider.notifier)
                  .registrarEjercicioCompletado('m2'),
              child: const Text('Marcar medición como completada'),
            ),
          ],
        ],
      ),
    );
  }
}
