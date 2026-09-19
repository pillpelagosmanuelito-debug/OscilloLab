import 'package:flutter/material.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../shared/widgets/tarjeta_asistente_widget.dart';

/// Panel del asistente tecnico. Es un sistema de reglas (no un LLM):
/// el estudiante elige una magnitud/necesidad y el asistente recomienda
/// el instrumento adecuado con la regla tecnica que justifica la
/// respuesta. Esta misma logica (AssistantEngine) es la que da feedback
/// dentro de los modulos 2, 3 y 4.
class AsistentePanel extends StatefulWidget {
  const AsistentePanel({super.key});

  @override
  State<AsistentePanel> createState() => _AsistentePanelState();
}

class _AsistentePanelState extends State<AsistentePanel> {
  String? _seleccion;

  static const Map<String, String> _opciones = {
    'voltaje_dc_estable': 'Necesito medir un voltaje DC estable',
    'senal_variable_en_tiempo': 'Necesito ver como cambia una senal en el tiempo',
    'temperatura_proceso': 'Necesito controlar la temperatura de un proceso',
    'distancia_objeto': 'Necesito detectar la distancia a un objeto',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente tecnico')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Este asistente usa reglas tecnicas explicitas, no un '
                'modelo de lenguaje: cada recomendacion viene de una '
                'tabla de decision de instrumentacion, por eso es '
                'consistente y verificable.',
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('¿Que necesitas hacer?'),
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
