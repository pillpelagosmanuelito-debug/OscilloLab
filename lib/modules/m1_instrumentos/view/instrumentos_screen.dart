import 'package:flutter/material.dart';

import '../model/instrument_catalog.dart';
import 'instrumento_detalle_screen.dart';
import 'seleccion_ejercicio_screen.dart';

class InstrumentosScreen extends StatelessWidget {
  const InstrumentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modulo 1 · Instrumentos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Fichas tecnicas: funcionamiento, caracteristicas, aplicaciones '
            'y errores comunes de cada instrumento del laboratorio.',
          ),
          const SizedBox(height: 16),
          ...catalogoInstrumentos.map(
            (ficha) => Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: Text(ficha.nombre),
                subtitle: Text(ficha.categoria),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InstrumentoDetalleScreen(ficha: ficha),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.quiz_outlined),
            label: const Text('Ejercicio: ¿que instrumento usarias?'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const SeleccionEjercicioScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
