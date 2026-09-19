import 'package:flutter/material.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';

/// Panel del asistente técnico. Es un sistema de reglas (no un LLM):
/// el estudiante elige una magnitud/necesidad y el asistente recomienda
/// el instrumento adecuado con la regla técnica que justifica la
/// respuesta. Esta misma lógica (AssistantEngine) es la que da feedback
/// dentro de los módulos 2, 3 y 4.
class AsistentePanel extends StatefulWidget {
  const AsistentePanel({super.key});

  @override
  State<AsistentePanel> createState() => _AsistentePanelState();
}

class _AsistentePanelState extends State<AsistentePanel> {
  String? _seleccion;

  static const Map<String, String> _opciones = {
    'voltaje_dc_estable': 'Necesito medir un voltaje DC estable',
    'senal_variable_en_tiempo':
        'Necesito ver cómo cambia una señal en el tiempo',
    'temperatura_proceso': 'Necesito controlar la temperatura de un proceso',
    'distancia_objeto': 'Necesito detectar la distancia a un objeto',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente técnico')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Este asistente usa reglas técnicas explícitas, no un '
                'modelo de lenguaje: cada recomendación viene de una '
                'tabla de decisión de instrumentación, por eso es '
                'consistente y verificable.',
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('¿Qué necesitas hacer?'),
          const SizedBox(height: 8),
          ..._opciones.entries.map(
            (op) => RadioListTile<String>(
              title: Text(op.value),
              value: op.key,
              groupValue: _seleccion,
              onChanged: (v) => setState(() => _seleccion = v),
            ),
          ),
          const SizedBox(height: 16),
          if (_seleccion != null)
            TarjetaAsistenteWidget(
              mensaje: AssistantEngine.recomendarInstrumento(_seleccion!),
            ),
        ],
      ),
    );
  }
}
