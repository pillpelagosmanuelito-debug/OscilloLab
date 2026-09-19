import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/state/progress_provider.dart';
import '../../m1_instrumentos/view/instrumentos_screen.dart';
import '../../m2_mediciones/view/mediciones_screen.dart';
import '../../m3_errores/view/errores_screen.dart';
import '../../m4_calibracion/view/calibracion_screen.dart';
import '../../m5_casos_industriales/view/casos_screen.dart';

class _ModuloInfo {
  const _ModuloInfo(this.clave, this.titulo, this.subtitulo, this.icono, this.pantalla);
  final String clave;
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Widget pantalla;
}

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProgresoState progreso = ref.watch(progresoProvider);
    final List<_ModuloInfo> modulos = [
      const _ModuloInfo('m1', '1 · Instrumentos', 'Multimetro, osciloscopio y sensores',
          Icons.science_outlined, InstrumentosScreen()),
      const _ModuloInfo('m2', '2 · Mediciones', 'Laboratorio interactivo de medicion',
          Icons.speed, MedicionesScreen()),
      const _ModuloInfo('m3', '3 · Errores', 'Sistematico, aleatorio y propagacion',
          Icons.rule, ErroresScreen()),
      const _ModuloInfo('m4', '4 · Calibracion', 'Deteccion y correccion de descalibracion',
          Icons.tune, CalibracionScreen()),
      const _ModuloInfo('m5', '5 · Casos industriales', 'Instrumentacion, control y automatizacion',
          Icons.factory_outlined, CasosScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('OscilloLab'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Laboratorio virtual de instrumentacion y medicion electronica',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Practica interpretando mediciones reales: error, incertidumbre y calibracion.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          ...modulos.map((m) {
            final int completados = progreso.completados[m.clave] ?? 0;
            return Card(
              child: ListTile(
                leading: Icon(m.icono),
                title: Text(m.titulo),
                subtitle: Text(m.subtitulo),
                trailing: completados > 0
                    ? Chip(label: Text('$completados ✓'))
                    : const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => m.pantalla),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
