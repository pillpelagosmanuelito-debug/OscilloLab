import 'package:flutter/material.dart';

import 'laboratorio_multimetro_screen.dart';
import 'laboratorio_osciloscopio_screen.dart';

class MedicionesScreen extends StatelessWidget {
  const MedicionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modulo 2 · Mediciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Laboratorio interactivo: elige instrumento, escala/rango y '
            'toma una medicion simulada con error e incertidumbre realistas.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Laboratorio de multimetro'),
              subtitle: const Text('Voltaje DC, corriente y resistencia'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LaboratorioMultimetroScreen()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.monitor_heart_outlined),
              title: const Text('Laboratorio de osciloscopio'),
              subtitle: const Text('Amplitud y frecuencia de senales periodicas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LaboratorioOsciloscopioScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
